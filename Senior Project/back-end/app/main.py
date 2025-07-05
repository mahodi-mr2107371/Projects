import uvicorn
import socket
from fastapi import FastAPI
from .routers import query

app = FastAPI()

app.include_router(query.router)

@app.get("/")
async def root():
    return {"message": "Please provide the appropriate route"}

if __name__ == '__main__':
    hostname = socket.gethostname()
    ip = socket.gethostbyname(hostname)
    print(ip)
    uvicorn.run(app, host=ip, port=8080)
    
    
#python -m app.main     