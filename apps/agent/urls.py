from django.urls import path

from . import views

app_name = "agent"

urlpatterns = [
    path("briefing/", views.briefing_view, name="briefing"),
]
