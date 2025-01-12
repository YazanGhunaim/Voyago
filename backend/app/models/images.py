"""pydantic models related to image data"""
from typing import Dict, Optional

from pydantic import BaseModel


class VoyagoImage(BaseModel):
    """Data connected with an image

    resolution: can be (regular, full, small)

    username | unsplash_profile:
        due to unsplash guidelines user must be credited
        in the future I hope voyago is run by users and not relying on unsplash
    """
    urls: Dict[str, str]  # [resolution : url]

    username: str  # photographer username
    unsplash_profile: Optional[str]
    # TODO: location needs separate call to getimage
    # location: str
