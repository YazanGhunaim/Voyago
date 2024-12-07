"""main entry point to the Voyago RESTFul API"""
from fastapi import FastAPI

from rest_app.routers import images, itinerary

app = FastAPI()

app.include_router(itinerary.router)
app.include_router(images.router)


@app.get("/")
def root():
    """root endpoint"""
    return "Welcome to Voyago!"
