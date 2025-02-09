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

# TODO: require authentication (valid user)
# TODO: RLS on travel_boards ( only valid users )
router = APIRouter(prefix="/itinerary", tags=["itinerary"])


@router.get("/user", status_code=status.HTTP_200_OK)
def get_visual_itinerary_for_user(auth: AuthHeaders = Depends(get_auth_headers),
                                  supabase_client: Client = Depends(get_supabase_client)):
    """Retrieves all user generated itineraries

    :param auth: AuthHeaders
    :param supabase_client: Supabase client
    :return: List of visual itineraries
    """
    try:
        set_supabase_session(auth=auth, supabase_client=supabase_client)
        uid = supabase_client.auth.get_user().user.id  # extract current uid
        response = (
            supabase_client
            .table("travel_boards")
            .select("*")
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
        visual_itinerary = voyago.generate_visual_itinerary(query=query).model_dump()
        uid = supabase_client.auth.get_user().user.id  # extract current uid
        visual_itinerary["user_id"] = uid  # Append uid to model

        # Insert Itinerary into table
        (
            supabase_client.table("travel_boards")
            .insert(visual_itinerary)
            .execute()
        )

        return visual_itinerary
    except TripPlanGenerationError as e:
        raise HTTPException(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")
