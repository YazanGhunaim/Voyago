"""images related endpoints"""
from fastapi import APIRouter, Depends

from app.dependencies import get_voyago

router = APIRouter(prefix="/images", tags=["Images"])


@router.get("/collection")
def get_image_collection_for(
        topic: str = "travel",
        count: int = 10,
        page: int = 1,
        voyago=Depends(get_voyago)
) -> list[str]:
    """:returns Collection of images about related to a topic [str url's]"""
    return voyago.get_image_collection(topic=topic, count=count, page=page)
