"""Service class to communicate with the unsplash API"""
from http.client import HTTPException
from logging import getLogger

import requests
from deprecated import deprecated

from backend.app.config.config import get_config
from backend.app.models.images import VoyagoImage

log = getLogger(__name__)


class UnsplashService:
    """Unsplash service class

    Provides interface to communicate with the Unsplash API
    """

    def __init__(self):
        """see class doc"""
        self.config = get_config()
        self.client_id = self.config.unsplash_key  # secret access key
        self.base_url = self.config.unsplash_base_url

    def fetch_image_for(self, query: str, count: int = 5, page: int = 1) -> list[VoyagoImage]:
        """fetches image for a given sight

        :param query: sight/destination terms
        :param count: number of images requested (max 10)
        :param page: page number [pagination purposes]
        :return: list of image url's
        """
        try:
            params = {
                "query": query,
                "per_page": count,
                "page": page,
                "client_id": self.client_id
            }

            response = requests.get(f"{self.base_url}/search/photos", params=params)
            response.raise_for_status()

            data = response.json()

            # extract and validate image data
            images = [
                VoyagoImage(urls={
                    "small": res.get("urls", {}).get("small", ""),
                    "regular": res.get("urls", {}).get("regular", ""),
                    "full": res.get("urls", {}).get("full", ""),
                },
                    username=res.get("user", {}).get("username", ""),
                    unsplash_profile=res.get("user", {}).get("links", "").get("html", ""))
                for res in data.get("results", [])
            ]
            return images
        except HTTPException as e:
            log.error(f"Error fetching photo for {query}, failed with exception: {e}")
            return []
        except Exception as e:
            log.error(f"Unknown error encountered while fetching images for {query}, failed with exception: {e}")
            return []

    @deprecated(
        reason="Currently no reason to use collections, if need does arise it needs to be updated to return correct model"
    )
    def fetch_image_collection_for(self, topic: str, count: int = 10, page: int = 1) -> list[str]:
        """fetches an image collection for a curated topic

        :param topic: topic requested for image collection
        :param count: number of images requested (max 10)
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


if __name__ == "__main__":
    from pprint import pprint

    unsplash = UnsplashService()
    images = unsplash.fetch_image_for(query="Prague", count=1)
    pprint(images)
