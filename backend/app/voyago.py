"""Voyago class"""
import logging

from backend.app.completions.client import AIClient
from backend.app.exceptions import ClientRefusalError, ClientTokenLimitExceededError, TripPlanGenerationError, \
    VoyagoError
from backend.app.models.images import VoyagoImage
from backend.app.models.recommendations import Itinerary, RecommendationQuery, VisualItinerary
from backend.app.services.unsplash.unsplash_service import UnsplashService

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

    def _get_images_from_itinerary(self, itinerary: Itinerary) -> dict[str, list[VoyagoImage]]:
        """private method for getting images of sights in a specific itinerary

        :param itinerary: The itinerary model holding the sights
        :return: A dictionary of key: sight name and a value: list of image url's
        """
        log.info("Getting images for the sights in the itinerary.")
        recommended_sights = [recommendation.sight for recommendation in itinerary.recommendations]
        images = {
            sight: self.get_images(query=sight, count=3)
            for sight in recommended_sights
        }
        return images

    def get_images(self, query: str, count: int, page: int = 1) -> list[VoyagoImage]:
        """gets images based on a query

        :param query: search terms
        :param count: number of images requested
        :param page: page number [pagination]
        :return: list of image url's
        """
        images = self.unsplash.fetch_image_for(query=query, count=count, page=page)
        return images

    def get_image_collection(self, topic: str, count: int = 10, page: int = 1) -> list[str]:
        """gets a collection of images for a curated topic, to be used in feed view

        :param topic: topic for requested collection
        :param count: number of images requested
        :param page: page number [pagination]
        :return: list of image url's
        """
        log.info(f"Getting image collection for the {topic}.")
        images = self.unsplash.fetch_image_collection_for(topic=topic, count=count, page=page)
        return images

    def generate_visual_itinerary(self, query: RecommendationQuery) -> VisualItinerary:
        """generates a full trip plan for the user

        :param query: The recommendation query from the user
        :return: trip plan
        """
        log.info("Generating trip plan")
        itinerary = self._get_itinerary(query=query)

        if not itinerary:
            log.error("Failed to generate a trip plan because no itinerary was generated.")
            raise TripPlanGenerationError(f"Trip plan generation failed due to an empty itinerary.")

        images = self._get_images_from_itinerary(itinerary=itinerary)
        plan = VisualItinerary(**itinerary.model_dump(), images=images)

        return plan


if __name__ == "__main__":
    from pprint import pprint

    client = AIClient()
    unsplash = UnsplashService()

    voyago = Voyago(client=client, unsplash=unsplash)

    recommendation_query = RecommendationQuery(destination="Vienna", days=3)
    plan = voyago.generate_visual_itinerary(query=recommendation_query)

    pprint(plan.model_dump())
