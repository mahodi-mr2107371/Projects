import pytest
from unittest.mock import AsyncMock, patch, MagicMock
from backend.ModelConfigurator import ModelConfigurator
from backend.RetrievalUtility import RetrievalUtility
from backend.DataExtractor import DataExtractor
from backend.embedder import Embedder
from backend.DataRetriever import DataRetriever
import numpy as np
from PIL import Image
import io
import warnings

# Suppress specific DeprecationWarning from proto
warnings.filterwarnings(
    "ignore",
    category=DeprecationWarning,
    message=".*including_default_value_fields.*"
)

# Test fetch_and_transform_image
@patch("backend.embedder.requests.get")
@patch("backend.embedder.Image.open")
def test_fetch_and_transform_image(mock_image_open, mock_requests_get):
    mock_response = MagicMock()
    mock_response.content = b"fake image bytes"
    mock_requests_get.return_value = mock_response

    mock_image = MagicMock()
    mock_image.convert.return_value = "converted_image"
    mock_image_open.return_value = mock_image

    embedder = Embedder()
    result = embedder.fetch_and_transform_image(
        "https://i1.wp.com/homegardenjoy.com/site/wp-content/uploads/2015/08/cracked-tomato.jpg?resize=650%2C433")

    mock_requests_get.assert_called_once_with(
        "https://i1.wp.com/homegardenjoy.com/site/wp-content/uploads/2015/08/cracked-tomato.jpg?resize=650%2C433")
    mock_image_open.assert_called_once()
    assert result == "converted_image"

# Test embed_single_image
@patch("backend.embedder.Embedder.fetch_and_transform_image")
@patch("backend.embedder.SentenceTransformer")
def test_embed_single_image(mock_sentence_transformer, mock_fetch_image):
    mock_model = MagicMock()
    mock_model.encode.return_value = ["single_embedding"]
    mock_sentence_transformer.return_value = mock_model

    mock_fetch_image.return_value = "fake_image"

    embedder = Embedder()
    result = embedder.embed_single_image(
        "https://i1.wp.com/homegardenjoy.com/site/wp-content/uploads/2015/08/cracked-tomato.jpg?resize=650%2C433")

    mock_fetch_image.assert_called_once_with(
        "https://i1.wp.com/homegardenjoy.com/site/wp-content/uploads/2015/08/cracked-tomato.jpg?resize=650%2C433")
    mock_model.encode.assert_called_once_with("fake_image")
    assert result == ["single_embedding"]

# Test retrieve_data_with_image 
@patch('backend.DataRetriever.Embedder')
def test_retrieve_data_with_image(mock_embedder_class):
    mock_embedder_instance = MagicMock()
    mock_embedder_instance.embed_single_image.return_value = np.array([0.1, 0.2, 0.3])
    mock_embedder_class.return_value = mock_embedder_instance

    mock_supabase = MagicMock()
    mock_supabase.rpc.return_value.execute.return_value.data = {"result": "success"}

    retriever = DataRetriever(mock_supabase, mock_embedder_instance)

    result = retriever.retrieve_data_with_image("dummy_image", 1)

    assert result == {"result": "success"}
    mock_embedder_instance.embed_single_image.assert_called_once_with("dummy_image")
    
# Test get_data_dict
@patch("backend.DataExtractor.Image.open")
@patch("backend.DataExtractor.os.path.isdir")
@patch("backend.DataExtractor.os.listdir")
def test_data_extractor_builds_dict(mock_listdir, mock_isdir, mock_image_open):

    mock_listdir.side_effect = [
        ["ClassA", "ClassB"],  # First listdir call returns class folders
        ["img1.jpg", "img2.jpg"],  # Inside ClassA
        ["img3.jpg"]  # Inside ClassB
    ]
    mock_isdir.return_value = True

    mock_image = MagicMock()
    mock_image.copy.return_value = "MockImage"
    mock_image_open.return_value.__enter__.return_value = mock_image

    extractor = DataExtractor("mock_dir")
    data = extractor.get_data_dict()

    assert "ClassA" in data
    assert "ClassB" in data
    assert data["ClassA"] == ["MockImage", "MockImage"]
    assert data["ClassB"] == ["MockImage"]
    
# Test retrieveWithImage
def create_test_image(): # Helper to create a dummy image
    img = Image.new('RGB', (100, 100), color='green')
    byte_arr = io.BytesIO()
    img.save(byte_arr, format='PNG')
    byte_arr.seek(0)
    return byte_arr

@pytest.mark.asyncio
@patch('backend.RetrievalUtility.generate_response', new_callable=AsyncMock)
@patch('backend.RetrievalUtility.DataRetriever')
@patch('backend.RetrievalUtility.Embedder')
@patch('backend.RetrievalUtility.create_client')
@patch('backend.RetrievalUtility.os.getenv')
async def test_retrieve_with_image(
    mock_getenv, 
    mock_create_client, 
    mock_embedder, 
    mock_data_retriever, 
    mock_generate_response
):
    # Mock Supabase env vars
    mock_getenv.side_effect = lambda key: "dummy"  # url and key

    # Mock image
    test_image = Image.open(create_test_image())

    # Fake return from retrieve_data_with_image
    mock_instance = MagicMock()
    mock_instance.retrieve_data_with_image.return_value = [{
        'similarity': 0.92,
        'label': 'Tomato Leaf Spot',
        'plantname': 'Tomato_leaf'
    }]
    mock_data_retriever.return_value = mock_instance

    # Mock response from LLM
    mock_generate_response.return_value = "This is a mock response."

    result = await RetrievalUtility.retrieveWithImage(test_image, "What is this disease?", [])

    # Assertions
    assert result == "This is a mock response."
    mock_generate_response.assert_awaited_once()
    mock_instance.retrieve_data_with_image.assert_called_once()
    
# Test generateResponse
# @pytest.mark.asyncio
# async def test_generate_response_with_label():
#     model = ModelConfigurator()
#     model.configure_genai()

#     label = "Tomato Blight"
#     query = "What caused this disease?"
#     plant = "Tomato"
#     history = []

#     response = await model.generateResponse(label, query, plant, history)
    
#     assert isinstance(response, str)
#     assert "Tomato Blight" not in response  
#     assert "caused" in response or "reasons" in response  

@pytest.mark.asyncio
async def test_generate_response_with_label():
    model = ModelConfigurator()
    model.configure_genai()

    label = "Tomato Blight"
    query = "What caused this disease?"
    plant = "Tomato"
    history = []

    response = await model.generateResponse(label, query, plant, history)
    
    assert isinstance(response, str)
    assert "Tomato Blight" in response  # should appear in first response
    assert "caused" in response.lower() or "reason" in response.lower()



#pytest unit_test.py -v --> verbose to show all results for all test cases