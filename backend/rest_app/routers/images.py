from fastapi import APIRouter

router = APIRouter(prefix="/images", tags=["Images"])


@router.get("")
def get_image():
    return "Haha"
