from typing import Optional
from pydantic import BaseSettings


class Settings(BaseSettings):
    database_hostname: Optional[str] = None
    database_port: Optional[str] = None
    database_password: Optional[str] = None
    database_name: Optional[str] = None
    database_username: Optional[str] = None
    secret_key: Optional[str] = None
    algorithm: Optional[str] = None
    access_token_expire_minutes: Optional[int] = None

    class Config:
        env_file = ".env"


settings = Settings()
