"""module to hold dependencies"""
from backend.app.completions.client import AIClient
from backend.app.services.unsplash.unsplash_service import UnsplashService
from backend.app.voyago import Voyago


def get_voyago() -> Voyago:
    """gets an initialized voyago object

    injected with client and service
    """
    client = AIClient()
    unsplash = UnsplashService()
    voyago = Voyago(client=client, unsplash=unsplash)
    return voyago
