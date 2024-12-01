"""pydantic models related to sight recommendations"""
from pydantic import BaseModel


class SightRecommendation(BaseModel):
    """model of what is expected from the LLM to return"""
    recommendations: list[str]


class RecommendationQuery(BaseModel):
    """model of the query the user should send the LLM"""
    destination: str
    count: int  # number of sights requested
