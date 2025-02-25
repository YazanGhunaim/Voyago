"""Itinerary related routes"""
import uuid

from fastapi import APIRouter, Depends, status
from gotrue.errors import AuthApiError
from starlette.exceptions import HTTPException
from supabase import Client

from backend.app.exceptions import TripPlanGenerationError
from backend.models.travel_board import UserTravelBoardModel
from backend.rest_app.dependencies.auth import get_auth_headers
from backend.rest_app.dependencies.supabase_client import get_supabase_client
from backend.rest_app.dependencies.voyago_client import get_voyago
from backend.rest_app.utils.auth import set_supabase_session
from backend.rest_app.utils.db_tables import DBTables
from backend.schemas.auth_tokens import AuthTokens
from backend.schemas.board_query import BoardQuery

router = APIRouter(prefix="/itinerary", tags=["itinerary"])


@router.post("", response_model=UserTravelBoardModel, status_code=status.HTTP_200_OK)
def get_visual_itinerary(
        query: BoardQuery,
        auth: AuthTokens = Depends(get_auth_headers),
        voyago=Depends(get_voyago),
        supabase_client: Client = Depends(get_supabase_client)
):
    """Gets a visualized itinerary

    :param query: RecommendationQuery
    :param auth: Auth tokens
    :param voyago: Dependency voyago object
    :param supabase_client: supabase client
    :return: VisualItinerary
    """
    try:
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        uid = auth_response.session.user.id  # get uid

        # get models
        visual_itinerary_model = voyago.generate_visual_itinerary(query=query).model_dump()
        query_model = query.model_dump()

        supabase_client.rpc(
            "insert_travel_board_and_query",
            {
                "user_id": uid,
                "plan": visual_itinerary_model["plan"],
                "images": visual_itinerary_model["images"],
                "sight_recommendations": visual_itinerary_model["sight_recommendations"],
                "destination_image": visual_itinerary_model["destination_image"],
                "destination": query_model["destination"],
                "days": query_model["days"],
            },
        ).execute()

        return UserTravelBoardModel(**visual_itinerary_model, board_queries=[query])
    except TripPlanGenerationError as e:
        raise HTTPException(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=f"{e}")
    except AuthApiError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.get("/user", response_model=list[UserTravelBoardModel], status_code=status.HTTP_200_OK)
def get_visual_itinerary_for_user(
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client)
):
    """Retrieves all user generated itineraries

    :param auth: AuthHeaders
    :param supabase_client: Supabase client
    :return: List of visual itineraries + query details that generated them + auth tokens
    """
    try:
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        uid = auth_response.session.user.id  # extract current uid

        response = (
            supabase_client
            .from_(DBTables.TRAVEL_BOARDS)
            .select(
                f"plan, images, sight_recommendations, destination_image, {DBTables.BOARD_QUERIES}(destination, days)"
            )  # join
            .eq("user_id", uuid.UUID(uid))
            .execute()
        )

        return response.data
    except AuthApiError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")
