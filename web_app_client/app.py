"""streamlit app entry point"""
import streamlit as st

from backend.app.dependencies import get_voyago

voyago = get_voyago()
images = voyago.get_image_collection()

st.set_page_config(page_title="Voyago", layout="wide")

st.title("Welcome to Voyago")
st.subheader("Image Feed:")

columns = st.columns(3)
for index, image_url in enumerate(images):
    col = columns[index % 3]
    with col:
        # TODO: caption is metadata
        st.image(image_url, caption="Image from URL", use_container_width=True)
