from django.urls import path, re_path
from . import views

app_name = "accounts"

urlpatterns = [
    # login, register, logout cukup panggil as_view() tanpa parameter
    path('login/', views.LoginView.as_view(), name='login'),
    path('register/', views.RegisterView.as_view(), name='register'),
    path('logout/', views.LogoutView.as_view(), name='logout'),

    # URL statis tanpa regex
    path('account/result.html', views.account_result, name='result'),
]
