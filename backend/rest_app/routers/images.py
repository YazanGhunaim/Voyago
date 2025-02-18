"""images related endpoints"""
from typing import List

from fastapi import APIRouter, Depends
from gotrue.errors import AuthApiError
from starlette import status
from starlette.exceptions import HTTPException
from supabase import Client

from backend.app.models.images import VoyagoImage
from backend.rest_app.dependencies.auth import get_auth_headers
from backend.rest_app.dependencies.supabase_client import get_supabase_client
from backend.rest_app.dependencies.voyago_client import get_voyago
from backend.rest_app.models.auth import AuthTokens
from backend.rest_app.utils.auth import set_supabase_session

router = APIRouter(prefix="/images", tags=["Images"])


@router.get("", response_model=List[VoyagoImage])
def get_images_for(
        query: str,
        count: int = 10,
        page: int = 1,
        voyago=Depends(get_voyago),
        supabase_client: Client = Depends(get_supabase_client),
        auth: AuthTokens = Depends(get_auth_headers)
):
    """:returns Lists of images along with metadata"""
    try:
        set_supabase_session(auth=auth, supabase_client=supabase_client)
        return voyago.get_images(query=query, count=count, page=page)
    except AuthApiError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.get("/collection")
def get_image_collection_for(
        topic: str = "travel",
        count: int = 10,
        page: int = 1,
        voyago=Depends(get_voyago)
) -> list[str]:
    """:returns Collection of images about related to a topic [str url's]"""
    return voyago.get_image_collection(topic=topic, count=count, page=page)
