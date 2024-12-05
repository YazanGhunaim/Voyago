import logging
from pprint import pprint

from app.completions.client import AIClient
from app.models.recommendations import RecommendationQuery
from app.services.unsplash.unsplash_service import UnsplashService

log = logging.getLogger(__name__)

if __name__ == "__main__":
    client = AIClient()
    unsplash = UnsplashService()

    recommendation_query = RecommendationQuery(destination="Korea", days=2)
    response = client.send_recommendation_query(query=recommendation_query)

    recommended_sights = [recommendation.sight for recommendation in response.recommendations]
    images = {sight: unsplash.fetch_image_for(sight=sight, count=3) for sight in recommended_sights}

    pprint(f"plan: \n{response.plan}")
    pprint(images)
