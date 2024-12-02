"""pydantic models related to sight recommendations"""
from pydantic import BaseModel


class SightRecommendation(BaseModel):
    """model of a single sight recommendation"""
    sight: str
    brief: str


class Itinerary(BaseModel):
    """model of what is expected from the LLM to return"""
    recommendations: list[SightRecommendation]
    plan: str


class RecommendationQuery(BaseModel):
    """model of the query the user should send the LLM"""
    destination: str
    days: int  # number of sights requested
