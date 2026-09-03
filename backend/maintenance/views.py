from rest_framework.response import Response
from rest_framework.views import APIView

from .models import MaintenanceItem, ServiceVisit, ServiceItem

from .serializers import (
    MaintenanceItemSerializer,
    ServiceVisitSerializer,
    ServiceVisitCreateSerializer,
)
from django.db import transaction
from rest_framework.permissions import IsAuthenticated
from rest_framework import status


class MaintenanceItemListView(APIView):

    def get(self, request):
        items = MaintenanceItem.objects.all()

        serializer = MaintenanceItemSerializer(
            items,
            many=True
        )

        return Response(serializer.data)

class ServiceVisitCreateView(APIView):
    permission_classes = [IsAuthenticated]

    @transaction.atomic
    def post(self, request):
        serializer = ServiceVisitCreateSerializer(
            data=request.data
        )

        if not serializer.is_valid():
            return Response(
                serializer.errors,
                status=status.HTTP_400_BAD_REQUEST
            )

        vehicle = serializer.validated_data["vehicle"]

        if vehicle.user != request.user:
            return Response(
                {"detail": "You do not own this vehicle."},
                status=status.HTTP_403_FORBIDDEN
            )

        service_visit = ServiceVisit.objects.create(
            vehicle=vehicle,
            date=serializer.validated_data["date"],
            odometer=serializer.validated_data["odometer"],
            notes=serializer.validated_data["notes"],
        )

        for item in serializer.validated_data["items"]:
            ServiceItem.objects.create(
                service_visit=service_visit,
                maintenance_item=item["maintenance_item"],
                action=item["action"],
                notes=item["notes"],
            )

        response_serializer = ServiceVisitSerializer(
            service_visit
        )

        return Response(
            response_serializer.data,
            status=status.HTTP_201_CREATED
        )