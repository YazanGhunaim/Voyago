from fastapi import APIRouter

from app.completions.client import AIClient
from app.models.recommendations import RecommendationQuery

router = APIRouter(prefix="/itinerary", tags=["itinerary"])


@router.post("")
def get_itinerary_for(query: RecommendationQuery):
    client = AIClient()
    itinerary = client.send_recommendation_query(query=query)
    return itinerary.model_dump()
    # recommended_sights = [recommendation.sight for recommendation in response.recommendations]
    # return recommended_sights
