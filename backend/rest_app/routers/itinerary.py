"""Itinerary related routes"""
import uuid

from fastapi import APIRouter, Depends, status
from gotrue.errors import AuthApiError
from starlette.exceptions import HTTPException
from supabase import Client

from backend.app.exceptions import TripPlanGenerationError
from backend.app.models.recommendations import RecommendationQuery
from backend.rest_app.config.db_tables import DBTables
from backend.rest_app.dependencies.auth import get_auth_headers
from backend.rest_app.dependencies.supabase_client import get_supabase_client
from backend.rest_app.dependencies.voyago_client import get_voyago
from backend.rest_app.models.auth import AuthTokens
from backend.rest_app.models.response import VoyagoSessionResponse
from backend.rest_app.utils.auth import set_supabase_session
from backend.rest_app.utils.response import create_voyago_session_response

# TODO: Database migrations
router = APIRouter(prefix="/itinerary", tags=["itinerary"])


@router.get("/user", response_model=VoyagoSessionResponse, status_code=status.HTTP_200_OK)
def get_visual_itinerary_for_user(auth: AuthTokens = Depends(get_auth_headers),
                                  supabase_client: Client = Depends(get_supabase_client)):
    """Retrieves all user generated itineraries

    :param auth: AuthHeaders
    :param supabase_client: Supabase client
    :return: List of visual itineraries + query details that generated them + auth tokens
    """
    try:
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        uid = auth_response.session.user.id  # extract current uid
        data = (
            supabase_client
            .from_(DBTables.TRAVEL_BOARDS)
            .select(
                f"plan, images, recommendations, destination_image, {DBTables.RECOMMENDATION_QUERIES}(destination, days)"
                # TODO: utilize DBTables class?
            )  # join
            .eq("user_id", uuid.UUID(uid))
            .execute()
        )

        response = create_voyago_session_response(response=data, auth_response=auth_response)
        return response
    except AuthApiError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.post("", status_code=status.HTTP_200_OK)
def get_visual_itinerary(
        query: RecommendationQuery,
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
        # TODO: what if query insertion fails? or board insertion fails, need functions to delete
        # https://github.com/orgs/supabase/discussions/526#discussioncomment-285139
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)

        # get uid
        uid = auth_response.session.user.id

        # get models
        visual_itinerary_model = voyago.generate_visual_itinerary(query=query).model_dump()
        query_model = query.model_dump()

        # append uid to models
        query_model["user_id"] = uid
        visual_itinerary_model["user_id"] = uid

        query_id = (
            supabase_client
            .table(DBTables.RECOMMENDATION_QUERIES)
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

        data = (
            supabase_client
            .from_(DBTables.TRAVEL_BOARDS)
            .select(
                f"plan, images, recommendations, destination_image, {DBTables.RECOMMENDATION_QUERIES}(destination, days)"
                # TODO: utilize DBTables class?
            )  # join
            .eq("user_id", uuid.UUID(uid))
            .order("created_at", desc=True)
            .limit(1)
            .execute()
        )

        return data
    except TripPlanGenerationError as e:
        raise HTTPException(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=f"{e}")
    except AuthApiError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")
