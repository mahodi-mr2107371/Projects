import os
from PIL import Image
from tqdm import tqdm

class DataExtractor:
    def __init__(self, dir_path):
        """
        Initialize the extractor with the JSON file path and an embedder instance.
        """
        self._data_dict = {}
        self.dir_path = dir_path
        self._extract_data_to_dict() # Automatically populate data upon initialization


    def _extract_data_to_dict(self):
        # train directory path that contains all plants and diseases
        train_dir = self.dir_path
        
        # Iterate over directories inside train folder
        for class_dir in tqdm(os.listdir(train_dir)):
            class_path = os.path.join(train_dir, class_dir)
            if os.path.isdir(class_path):
                self._data_dict[class_dir] = []
                
                # Iterate over image files in class directory
                for file in os.listdir(class_path):
                    file_path = os.path.join(class_path, file)
                    try:
                        with Image.open(file_path) as img:
                            self._data_dict[class_dir].append(img.copy())  # Copy image to avoid file locking issues
                    except Exception as e:
                        print(f"Skipping {file_path}: {e}")

    def get_data_dict(self):
        """
        Return the images and label dictionary
        """
        return self._data_dict

    def display_extracted_data(self):
        """
        Display the extracted image  and labels.
        """
        for img, lbl in zip(self._image_paths, self._texts):
            print(f"Image: {img}\nLabel: {lbl}\n")