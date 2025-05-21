"""project config interface"""
import os
from functools import lru_cache

from pydantic.v1 import BaseSettings

DOTENV = os.path.join(os.path.dirname(__file__), "../.env")


class Config(BaseSettings):
    """pydantic settings class providing access to .env file"""
    openai_key: str = ""

    unsplash_key: str = ""
    unsplash_base_url: str = ""

    supabase_is_prod: bool = True

    supabase_prod_url: str = ""
    supabase_prod_key: str = ""
    supabase_prod_service_key: str = ""

    supabase_local_url: str = ""
    supabase_local_key: str = ""
    supabase_local_service_key: str = ""

    class Config:
        env_file = DOTENV


@lru_cache
def get_config():
    """getter for settings"""
    return Config()
