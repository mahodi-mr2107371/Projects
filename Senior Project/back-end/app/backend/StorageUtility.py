from .DataExtractor import DataExtractor
from .embedder import Embedder
from .DataStorageManager import DataStorageManager
from tqdm import tqdm
# import pyarrow as pa

class StorageUtility:
    @staticmethod
    def process_and_store_data():
        """
        Processes data using ImageLabelExtractor and Embedder and stores it in LanceDB.
        """
        # Initialize the ImageLabelExtractor
        json_file_path = './app/backend/data/_annotations.train.jsonl'

       
        dir_path = 'C:\\Users\\hassa\\Desktop\\data-sdp-images\\train_groups\\group_1\\' # TODO: add path of train dir

        # Initialize the Embedder
        embedder = Embedder()

        print('Starting data storage!')
        
        image_label_extractor = DataExtractor(json_file_path, embedder, dir_path=dir_path)

        # extracting images and label from local directories to dictionary in self._data_dict
        image_label_extractor._extract_data_to_dict()

        data_dict = image_label_extractor.get_data_dict()

        # Initialize the LanceDBHandler
        lancedb_handler = DataStorageManager()
        
        print('Data extracted! Preparing for storage')

        for key in tqdm(data_dict.keys()):
            for image in data_dict[key]:
                parts = key.split()
                if len(parts) > 1:
                    plant_name = parts[0]  # First word as plant name
                    disease_name = " ".join(parts[1:])  # Remaining words as disease name
                else:
                    plant_name = key  # If only one word, assume it's the plant name
                    disease_name = "Unknown"
                embedded_image = embedder.embed_single_image(image)
                lancedb_handler.store_embedding(disease_name, None, embedded_image, plantName=plant_name)

     

        print("Data stored!!!!")


if __name__ == '__main__':
    # Explicitly call the utility method
    StorageUtility.process_and_store_data()


#python -m app.backend.store_data