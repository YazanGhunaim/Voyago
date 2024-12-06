from fastapi import APIRouter

from app.completions.client import AIClient
from app.models.recommendations import RecommendationQuery, TripPlan
from app.services.unsplash.unsplash_service import UnsplashService
from app.voyago import Voyago

router = APIRouter(prefix="/itinerary", tags=["itinerary"])


# TODO: make voyago object a dependency
@router.post("", response_model=TripPlan)
def get_itinerary_for(query: RecommendationQuery):
    client = AIClient()
    unsplash = UnsplashService()
    voyago = Voyago(client=client, unsplash=unsplash)

    return voyago.generate_trip_plan(query=query).model_dump()
