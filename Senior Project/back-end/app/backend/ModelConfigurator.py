import google.generativeai as genai
from .DataStorageManager import DataStorageManager
import asyncio
from typing import Dict, Any, Optional, List
import time
from datetime import datetime
import os
import random
from dotenv import load_dotenv

class ModelConfigurator:
    """
    A class to configure the GenAI library using a hardcoded API key and model name.
    With rate limiting for Gemini API and specific error handling.
    """
    
    def __init__(self):
        """
        Initialize the configurator.
        """
        
        load_dotenv()  # Load environment variables from .env file
        
        self.api_key: str = os.getenv("API_KEY")
        
        # self.api_key = "AIzaSyC1ik7rvxVddbPXdzRHJGpTbxJ05neFRF4"
        self.model_name = "gemini-2.0-flash"
        self.lock = asyncio.Lock()
        
        # Keep track of recent API calls to implement sliding window rate limiting
        self.recent_calls = []
        self.max_requests_per_minute = 15
        self.current_backoff = 0
        
        # Global state to track if we're in a backoff period
        self.in_backoff_until = 0
    def configure_genai(self):
        """
        Configure the GenAI library using the provided API key and model name.
        """
        genai.configure(api_key=self.api_key)
        print(f"GenAI configured successfully with API key: {self.api_key[:4]}... and model: {self.model_name}")

    def get_model_name(self) -> str:
        """
        Get the configured model name.

        Returns:
            The model name being used.
        """
        return self.model_name
        
    async def should_throttle(self):
        """
        Check if we need to throttle requests based on recent activity and backoff state
        Returns (should_throttle, wait_time_in_seconds)
        """
        async with self.lock:
            current_time = time.time()
            
            # First check if we're in a global backoff period
            if current_time < self.in_backoff_until:
                wait_time = self.in_backoff_until - current_time
                return True, wait_time
            
            # Clean up old timestamps (older than 60 seconds)
            self.recent_calls = [t for t in self.recent_calls if current_time - t < 60]
            
            # If we have too many recent calls, throttle
            if len(self.recent_calls) >= self.max_requests_per_minute:
                # Calculate time until oldest call is more than 60 seconds ago
                wait_time = 60 - (current_time - self.recent_calls[0]) + 1  # +1 for safety
                return True, max(wait_time, 1)  # At least 1 second wait
                
            # We're good to go
            self.recent_calls.append(current_time)
            return False, 0
    
    async def handle_error(self, error):
        """
        Handle API errors with exponential backoff
        """
        async with self.lock:
            # Check if it's likely a rate limit error
            error_str = str(error).lower()
            rate_limit_indicators = ["rate limit", "quota", "too many", "429", "500", "internal server"]
            
            is_rate_limit = any(indicator in error_str for indicator in rate_limit_indicators)
            
            if is_rate_limit:
                # Implement exponential backoff
                if self.current_backoff == 0:
                    self.current_backoff = 60  # Start with 60 second backoff
                else:
                    self.current_backoff = min(self.current_backoff * 2, 300)  # Max 5 minutes
                
                # Add some jitter to prevent thundering herd
                jitter = random.uniform(0, 5)
                backoff_time = self.current_backoff + jitter
                
                # Set global backoff until this time
                self.in_backoff_until = time.time() + backoff_time
                
                with open("gem_resp.txt", "a") as f:
                    f.write(f"{datetime.now()} - Rate limit detected. Backing off for {backoff_time:.2f} seconds\n")
                    
                return backoff_time
            else:
                # Not a rate limit error, reset backoff but still wait a bit
                self.current_backoff = 0
                return 1  # 1 second wait for non-rate-limit errors
    
    async def generateResponse(self, label: str, query: str, plant: str, history) -> str:
        """
        Generate a response with rate limit handling and backoff
        """
        throttle, wait_time = await self.should_throttle()
        
        if throttle:
            # Log the throttling
            with open("gem_resp.txt", "a") as f:
                f.write(f"{datetime.now()} - Throttling request, waiting for {wait_time:.2f} seconds\n")
            
            # Wait until we can proceed
            await asyncio.sleep(wait_time)
            # Try again after waiting
            return await self.generateResponse(label, query, plant, history)
        
        try:
            # Set up the model
            generation_config = {
                "temperature": 0.5,
                "top_p": 1,
                "top_k": 1,
                "max_output_tokens": 2048,
            }

            model = genai.GenerativeModel(model_name=self.model_name, generation_config=generation_config)
            convo = model.start_chat(history=history)

            if label == '':
                prompt = f"""You are a highly specialized assistant that only provides information about plants.

                - If the user input is a general greeting such as "hi", "hello", or "hey", respond politely like: "Hi! How can I help you?" — but DO NOT mention tomatoes in your greeting.

                - If the input is a question or request related to plants (like "can you tell me about tomatoes?" or "how to grow tomatoes?"), respond helpfully with relevant information. If possible, give your answer in bullet points.

                - If the input is unrelated to plants (e.g., "What is the capital of France?"), respond with: "I’m sorry, I only talk about plants."

                - Do not repeat that you're a plant assistant unless the user asks something unrelated.
                """
                response = convo.send_message(prompt)
            else:     
                prompt = f"""
                You are a professional plant disease expert responding to queries about plants health.

                Your responses must be **direct**, **clear**, and must **avoid any setup phrases** like "Okay, I understand" or "I will follow these guidelines...".

                Given:
                - Plant name: **{plant}**
                - Disease label: **{label}**
                - User input: "{query}"

                Respond according to the following rules:

                1. **Plant Identification**:
                - If the user asks **"What plant is this?"**, answer: "This is a **{plant}**."
                - If **{plant} = "No Data"**, answer: "Sorry, I couldn't identify the plant from this image."

                2. **Disease Diagnosis**:
                - If **{label} = "No Data"**, respond: "Apologies, I couldn't identify the plant from this image. Therefore, 
                I cannot detect any disease in this photo."
                - If the plant is healthy, respond: "The **{plant}** is healthy and has no disease."
                - Otherwise, say: "The **{plant}** has the **{label}** disease." Then provide:
                    - A **brief description** of the disease (**only include this the first time it’s mentioned** in the conversation).
                    - Possible reasons for the disease.
                    - Suggested solutions to mitigate or cure the disease.

                3. **Follow-Up and Query Handling**:
                - If the user asks "What is the disease here?", **do not repeat the disease description**. Just provide causes, solutions, or clarifications.
                - If the disease has already been mentioned earlier, avoid repeating the description. Only provide additional information.
                - If the input is unrelated (e.g., "What is the mass of the sun?"), respond: "This question is not relevant to plants."
                - If no query is provided, respond based only on the label **{label}** and plant **{plant}**, and do not repeat the disease description if it has already been given.

                Keep the reply concise, relevant, and easy to understand. Bold the plant and disease names where applicable.
                """

                response = convo.send_message(prompt)
            
            # Log successful response
            with open("gem_resp.txt", "a") as f:
                f.write(f"{datetime.now()} - Success: {response}\n")
                
            # Reset backoff on success
            async with self.lock:
                self.current_backoff = 0
                
            return response.text
            
        except Exception as e:
            # Log the error
            with open("gem_resp.txt", "a") as f:
                f.write(f"{datetime.now()} - Error: {str(e)}\n")
            
            # Handle the error and get backoff time
            backoff_time = await self.handle_error(e)
            
            # Wait for the backoff period
            await asyncio.sleep(backoff_time)
            
            # Retry the request
            return await self.generateResponse(label, query, plant, history)
