"""Auth dependencies"""
from fastapi import Header

from backend.rest_app.models.auth import AuthHeaders


def get_auth_headers(authorization: str = Header(...),
                     refresh_token: str = Header(..., alias="refresh-token")) -> AuthHeaders:
    """:returns AuthHeaders object"""
    return AuthHeaders(authorization=authorization, refresh_token=refresh_token)
