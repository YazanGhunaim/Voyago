"""user related endpoints"""

from fastapi import APIRouter, Depends, HTTPException, status
from gotrue import AuthResponse
from supabase import Client

from backend.rest_app.fast_api_dependencies.auth import get_auth_headers
from backend.rest_app.fast_api_dependencies.supabase_client import get_supabase_client
from backend.rest_app.models.auth import AuthHeaders
from backend.rest_app.models.users import UserLogin
from backend.rest_app.utils.auth import set_supabase_session

router = APIRouter(prefix="/users", tags=["Users"])


@router.get("/get_user_session", responses={
    status.HTTP_200_OK: {"description": "User session retrieved successfully."},
    status.HTTP_400_BAD_REQUEST: {"description": "User session retrieval failed."},
    status.HTTP_401_UNAUTHORIZED: {"description": "Invalid or expired session token."}
})
def get_user_session(
        auth: AuthHeaders = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client)
):
    """
    Retrieves the logged-in user's session.

    :param auth: AuthHeaders object
    :param supabase_client: Supabase client dependency
    :return: User session data if valid
    """
    try:
        set_supabase_session(auth=auth, supabase_client=supabase_client)
        # Retrieve the current session
        session = supabase_client.auth.get_session()

        if not session:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired session token.")
        return session
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"Session retrieval failed: {e}")


@router.post("/sign_up", status_code=status.HTTP_200_OK, responses={
    status.HTTP_200_OK: {"description": "User signed up successfully."},
    status.HTTP_400_BAD_REQUEST: {"description": "User sign up failed."},
})
def sign_up(user: UserLogin, supabase_client: Client = Depends(get_supabase_client)) -> AuthResponse:
    """signs up user via email and password using supabase

    :param user: UserLogin pydantic model
    :param supabase_client: supabase client dependency injection
    :return: Auth response object
    """
    try:
        response = supabase_client.auth.sign_up(user.model_dump(exclude={"username"}))
        return response
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.post("/sign_in", status_code=status.HTTP_200_OK, responses={
    status.HTTP_200_OK: {"description": "User signed in successfully."},
    status.HTTP_400_BAD_REQUEST: {"description": "User sign in failed."},
})
def sign_in(user: UserLogin, supabase_client: Client = Depends(get_supabase_client)) -> AuthResponse:
    """Signs in user

    :param user: UserLogin pydantic model
    :param supabase_client: supabase client
    :return: Auth response object
    """
    try:
        response = supabase_client.auth.sign_in_with_password(user.model_dump(exclude={"username"}))
        return response
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.post("/sign_out", responses={
    status.HTTP_200_OK: {"description": "User signed out successfully."},
    status.HTTP_400_BAD_REQUEST: {"description": "User sign out failed."},
})
def sign_out(auth: AuthHeaders = Depends(get_auth_headers),
             supabase_client: Client = Depends(get_supabase_client)) -> None:
    """Signs out user

    :param auth: AuthHeaders object
    :param supabase_client: supabase client
    """
    try:
        set_supabase_session(auth=auth, supabase_client=supabase_client)
        supabase_client.auth.sign_out()
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.delete("/delete_user", responses={
    status.HTTP_200_OK: {"description": "User deleted successfully."},
    status.HTTP_400_BAD_REQUEST: {"description": "User deletion failed."},
})
def delete_user(auth: AuthHeaders = Depends(get_auth_headers),
                supabase_client: Client = Depends(get_supabase_client)):
    """Deletes user account associated with uid

    :param auth: AuthHeaders object
    :param supabase_client: supabase client
    """
    try:
        set_supabase_session(auth=auth, supabase_client=supabase_client)

        # get user id
        session = supabase_client.auth.get_session()
        uid = session.user.id
        # sign out due to service role being overridden https://github.com/supabase/auth/issues/965
        supabase_client.auth.sign_out()

        # delete user
        supabase_client.auth.admin.delete_user(uid)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")
