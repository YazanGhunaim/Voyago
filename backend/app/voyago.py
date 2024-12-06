"""Voyago class"""
import logging

from app.completions.client import AIClient
from app.exceptions import ClientRefusalError, ClientTokenLimitExceededError, TripPlanGenerationError, VoyagoError
from app.models.recommendations import Itinerary, RecommendationQuery, TripPlan
from app.services.unsplash.unsplash_service import UnsplashService

log = logging.getLogger(__name__)


class Voyago:
    """ Voyago class that provides an interface to the core functionality of the app"""

    def __init__(self, client: AIClient, unsplash: UnsplashService):
        """see class doc"""
        self.client = client
        self.unsplash = unsplash

    def _get_itinerary(self, query: RecommendationQuery) -> Itinerary | None:
        """private method for getting an itinerary pydantic model

        :param query: A RecommendationQuery model from the user
        :return: An Itinerary for the user or None if an error was encountered
        """
        try:
            log.info(f"Getting itinerary for query: {query}")
            itinerary = self.client.send_recommendation_query(query=query)
            return itinerary
        except (ClientRefusalError, ClientTokenLimitExceededError, VoyagoError) as e:
            log.error(f"Error occurred while getting itinerary: {e}")
            return None

    def _get_images(self, itinerary: Itinerary) -> dict[str, list[str]]:
        """private method for getting images of sights in a specific itinerary

        :param itinerary: The itinerary model holding the sights
        :return: A dictionary of key: sight name and a value: list of image url's
        """
        log.info("Getting images for the sights in the itinerary.")
        recommended_sights = [recommendation.sight for recommendation in itinerary.recommendations]
        images = {
            sight: self.unsplash.fetch_image_for(sight=sight, count=3)
            for sight in recommended_sights
        }
        return images

    def generate_trip_plan(self, query: RecommendationQuery) -> TripPlan:
        """generates a full trip plan for the user

        :param query: The recommendation query from the user
        :return: trip plan
        """
        log.info("Generating trip plan")
        itinerary = self._get_itinerary(query=query)

        if not itinerary:
            log.error("Failed to generate a trip plan because no itinerary was generated.")
            raise TripPlanGenerationError(f"Trip plan generation failed due to an empty itinerary.")

        images = self._get_images(itinerary=itinerary)
        plan = TripPlan(**itinerary.model_dump(), images=images)

        return plan


if __name__ == "__main__":
    from pprint import pprint

    client = AIClient()
    unsplash = UnsplashService()
    voyago = Voyago(client=client, unsplash=unsplash)

    recommendation_query = RecommendationQuery(destination="Portugal", days=2)
    plan = voyago.generate_trip_plan(query=recommendation_query)

    pprint(plan.model_dump())
