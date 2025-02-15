"""auth related routes"""
import logging

from fastapi import APIRouter, Depends, HTTPException, status
from gotrue import AuthResponse

from backend.rest_app.dependencies.auth import get_auth_headers
from backend.rest_app.dependencies.supabase_client import get_supabase_client
from backend.rest_app.models.auth import AuthTokens
from backend.rest_app.utils.auth import set_supabase_session

log = logging.getLogger(__name__)

router = APIRouter(prefix="/auth", tags=["auth"])


@router.get("/validate_tokens", response_model=AuthResponse, status_code=status.HTTP_200_OK)
def validate_tokens(
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client=Depends(get_supabase_client)
):
    """validates user auth tokens, used to check if user should stay logged in

    :param auth: user auth tokens
    :param supabase_client: supabase client
    :return: AuthResponse object ( in case of refreshed tokens )
    """
    try:
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        return auth_response
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"Unauthorized user tokens {e}")
