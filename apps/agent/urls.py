from django.urls import path

from . import views

app_name = "agent"

urlpatterns = [
    path("briefing/", views.briefing_view, name="briefing"),
    path("llm/", views.llm_status_view, name="llm_status"),
    path("chat/", views.chat_view, name="chat"),
    path("llm/settings/", views.llm_settings_view, name="llm_settings"),
    path("llm/test/", views.llm_test_view, name="llm_test"),
    path("llm/test-suite/", views.llm_test_suite_view, name="llm_test_suite"),
]
