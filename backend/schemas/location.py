"""Location related model"""

from pydantic import BaseModel


class BaseLocation(BaseModel):
    """base location model"""
    city: str
    country: str
