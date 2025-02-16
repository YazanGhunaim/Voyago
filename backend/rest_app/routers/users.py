"""user related endpoints"""

from fastapi import APIRouter, Depends, HTTPException, status
from gotrue import AuthResponse, UserResponse
from gotrue.errors import AuthApiError, AuthInvalidCredentialsError, AuthSessionMissingError
from supabase import Client

from backend.rest_app.dependencies.auth import get_auth_headers
from backend.rest_app.dependencies.supabase_client import get_supabase_client
from backend.rest_app.models.auth import AuthTokens
from backend.rest_app.models.users import UserSignIn, UserSignUp
from backend.rest_app.utils.auth import set_supabase_session

router = APIRouter(prefix="/users", tags=["Users"])


@router.get("/get_user_session", responses={
    status.HTTP_200_OK: {"description": "User session retrieved successfully."},
    status.HTTP_400_BAD_REQUEST: {"description": "User session retrieval failed."},
    status.HTTP_401_UNAUTHORIZED: {"description": "Invalid or expired session token."}
})
def get_user_session(
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client)
):
    """
    Retrieves the logged-in user's session.

    :param auth: AuthHeaders object
    :param supabase_client: Supabase client dependency
    :return: User session data if valid
    """
    try:
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        # session = supabase_client.auth.get_session()  # Retrieve the current session
        return auth_response.session
    except (AuthSessionMissingError, AuthApiError) as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"Session retrieval failed: {e}")


# TODO: turn back on email verification at some point
@router.post("/sign_up", status_code=status.HTTP_200_OK, responses={
    status.HTTP_200_OK: {"description": "User signed up successfully."},
    status.HTTP_400_BAD_REQUEST: {"description": "User sign up failed."},
})
def sign_up(user: UserSignUp, supabase_client: Client = Depends(get_supabase_client)) -> AuthResponse:
    """signs up user via email and password using supabase

    :param user: UserLogin pydantic model
    :param supabase_client: supabase client dependency injection
    :return: Auth response object

    supabase function and trigger exist upon user creation data is inserted into
    public.users table
    """
    try:
        # TODO: check if username already used BLOOM FILTER + make username unique in db
        response = supabase_client.auth.sign_up(user.model_dump())
        return response
    except AuthApiError as e:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=f"{e}")
    except (AuthInvalidCredentialsError, Exception) as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.post("/sign_in", status_code=status.HTTP_200_OK, responses={
    status.HTTP_200_OK: {"description": "User signed in successfully."},
    status.HTTP_400_BAD_REQUEST: {"description": "User sign in failed."},
})
def sign_in(user: UserSignIn, supabase_client: Client = Depends(get_supabase_client)) -> AuthResponse:
    """Signs in user

    :param user: UserLogin pydantic model
    :param supabase_client: supabase client
    :return: Auth response object
    """
    try:
        response = supabase_client.auth.sign_in_with_password(user.model_dump())
        return response
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")


@router.post("/sign_out", responses={
    status.HTTP_200_OK: {"description": "User signed out successfully."},
    status.HTTP_400_BAD_REQUEST: {"description": "User sign out failed."},
})
def sign_out(auth: AuthTokens = Depends(get_auth_headers),
             supabase_client: Client = Depends(get_supabase_client)) -> None:
    """Signs out user

    :param auth: AuthHeaders object
    :param supabase_client: supabase client
    """
    try:
        set_supabase_session(auth=auth, supabase_client=supabase_client)
        supabase_client.auth.sign_out()
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")


# TODO: fix models such that only that what needs to change is changed
@router.put("/update_user", responses={
    status.HTTP_200_OK: {"description": "User signed in successfully."},
    status.HTTP_400_BAD_REQUEST: {"description": "User sign in failed."},
})
def update_user(
        user: UserSignIn,
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client)) -> UserResponse:
    """Updates user data

    :return: UserResponse
    """
    try:
        set_supabase_session(auth=auth, supabase_client=supabase_client)
        response = supabase_client.auth.update_user(user.model_dump())
        return response
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")


@router.delete("/delete_user", responses={
    status.HTTP_200_OK: {"description": "User deleted successfully."},
    status.HTTP_400_BAD_REQUEST: {"description": "User deletion failed."},
})
def delete_user(auth: AuthTokens = Depends(get_auth_headers),
                supabase_client: Client = Depends(get_supabase_client)) -> None:
    """Deletes user account associated with uid

    :param auth: AuthHeaders object
    :param supabase_client: supabase client
    """
    try:
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)

        # get user id
        uid = auth_response.session.user.id
        # sign out due to service role being overridden https://github.com/supabase/auth/issues/965
        supabase_client.auth.sign_out()

        # delete user
        supabase_client.auth.admin.delete_user(uid)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
