"""AI client to interact with LLMs"""

from logging import getLogger

import openai
from openai import LengthFinishReasonError

from app.config.config import get_config
from app.models.recommendations import Itinerary, RecommendationQuery
from app.prompts.prompts import GET_SIGHT_RECOMMENDATIONS_AND_PLAN

log = getLogger(__name__)


class AIClient:
    """provides an interface to interact with LLMs"""

    MODEL = "gpt-4o-mini"

    def __init__(self):
        """see class doc"""
        self.config = get_config()
        self._client = openai.OpenAI(api_key=self.config.openai_key)

    def send_recommendation_query(self, query: RecommendationQuery) -> Itinerary | str:
        """
        Takes in a RecommendationsQuery model using openAi's completion parsing
        returns a SightRecommendation model

        :param query: RecommendationQuery provided by user
        :return: SightRecommendation or a failure message
        """
        try:
            completion = self._client.beta.chat.completions.parse(
                model="gpt-4o-2024-08-06",
                messages=[
                    {
                        "role": "system",
                        "content": GET_SIGHT_RECOMMENDATIONS_AND_PLAN},
                    {
                        "role": "user",
                        "content": f"destination: {query.destination} days: {query.days}"
                    }
                ],
                response_format=Itinerary,
                # max_tokens=50
            )
            sight_recommendations = completion.choices[0].message
            if sight_recommendations.refusal:
                return sight_recommendations.refusal
            return sight_recommendations.parsed
        except LengthFinishReasonError as e:
            log.error(f"Token limit exceeded: {e}")
            return "Response too lengthy... please try again with a shorter query."
        except Exception as e:
            log.error(f"An unexpected error occurred: {e}")
            return "An error occurred. Please try again later."
