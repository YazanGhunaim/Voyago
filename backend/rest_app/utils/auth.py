"""Auth related utils"""
from gotrue import AuthResponse
from supabase import Client

from backend.schemas.auth_tokens import AuthTokens


def set_supabase_session(auth: AuthTokens, supabase_client: Client) -> AuthResponse:
    """sets supabase session state to ensure user independence

    If the current session is expired, setSession will take care of refreshing it to obtain a new session.
    If the refresh token or access token in the current session is invalid, an error will be thrown.
    """
    access_token = auth.access_token.split("Bearer ")[1]  # Extract access_token JWT

    # Set the session so Supabase knows which user we are retrieving
    auth_response = supabase_client.auth.set_session(access_token=access_token, refresh_token=auth.refresh_token)
    return auth_response
