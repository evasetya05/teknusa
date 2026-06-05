from django.urls import path
from . import views

app_name = "entity"

urlpatterns = [
    path('', views.EntityListView.as_view(), name='entity_list'),
    path('create/', views.EntityCreateView.as_view(), name='entity_create'),
    path('<uuid:pk>/edit/', views.EntityUpdateView.as_view(), name='entity_edit'),
    path('<uuid:pk>/delete/', views.EntityDeleteView.as_view(), name='entity_delete'),
    path('select/', views.select_entity, name='select_entity'),
]