"""generate visual plan view"""
import streamlit as st

from backend.app.dependencies import get_voyago
from backend.app.models.recommendations import RecommendationQuery

voyago = get_voyago()

st.title("Generate itinerary")

with st.form("Trip plan"):
    st.write("Whats your plan?")

    destination = st.text_input(label="Where to?", value="Prague", placeholder="Prague")

    duration = st.slider(label="How long?", min_value=1, max_value=14)

    submitted = st.form_submit_button("generate")

    if submitted:
        query = RecommendationQuery(destination=destination, days=duration)

        with st.spinner("Generating..."):
            itinerary = voyago.generate_visual_itinerary(query=query)
            plan, recommendations, sight_with_image = itinerary.plan, itinerary.recommendations, itinerary.images

        st.snow()  # celebration xd

        st.subheader("Recommendations:")
        for sight_recommendation in recommendations:
            st.write(f"**{sight_recommendation.sight}**: {sight_recommendation.brief}")

        st.subheader("Plan:")
        st.text(plan)

        for sight, links in sight_with_image.items():
            # TODO: metadata credits etc
            st.subheader(f"{sight}:")
            for link in links:
                st.image(link, caption=sight)
