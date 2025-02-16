"""main entry point to the Voyago RESTFul API"""
import logging
from logging import getLogger

from fastapi import FastAPI

from backend.rest_app.routers import auth, images, itinerary, users

# configuring logger
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="date: [%d-%m-%y] | time: [%H:%M:%S]"
)

log = getLogger(__name__)
log.info("Starting Voyago!")

app = FastAPI()

app.include_router(itinerary.router)
app.include_router(images.router)
app.include_router(users.router)
app.include_router(auth.router)


@app.get("/")
def root():
    """root endpoint"""
    return "Welcome to Voyago!"
