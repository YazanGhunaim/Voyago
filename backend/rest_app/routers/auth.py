"""auth related routes"""
import logging

from fastapi import APIRouter, Depends, HTTPException, status
from gotrue import AuthResponse
from gotrue.errors import AuthApiError, AuthSessionMissingError

from backend.rest_app.dependencies.auth import get_auth_headers
from backend.rest_app.dependencies.supabase_client import get_supabase_client
from backend.rest_app.utils.auth import set_supabase_session
from backend.schemas.auth_tokens import AuthTokens

log = logging.getLogger(__name__)

router = APIRouter(prefix="/auth", tags=["auth"])


@router.get("/set_user_session", response_model=AuthResponse, status_code=status.HTTP_200_OK, responses={
    status.HTTP_200_OK: {"description": "Setting session successful."},
    status.HTTP_400_BAD_REQUEST: {"description": "Setting session failed."},
    status.HTTP_401_UNAUTHORIZED: {"description": "Invalid or expired tokens."}
})
def validate_tokens(
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client=Depends(get_supabase_client)
):
    """Sets the user session, refreshes the access token if expired, given refresh token is passed

    :param auth: user auth tokens
    :param supabase_client: supabase client
    :return: AuthResponse object ( in case of refreshed tokens )
    """
    try:
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        return auth_response
    except (AuthSessionMissingError, AuthApiError) as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"Session retrieval failed: {e}")
