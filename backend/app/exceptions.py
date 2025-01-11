"""module to hold standardized custom exceptions related to Voyago"""


class VoyagoError(BaseException):
    """Base exception class for Voyago"""

    def __init__(self, original_exception=None):
        super().__init__(f"VoyagoError caused by: {original_exception}")
        self.original_exception = original_exception


class ClientRefusalError(VoyagoError):
    """Handle LLM refusals"""
    pass


class ClientTokenLimitExceededError(VoyagoError):
    """When LLM clients face token limits"""
    pass


class TripPlanGenerationError(VoyagoError):
    """Failed to generate an itinerary"""
    pass
