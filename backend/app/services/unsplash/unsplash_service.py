"""Service class to communicate with the unsplash API"""
import os
from http.client import HTTPException
from logging import getLogger

import requests
from dotenv import load_dotenv

log = getLogger(__name__)
# TODO: create BaseSetting pydantic class
load_dotenv()


class UnsplashService:
    """Singleton service class

    Provides interface to communicate with the Unsplash API
    """
    _instance = None

    def __new__(cls, *args, **kwargs):
        """see class doc"""
        if not cls._instance:
            cls._instance = super(UnsplashService, cls).__new__(cls)
        return cls._instance

    def __init__(self):
        """see class doc"""
        self.client_id = os.getenv("UNSPLASH_KEY")  # secret access key

    def fetch_image_for(self, sight: str, count: int = 5) -> list[str]:
        """fetches image for a given sight

        :param sight: sight/destination name
        :param count: number of images requested
        :return: list of image url's
        """
        try:
            params = {
                "query": sight,
                "per_page": count,
                "client_id": self.client_id
            }

            response = requests.get("https://api.unsplash.com/search/photos", params=params)
            response.raise_for_status()

            data = response.json()
            images = [photo["urls"]["regular"] for photo in data["results"]]  # get images
            return images if response.ok == 200 else []
        except HTTPException as e:
            log.error(f"Error fetching photo for {sight}, failed with exception: {e}")
            return []
