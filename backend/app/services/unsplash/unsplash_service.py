"""Service class to communicate with the unsplash API"""
from http.client import HTTPException
from logging import getLogger

import requests

from backend.app.config.config import get_config

log = getLogger(__name__)


# TODO: Super important! need to retrieve metadata of images as well like user profile, location etc for unsplash legal reasons

class UnsplashService:
    """Unsplash service class

    Provides interface to communicate with the Unsplash API
    """

    def __init__(self):
        """see class doc"""
        self.config = get_config()
        self.client_id = self.config.unsplash_key  # secret access key
        self.base_url = self.config.unsplash_base_url

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

            response = requests.get(f"{self.base_url}/search/photos", params=params)
            response.raise_for_status()

            data = response.json()
            images = [photo["urls"]["regular"] for photo in data["results"]]  # get images
            return images if response.ok else []
        except HTTPException as e:
            log.error(f"Error fetching photo for {sight}, failed with exception: {e}")
            return []
        except Exception as e:
            log.error(f"Unknown error encountered while fetching images for {sight}, failed with exception: {e}")
            return []

    def fetch_image_collection_for(self, topic: str, count: int = 10, page: int = 1) -> list[str]:
        """fetches an image collection for a curated topic

        :param topic: topic requested for image collection
        :param count: number of images requested
        :param page: page number [pagination purposes]
        :return: list of image url's
        """
        try:
            params = {
                "query": topic,
                "per_page": count,
                "page": page,
                "client_id": self.client_id
            }

            response = requests.get(f"{self.base_url}/search/collections", params=params)
            response.raise_for_status()

            data = response.json()
            images = [photo["cover_photo"]["urls"]["regular"] for photo in data["results"]]  # get images
            return images if response.ok else []
        except HTTPException as e:
            log.error(f"Error fetching image collection for {topic}, failed with exception: {e}")
            return []
        except Exception as e:
            log.error(f"Unknown error encountered while fetching image collection for {topic}, with exception: {e}")
            return []
