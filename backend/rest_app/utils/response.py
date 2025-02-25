"""response related utils"""
from backend.schemas.voyago_session_response import VoyagoSessionResponse
from gotrue import AuthResponse

from backend.schemas.auth_tokens import AuthTokens


def create_voyago_session_response(response, auth_response: AuthResponse) -> VoyagoSessionResponse:
    """appends auth tokens to a response"""
    return VoyagoSessionResponse(
        response=response,
        auth_tokens=AuthTokens(
            access_token=auth_response.session.access_token,
            refresh_token=auth_response.session.refresh_token
        )
    )
