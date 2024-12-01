from pydantic import BaseModel


class SightRecommendation(BaseModel):
    recommendations: list[str]


class RecommendationQuery(BaseModel):
    destination: str
    count: int  # number of sights requested
