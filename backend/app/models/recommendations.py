"""pydantic models related to sight recommendations"""
from pydantic import BaseModel, Field, field_validator

from backend.app.models.images import VoyagoImage


class SightRecommendation(BaseModel):
    """model of a single sight recommendation"""
    sight: str
    brief: str


class DayPlan(BaseModel):
    day: int
    plan: str


class Itinerary(BaseModel):
    """model of what is expected from the LLM to return"""
    plan: list[DayPlan]
    recommendations: list[SightRecommendation]


class VisualItinerary(Itinerary):
    """model of a full trip plan provided to users"""
    images: dict[str, list[VoyagoImage]]
    destination_image: VoyagoImage


class RecommendationQuery(BaseModel):
    """model of the query the user should send the LLM"""
    destination: str = Field(...,
                             examples=["Tokyo", "France", "California"],
                             min_length=3,
                             description="The travel destination"
                             )
    days: int = Field(..., gt=0, description="Number of days must be greater than 0.")

    @field_validator("destination")
    def validate_destination(cls, value: str) -> str:
        if not value.strip():
            raise ValueError("Destination cannot be empty.")
        return value
