"""streamlit app entry point"""
import streamlit as st
from PIL import Image
import requests

from backend.app.dependencies import get_voyago

voyago = get_voyago()
images = voyago.get_image_collection()

st.set_page_config(page_title="Voyago", layout="wide")

st.title("Welcome to Voyago")
st.subheader("Image Feed:")

for image_url in images:
    response = requests.get(image_url, stream=True)
    image = Image.open(response.raw)
    st.image(image, caption="Image from URL", use_container_width=True)
