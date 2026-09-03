from django.urls import path

from .views import MaintenanceItemListView, ServiceVisitCreateView


urlpatterns = [
    path("items/", MaintenanceItemListView.as_view()),
    path("visits/",ServiceVisitCreateView.as_view()),
]

