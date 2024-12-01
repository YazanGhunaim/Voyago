"""AI client to interact with LLMs"""
import os

import openai
from dotenv import load_dotenv
from openai import LengthFinishReasonError

from app.models.recommendations import RecommendationQuery, SightRecommendation

load_dotenv()


class AIClient:
    """provides an interface to interact with LLMs"""

    MODEL = "gpt-4o-mini"

    def __init__(self):
        """see class doc"""
        self._client = openai.OpenAI(api_key=os.getenv("OPENAI_KEY"))

    def send_recommendation_query(self, query: RecommendationQuery) -> SightRecommendation | str:
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
                        "content": """
                                You are a travel guide, and will provide sight recommendations depending where the user 
                                wants to go, you will only respond in bullet points with the sight names and nothing else.
                                
                                User will only tell you where he wants to go and how many sights he wants from you
                                ex: (destination: Japan count: 5), then you will say nothing else of what your tasked,
                                 and just respond with the number of requested sights.
                                """},
                    {
                        "role": "user",
                        "content": f"destination: {query.destination} count: {query.count}"
                    }
                ],
                response_format=SightRecommendation,
                max_tokens=50
            )
            sight_recommendations = completion.choices[0].message
            if sight_recommendations.refusal:
                # Handle refusal
                return sight_recommendations.refusal
            return sight_recommendations.parsed
        except LengthFinishReasonError as e:
            print(f"Too many tokens: {e}")
        except Exception as e:
            print(f"Failed with exception: {e}")
