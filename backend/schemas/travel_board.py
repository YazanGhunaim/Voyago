"""pydantic models related to sight recommendations"""
from pydantic import BaseModel

from backend.schemas.voyago_image import VoyagoImage


class SightRecommendation(BaseModel):
    """model of a single sight recommendation"""
    sight: str
    brief: str


class DayPlan(BaseModel):
    """model of the day and associated plan"""
    day: int
    plan: str


class TravelBoard(BaseModel):
    """model of what is expected from the LLM to return"""
    plan: list[DayPlan]
    sight_recommendations: list[SightRecommendation]


class VisualTravelBoard(TravelBoard):
    """model of a full trip plan provided to users

    Travel board with images
    """
    images: dict[str, list[VoyagoImage]]
    destination_image: VoyagoImage
