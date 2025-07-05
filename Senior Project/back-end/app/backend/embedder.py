import torchvision.transforms as transforms
from sentence_transformers import SentenceTransformer
from PIL import Image
import requests
from io import BytesIO
from tqdm import tqdm

class Embedder:
    def __init__(self, model_name='clip-ViT-B-32'):
        self.model = SentenceTransformer(model_name)

    def fetch_and_transform_image(self, url):
        response = requests.get(url)
        img = Image.open(BytesIO(response.content)).convert("RGB")
        # transform = transforms.ToTensor()
        # img_tensor = transform(img).unsqueeze(0)
        return img

    def embed_text(self, texts):
        return self.model.encode(texts)

    def embed_image(self, image_urls):
        images = [self.fetch_and_transform_image(url) for url in tqdm(image_urls, desc="Processing Images")]
        return self.model.encode(images)

    def embed_single_image(self, image):
        # image = self.fetch_and_transform_image(image_url)
        return self.model.encode(image)