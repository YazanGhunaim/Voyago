"""Board query model"""
from pydantic import BaseModel, Field, field_validator


class BoardQuery(BaseModel):
    """model of the query the user should send the LLM"""
    destination: str = Field(...,
                             examples=["Tokyo", "France", "California"],
                             min_length=3,
                             description="The travel destination"
                             )
    days: int = Field(..., gt=0, description="Number of days must be greater than 0.")

    @classmethod
    @field_validator("destination")
    def validate_destination(cls, value: str) -> str:
        if not value.strip():
            raise ValueError("Destination cannot be empty.")
        return value
