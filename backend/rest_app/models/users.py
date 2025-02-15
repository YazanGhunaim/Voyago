"""user related models"""
from pydantic import BaseModel
from pydantic import EmailStr


class BaseUser(BaseModel):
    """Base user model

    data that can be safely returned about user
    """
    email: EmailStr


class UserLogin(BaseUser):
    """User login model

    extra data needed from user to login/signup
    """
    password: str
