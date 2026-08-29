
from django.contrib import admin
from django.urls import path,include
from config.auth_views import RegisterView, MeView
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)


urlpatterns = [
    path("api/auth/register/", RegisterView.as_view()),
    path("api/auth/login/", TokenObtainPairView.as_view()),
    path("api/auth/me/", MeView.as_view()),
    path("api/vehicles/",include("vehicles.urls")),
    path("api/auth/refresh/", TokenRefreshView.as_view()),
]
