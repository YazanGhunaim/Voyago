"""images related endpoints"""
from typing import List

from fastapi import APIRouter, Depends

from backend.app.models.images import VoyagoImage
from backend.rest_app.dependencies.auth import get_auth_headers
from backend.rest_app.dependencies.voyago_client import get_voyago
from backend.rest_app.models.auth import AuthTokens

router = APIRouter(prefix="/images", tags=["Images"])


@router.get("", response_model=List[VoyagoImage])
def get_images_for(
        query: str,
        count: int = 10,
        page: int = 1,
        voyago=Depends(get_voyago),
        auth: AuthTokens = Depends(get_auth_headers)
):
    """:returns Lists of images along with metadata"""
    return voyago.get_images(query=query, count=count, page=page)


@router.get("/collection")
def get_image_collection_for(
        topic: str = "travel",
        count: int = 10,
        page: int = 1,
        voyago=Depends(get_voyago)
) -> list[str]:
    """:returns Collection of images about related to a topic [str url's]"""
    return voyago.get_image_collection(topic=topic, count=count, page=page)
