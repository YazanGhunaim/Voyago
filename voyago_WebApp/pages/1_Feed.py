"""Image feed view"""
import streamlit as st

from backend.rest_app.fast_api_dependencies import get_voyago

st.set_page_config(page_title="Voyago", layout="wide")

voyago = get_voyago()
images = voyago.get_images(query="travel europe sightseeing cities", count=20)

st.title("Voyago feed")

columns = st.columns(3)
for index, voyago_image in enumerate(images):
    col = columns[index % 3]
    with col:
        # TODO: Location metadata
        st.markdown(f"Artist: [{voyago_image.username}]({voyago_image.unsplash_profile})")
        st.image(voyago_image.urls["regular"], caption=f"{voyago_image.username}", use_container_width=True)
