from django.urls import path

from . import views

app_name = "gantt"

urlpatterns = [
    path("", views.gantt_view, name="index"),
    path("task/<int:task_id>/dates/", views.update_task_dates, name="update_dates"),
    path("dependency/add/", views.dependency_add, name="dependency_add"),
    path("dependency/<int:pk>/delete/", views.dependency_delete, name="dependency_delete"),
    path("milestone/add/", views.milestone_add, name="milestone_add"),
    path("milestone/<int:pk>/toggle/", views.milestone_toggle, name="milestone_toggle"),
    path("milestone/<int:pk>/move/", views.milestone_move, name="milestone_move"),
    path("milestone/<int:pk>/delete/", views.milestone_delete, name="milestone_delete"),
    path("baseline/set/", views.baseline_set, name="baseline_set"),
    path("baseline/clear/", views.baseline_clear, name="baseline_clear"),
]
