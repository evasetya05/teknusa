from django.urls import path
from . import views

app_name = 'game'

urlpatterns = [
    path('', views.index, name='index'),
    path('api/save-score/', views.save_score, name='save_score'),
]