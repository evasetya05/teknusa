from django.urls import path

from . import views

app_name = "agent"

urlpatterns = [
    path("briefing/", views.briefing_view, name="briefing"),
    path("llm/", views.llm_status_view, name="llm_status"),
    path("llm/test/", views.llm_test_view, name="llm_test"),
]
