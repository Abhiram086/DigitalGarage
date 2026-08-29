from django.urls import path

from .views import (
    EngineListView,
    VehicleGenerationListView,
    VehicleMakeListView,
    VehicleModelListView,
    VehicleSpecificationListView,
    UserVehicleListView,
    UserVehicleDetailView,
)


urlpatterns = [
    path("my-cars/",UserVehicleListView.as_view()),
    path("my-cars/<int:pk>/",UserVehicleDetailView.as_view()),
    path("makes/", VehicleMakeListView.as_view()),
    path("models/", VehicleModelListView.as_view()),
    path("generations/", VehicleGenerationListView.as_view()),
    path("engines/", EngineListView.as_view()),
    path("specifications/", VehicleSpecificationListView.as_view()),

]