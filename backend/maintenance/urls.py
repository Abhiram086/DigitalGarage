from django.urls import path

from .views import MaintenanceItemListView, ServiceVisitListCreateView


urlpatterns = [
    path("items/", MaintenanceItemListView.as_view()),
    path("visits/",ServiceVisitListCreateView.as_view()),
]

