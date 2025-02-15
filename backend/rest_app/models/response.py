"""Generic response models"""

from pydantic import BaseModel

from backend.rest_app.models.auth import AuthTokens


class VoyagoSessionResponse(BaseModel):
    """generic voyago session response

    includes auth tokens for clients to set up persistent login state
    """
    auth_tokens: AuthTokens

    class Config:
        extra = "allow"  # allow more fields to be placed in this model
