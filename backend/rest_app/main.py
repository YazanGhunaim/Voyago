"""main entry point to the Voyago RESTFul API"""
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def root():
    """root endpoint"""
    return "Welcome to Voyago!"
