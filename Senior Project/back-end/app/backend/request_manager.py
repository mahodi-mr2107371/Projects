import asyncio
import time
from datetime import datetime
import os
from .ModelConfigurator import ModelConfigurator

class RequestManager:
    """
    Manages API requests with queuing and rate limiting
    """
    def __init__(self):
        self.model_config = ModelConfigurator()
        self.model_config.configure_genai()
        self.request_queue = asyncio.Queue()
        self.processing = False
        self.max_concurrent_requests = 5  # Process 5 at a time to stay under limit
    
    async def add_request(self, label, query, plant, history):
        """
        Add a request to the queue and get a future for the result
        """
        # Create a future to return the result
        future = asyncio.Future()
        
        # Add the request to the queue
        await self.request_queue.put({
            'label': label,
            'query': query,
            'plant': plant,
            'future': future,
            'timestamp': time.time(),
            'history' : history
        })
        
        # Start processing the queue if not already running
        if not self.processing:
            asyncio.create_task(self.process_queue())
            
        # Return the future so caller can await it
        return future
    
    async def process_queue(self):
        """
        Process requests from the queue
        """
        self.processing = True
        
        try:
            # Keep processing until queue is empty
            while not self.request_queue.empty():
                # Process up to max_concurrent_requests at a time
                pending_tasks = []
                
                for _ in range(min(self.max_concurrent_requests, self.request_queue.qsize())):
                    if not self.request_queue.empty():
                        request = await self.request_queue.get()
                        task = asyncio.create_task(self._process_single_request(request))
                        pending_tasks.append(task)
                
                # Wait for all tasks to complete
                if pending_tasks:
                    await asyncio.gather(*pending_tasks)
        finally:
            self.processing = False
    
    async def _process_single_request(self, request):
        """
        Process a single request and set its future result
        """
        try:
            # Log the request start
            with open("gem_resp.txt", "a") as f:
                wait_time = time.time() - request['timestamp']
                f.write(f"{datetime.now()} - Processing request after {wait_time:.2f}s in queue\n")
            
            # Process the request
            response = await self.model_config.generateResponse(
                request['label'], 
                request['query'], 
                request['plant'],
                request['history']
            )
            
            # Set the future result
            request['future'].set_result(response)
            
        except Exception as e:
            # Log the error
            with open("gem_resp.txt", "a") as f:
                f.write(f"{datetime.now()} - Fatal error in request: {str(e)}\n")
            
            # Set the future exception
            if not request['future'].done():
                request['future'].set_exception(e)


# Create a singleton instance
request_manager = RequestManager()

async def generate_response(label, query, plant, history):
    """
    Global function to generate a response using the request manager
    """
    future = await request_manager.add_request(label, query, plant, history)
    return await future