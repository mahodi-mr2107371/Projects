import os
from supabase import create_client, Client
from dotenv import load_dotenv

class DataStorageManager:
    def __init__(self):
        """
        Loads the environment to initialize supabase client.      
        """
        load_dotenv()  # Load environment variables from .env file
        
        self.url: str = os.getenv("SUPABASE_URL")
        self.key: str = os.getenv("SUPABASE_KEY")
        
        if not self.url or not self.key:
            raise ValueError("Missing SUPABASE_URL or SUPABASE_KEY in environment variables.")
        

    def store_embedding(self, labels, text_embeddings, image_embeddings, plantName):
        """
        Stores embeddings in the database      
        Args:
        - labels: The label (disease name).
        - text_embeddings: Text embeddings 
        - image_embeddings: Image embeddings
        - plantName: The plant name
        """
        supabase: Client = create_client(self.url, self.key)
        response = (
        supabase.table("embeddings")
        .insert({"label": labels, "textEmbedding": text_embeddings ,"imageEmbedding": image_embeddings.tolist(), "plantName": plantName })
        .execute()) #TODO Make sure to conver text embedding to a list like we did for image embedding
        


#python -c "import os; print(os.environ.get('https://tmutvbrvfdcmzggkrdkf.supabase.co'))"
#python -c "import os; print(os.environ.get('SUPABASE_KEY'))"


    