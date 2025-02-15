"""supabase client dependency"""
from supabase import Client, create_client

from backend.app.config.config import get_config

# env config
config = get_config()

# singleton
supabase: Client = create_client(
    supabase_url=config.supabase_url,
    supabase_key=config.supabase_service_key,
)


def get_supabase_client() -> Client:
    """gets an initialized supabase client"""
    return supabase
