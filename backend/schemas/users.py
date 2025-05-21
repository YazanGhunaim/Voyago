"""user related models"""
from typing import Optional

from pydantic import BaseModel
from pydantic import EmailStr

from backend.schemas.location import BaseLocation


class BaseUser(BaseModel):
    """Base user model

    data that can be safely returned about user
    """
    email: EmailStr


class UserData(BaseModel):
    """User data model"""
    name: str
    username: str
    profile_pic: Optional[str] = None
    bio: Optional[str] = None
    location: Optional[BaseLocation] = None


class UserOptions(BaseModel):
    """User options model

    Wraps additional user data.
    """
    data: UserData


class UserSignIn(BaseUser):
    """User signin model"""
    password: str


class UserSignUp(BaseUser):
    """User signup model

    extra data needed from user to sign up
    """
    password: str
    options: UserOptions


class UserUpdate(BaseUser):
    password: Optional[str] = None
    data: Optional[UserData] = None
