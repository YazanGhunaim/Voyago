"""user related models"""
from pydantic import BaseModel
from pydantic import EmailStr


class BaseUser(BaseModel):
    """Base user model

    data that can be safely returned about user
    """
    email: EmailStr


class UserData(BaseModel):
    """User data model"""
    username: str


class UserOptions(BaseModel):
    """User options model

    Wraps additional user data.
    """
    data: UserData


class UserLogin(BaseUser):
    """User login model"""
    password: str


class UserSignUp(BaseUser):
    """User signin model

    extra data needed from user to sign up
    """
    password: str
    options: UserOptions
