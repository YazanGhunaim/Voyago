"""Itinerary related routes"""
import uuid

from fastapi import APIRouter, Depends, status
from starlette.exceptions import HTTPException
from supabase import Client

from backend.app.exceptions import TripPlanGenerationError
from backend.app.models.recommendations import RecommendationQuery, VisualItinerary
from backend.rest_app.dependencies.auth import get_auth_headers
from backend.rest_app.dependencies.supabase_client import get_supabase_client
from backend.rest_app.dependencies.voyago_client import get_voyago
from backend.rest_app.models.auth import AuthHeaders
from backend.rest_app.utils.auth import set_supabase_session

# TODO: Tables names config?
# TODO: Database migrations
router = APIRouter(prefix="/itinerary", tags=["itinerary"])


# TODO: return refresh token
@router.get("/user", status_code=status.HTTP_200_OK)
def get_visual_itinerary_for_user(auth: AuthHeaders = Depends(get_auth_headers),
                                  supabase_client: Client = Depends(get_supabase_client)):
    """Retrieves all user generated itineraries

    :param auth: AuthHeaders
    :param supabase_client: Supabase client
    :return: List of visual itineraries alongside the query details that generated them
    """
    try:
        set_supabase_session(auth=auth, supabase_client=supabase_client)
        uid = supabase_client.auth.get_user().user.id  # extract current uid
        response = (
            supabase_client
            .from_("travel_boards")
            .select(
                "plan, images, recommendations, destination_image, recommendation_queries(destination, days)"
            )  # join
            .eq("user_id", uuid.UUID(uid))
            .execute()
        )

        return response
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


# TODO: Require logged in user
@router.post("", response_model=VisualItinerary, status_code=status.HTTP_200_OK)
def get_visual_itinerary(query: RecommendationQuery, voyago=Depends(get_voyago),
                         supabase_client: Client = Depends(get_supabase_client)):
    """Gets a visualized itinerary

    :param query: RecommendationQuery
    :param voyago: Dependency voyago object
    :param supabase_client: supabase client
    :return: VisualItinerary
    """
    try:
        # get uid
        uid = supabase_client.auth.get_user().user.id  # extract current uid

        # get models
        visual_itinerary_model = voyago.generate_visual_itinerary(query=query).model_dump()
        query_model = query.model_dump()

        # append uid to models
        query_model["user_id"] = uid
        visual_itinerary_model["user_id"] = uid

        query_id = (
            supabase_client
            .table("recommendation_queries")
            .insert(query_model)
            .execute()
        ).data[0]["id"]

        # append query_id
        visual_itinerary_model["query_id"] = query_id

        # insert travel board
        (
            supabase_client.table("travel_boards")
            .insert(visual_itinerary_model)
            .execute()
        )

        return visual_itinerary_model
    except TripPlanGenerationError as e:
        raise HTTPException(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")
