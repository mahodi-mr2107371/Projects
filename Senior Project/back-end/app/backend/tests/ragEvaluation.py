import json
from deepeval.evaluate import evaluate
from deepeval.test_case import LLMTestCase
from deepeval.metrics import BaseMetric
from supabase import create_client, Client
import os
from dotenv import load_dotenv
from tqdm import tqdm

# Load environment variables
load_dotenv()
url: str = os.getenv("SUPABASE_URL")
key: str = os.getenv("SUPABASE_KEY")
supabase: Client = create_client(url, key)

# Define accuracy metric
class LabelAccuracyMetric(BaseMetric):
    def __init__(self):
        super().__init__()
        self.name="Label and PlantName Accuracy"
        self.threshold = 1.0
        self.score = 0.0

    def measure(self, test_case: LLMTestCase) -> float:
        pred = test_case.actual_output.strip().lower()
        truth = test_case.expected_output.strip().lower()
        self.score = 1.0 if pred == truth else 0.0
        return self.score
    
    def is_successful(self) -> bool:
        if self.score is None:
            return False
        return self.score >= self.threshold
    
    async def a_measure(self, test_case: LLMTestCase) -> float:
        return self.measure(test_case)
    
    @property
    def __name__(self):
        return "Label and PlantName Accuracy"

# Model predictor using vector search on embeddings_duplicate
def model_predictor(image_embedding):
    response = supabase.rpc(
        "match_images", 
        {"query_embedding": image_embedding, "match_count": 1}
    ).execute()

    matches = response.data
    if matches:
        return {
            "label": matches[0]["label"],
            "plantName": matches[0]["plantname"]
        }
    else:
        return {
            "label": "unknown",
            "plantName": "unknown"
        }

# Fetch + build test cases in one loop
total_rows = 3500
page_size = 1000
pages = (total_rows + page_size - 1) // page_size
start = 0
test_cases = []

for _ in tqdm(range(pages), desc="Fetching and building test cases"):
    response = supabase.table("test_embeddings")\
        .select("*")\
        .range(start, start + page_size - 1)\
        .execute()
    
    if not response.data:
        break

    for item in response.data:
        input_embedding = json.loads(item["imageEmbedding"])
        expected_label = item["label"]
        expected_plant = item["plantName"]  # Ensure this matches the actual key name in Supabase

        prediction = model_predictor(input_embedding)
        predicted_label = prediction["label"]
        predicted_plant = prediction["plantName"]

        test_case = LLMTestCase(
            input=item["imageEmbedding"][:10]+"...",
            actual_output=f"{predicted_label.lower().strip()} | {predicted_plant.lower().strip()}",
            expected_output=f"{expected_label.lower().strip()} | {expected_plant.lower().strip()}",
        )
        test_cases.append(test_case)

    start += page_size

print(f"\nPrepared {len(test_cases)} test cases.")

# Evaluate
metrics = [LabelAccuracyMetric()]
evaluation_result = evaluate(test_cases=test_cases, metrics=metrics, run_async=False)

# Display accuracy
# print('~' * 50)
# total = len(test_cases)
# correct = sum(1 for result in evaluation_result.test_results if result.score == 1.0)
# accuracy = correct / total if total > 0 else 0
# print(f"RAG Accuracy (Vector Search - Label + PlantName): {accuracy * 100:.2f}%")

# $ PYTHONIOENCODING=utf-8 python ragEvaluation.py | tee RAG_evaluation_log.txt  --> run this in git bash after activating the environmثnt. Make sure you're in the tests directory
