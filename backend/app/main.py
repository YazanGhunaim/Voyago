import logging

from app.completions.client import AIClient
from app.models.recommendations import RecommendationQuery

log = logging.getLogger(__name__)

if __name__ == "__main__":
    client = AIClient()
    recommendation_query = RecommendationQuery(destination="Japan", days=14)
    response = client.send_recommendation_query(query=recommendation_query)
    for rec in response.recommendations:
        print(f"sight recommended: {rec.sight}, brief: {rec.brief}")

    print(f"plan: \n{response.plan}")
