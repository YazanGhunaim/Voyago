"""Itinerary related routes"""

from fastapi import APIRouter, Depends, status
from starlette.exceptions import HTTPException

from backend.app.dependencies import get_voyago
from backend.app.exceptions import TripPlanGenerationError
from backend.app.models.recommendations import RecommendationQuery, VisualItinerary

router = APIRouter(prefix="/itinerary", tags=["itinerary"])


@router.post("", response_model=VisualItinerary)
def get_visual_itinerary(query: RecommendationQuery, voyago=Depends(get_voyago)):
    """Gets a visualized itinerary

    :param query: RecommendationQuery
    :param voyago: Dependency voyago object
    :return: VisualItinerary
    """
    try:
        return voyago.generate_visual_itinerary(query=query).model_dump()
    except TripPlanGenerationError as e:
        raise HTTPException(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=f"{e}")
