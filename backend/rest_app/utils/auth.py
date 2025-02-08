"""Auth related utils"""
from supabase import Client

from backend.rest_app.models.auth import AuthHeaders


def set_supabase_session(auth: AuthHeaders, supabase_client: Client):
    """sets supabase session state to ensure user independence"""
    # Extract access_token JWT
    access_token = auth.authorization.split("Bearer ")[1]
    # Set the session so Supabase knows which user we are retrieving
    supabase_client.auth.set_session(access_token=access_token, refresh_token=auth.refresh_token)
