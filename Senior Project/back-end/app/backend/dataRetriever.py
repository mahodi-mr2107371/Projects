from .embedder import Embedder

class DataRetriever:
    def __init__(self, supabase, embedder):
        """
        Initialize the DataRetriever with the database and embedder.

        Args:
        - supabase: The supabase instance.
        - embedder: The Embedder instance used for embedding images.
        """
        self.supabase = supabase
        self.embedder = embedder

    def retrieve_data_with_image(self, image, k):
        """
        Retrieve data from the supabase using an image to generate a query embedding.

        Args:
        - image: The image to embed and search the database.
        - k: The number of results to retrieve (default is 1).

        Returns:
        - A dictionary of the search results, including text and labels.
        """
        embedder = Embedder()
        query_embedding = embedder.embed_single_image(image)
        # # Perform vector search 
        
        response = self.supabase.rpc(
        "match_images", 
        {"query_embedding": query_embedding.tolist(), "match_count": k}
            ).execute()
        return response.data # Return dictionary

