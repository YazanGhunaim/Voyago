"""Auth related models"""
from pydantic import BaseModel


class AuthHeaders(BaseModel):
    """Authorization headers for endpoints that need it

    authorization and refresh_token used to set supabase state
    """
    authorization: str
    refresh_token: str
