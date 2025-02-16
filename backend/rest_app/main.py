"""main entry point to the Voyago RESTFul API"""
from logging import getLogger

from fastapi import FastAPI

from backend.rest_app.routers import auth, images, itinerary, users

log = getLogger(__name__)
log.info("Starting Voyago!")
# TODO: add logger to fastapi app
app = FastAPI()

app.include_router(itinerary.router)
app.include_router(images.router)
app.include_router(users.router)
app.include_router(auth.router)


@app.get("/")
def root():
    """root endpoint"""
    return "Welcome to Voyago!"
