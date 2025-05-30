"""AI client to interact with LLMs"""

from logging import getLogger

import openai
from openai import LengthFinishReasonError

from backend.app.exceptions import ClientRefusalError, ClientTokenLimitExceededError, VoyagoError
from backend.app.prompts.prompts import GET_SIGHT_RECOMMENDATIONS_AND_PLAN
from backend.schemas.board_query import BoardQuery
from backend.schemas.travel_board import TravelBoard
from backend.utils.config import get_config

log = getLogger(__name__)


class AIClient:
    """provides an interface to interact with LLMs"""

    MODEL = "gpt-4o-mini"

    def __init__(self):
        """see class doc"""
        self.config = get_config()
        self._client = openai.OpenAI(api_key=self.config.openai_key)

    def send_recommendation_query(self, query: BoardQuery) -> TravelBoard:
        """
        Takes in a RecommendationsQuery model using openAi's completion parsing
        returns a SightRecommendation model

        :param query: RecommendationQuery provided by user
        :return: SightRecommendation or a None if error occurred
        """
        try:
            completion = self._client.beta.chat.completions.parse(
                model="gpt-4o",
                messages=[
                    {
                        "role": "system",
                        "content": GET_SIGHT_RECOMMENDATIONS_AND_PLAN},
                    {
                        "role": "user",
                        "content": f"destination: {query.destination} days: {query.days}"
                    }
                ],
                response_format=TravelBoard,
                # max_tokens=50
            )
            sight_recommendations = completion.choices[0].message
            if sight_recommendations.refusal:
                raise ClientRefusalError(f"LLM Refused to process query: {sight_recommendations.refusal}")
            return sight_recommendations.parsed
        except LengthFinishReasonError as e:
            log.error(f"Token limit exceeded: {e}")
            raise ClientTokenLimitExceededError(f"Token limit exceeded: {e}")
        except Exception as e:
            log.error(f"An unexpected error occurred: {e}")
            raise VoyagoError(e) from e
