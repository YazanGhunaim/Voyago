"""generate visual plan view"""
import streamlit as st

from backend.app.models.recommendations import RecommendationQuery
from backend.rest_app.fast_api_dependencies import get_voyago

voyago = get_voyago()

st.title("Generate Travel Board")

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
            st.subheader(f"{sight}:")

            # displays images in two columns
            col1, col2 = st.columns(2)
            for i, voyago_image in enumerate(links):
                if i % 2 == 0:
                    with col1:
                        st.markdown(f"Artist: [{voyago_image.username}]({voyago_image.unsplash_profile})")
                        st.image(voyago_image.urls["regular"], caption=sight, use_container_width=True)
                else:
                    with col2:
                        st.markdown(f"[{voyago_image.username}]({voyago_image.unsplash_profile})")
                        st.image(voyago_image.urls["regular"], caption=sight, use_container_width=True)
