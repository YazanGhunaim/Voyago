"""streamlit app entry point"""
import streamlit as st
from streamlit_extras.bottom_container import bottom
from streamlit_extras.row import row
from streamlit_extras.switch_page_button import switch_page

st.set_page_config(page_title="Voyago", layout="wide")

st.title("Welcome To Voyago!")

st.subheader("""
Voyago aims to ease the process of trip planning.
By telling us where and how long you want to go,
Voyago will prepare a visual itinerary for you in seconds!
""")

row1 = row(2, vertical_align="center")
switch_to_feed = row1.button(label="Go to feed.", use_container_width=True)
switch_to_board = row1.button(label="Go to travel board.", use_container_width=True)

if switch_to_feed:
    switch_page("Feed")
if switch_to_board:
    switch_page("Travel Board")

with bottom():
    st.warning("Due to our limited image repositories and budget, "
               "some sights images might be misleading and not accurate. "
               "The more obscure | less known the place the higher the probability"
               "getting a faulty image."
               , icon="⚠️")
