from fastapi import APIRouter, Request
from ..backend.RetrievalUtility import RetrievalUtility


router = APIRouter()

@router.post("/query")
async def query_model(request: Request):
    try:
        body = await request.json()
        history = body["history"]
        if body.get('image', '') != '':
            print("Image detected in request") 
            img = RetrievalUtility.getImageFromBase64(body['image'])
            print("Image decoded") 
            model_response = await RetrievalUtility.retrieveWithImage(img, body['message'],history)

            return {"message": f"{model_response}"}
        else:
            model_response = await RetrievalUtility.retrieveWithTextOnly(body['message'],history)
            return {"message": f"{model_response}"}

    except Exception as e:
        print(f"Error processing request: {e}")
        return {"message": "Error processing request, Please try again or start new chat."}
