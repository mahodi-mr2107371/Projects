from PIL import Image
from io import BytesIO
import base64
from .DataStorageManager import DataStorageManager
from supabase import  create_client, Client
from dotenv import load_dotenv
import asyncio
from datetime import datetime
import os
from .DataRetriever import DataRetriever
from .embedder import Embedder

# Import the request manager
from .request_manager import generate_response

class RetrievalUtility:
    @staticmethod
    async def retrieveWithImage(image, query, history):
        """Process image-based queries with rate limiting"""
        
        embedder = Embedder()

        load_dotenv()  # Load environment variables from .env file
    
        url: str = os.getenv("SUPABASE_URL")
        key: str = os.getenv("SUPABASE_KEY")
        supabase: Client = create_client(url, key)
                
        data_Retriever = DataRetriever(supabase=supabase, embedder=embedder)
        
        results = data_Retriever.retrieve_data_with_image(image, k=1)
        
        similarity = results[0]['similarity']
            
        if similarity >0.89:
                    label = results[0]['label']
                    result = results[0]['plantname'].split('_')
                    plant = ' '.join(result[:2]) if "leaf" in result else result[0]
        else:
                    label = 'No Data'
                    plant = 'No Data'
        print(f'Disease: {label}')
        print(f'Plant: {plant}')
        print(f'Similarity: {similarity}')
        
        # Log the request
        with open("gem_resp.txt", "a") as f:
            f.write(f"{datetime.now()} - Image query received: {query[:30]}...\n")
            
        try:
            # Use the request manager to handle rate limiting
            response = await generate_response(label, query, plant, history)
            return response
        except Exception as e:
            with open("gem_resp.txt", "a") as f:
                f.write(f"{datetime.now()} - Error in retrieveWithImage: {str(e)}\n")
            return f"Error processing request: {str(e)}"

    @staticmethod
    async def retrieveWithTextOnly(query, history):
        """Process text-only queries with rate limiting"""
        # Log the request
        with open("gem_resp.txt", "a") as f:
            f.write(f"{datetime.now()} - Text query received: {query[:30]}...\n")
            
        try:
            # Use the request manager to handle rate limiting
            response = await generate_response('', query, '', history)
            return response
        except Exception as e:
            with open("gem_resp.txt", "a") as f:
                f.write(f"{datetime.now()} - Error in retrieveWithTextOnly: {str(e)}\n")
            return f"Error processing request: {str(e)}"

    @staticmethod
    def getImageFromBase64(imageBase64):
        img = Image.open(BytesIO(base64.b64decode(imageBase64)))
        return img

# Synchronous wrappers for the async methods
def retrieveWithImage(query_image, input):
    return asyncio.run(RetrievalUtility.retrieveWithImage(query_image, input))

def retrieveWithTextOnly(query):
    return asyncio.run(RetrievalUtility.retrieveWithTextOnly(query))

if __name__ == '__main__':
    # Example usage
    response = asyncio.run(RetrievalUtility.retrieveWithTextOnly("Test query"))
    print(response)