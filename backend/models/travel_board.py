"""travel board orm model"""
from pydantic import BaseModel

from backend.schemas.board_query import BoardQuery
from backend.schemas.travel_board import DayPlan, SightRecommendation
from backend.schemas.voyago_image import VoyagoImage


class UserTravelBoardModel(BaseModel):
    """user travel board orm model

    Travel board alongside its generation query
    """
    destination_image: VoyagoImage
    plan: list[DayPlan]
    sight_recommendations: list[SightRecommendation]
    images: dict[str, list[VoyagoImage]]
    board_queries: list[BoardQuery]  # one element list due to nature of response format from db
