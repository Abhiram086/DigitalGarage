from rest_framework import serializers

from .models import (
    MaintenanceItem,
    ServiceVisit,
    ServiceItem,
)


class MaintenanceItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = MaintenanceItem
        fields = [
            "id",
            "name",
            "category",
        ]


class ServiceItemSerializer(serializers.ModelSerializer):
    maintenance_item = MaintenanceItemSerializer(read_only=True)

    class Meta:
        model = ServiceItem
        fields = [
            "id",
            "maintenance_item",
            "action",
            "notes",
        ]


class ServiceItemCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = ServiceItem
        fields = [
            "maintenance_item",
            "action",
            "notes",
        ]


class ServiceVisitSerializer(serializers.ModelSerializer):
    items = ServiceItemSerializer(
        many=True,
        read_only=True
    )

    class Meta:
        model = ServiceVisit
        fields = [
            "id",
            "vehicle",
            "date",
            "odometer",
            "notes",
            "items",
        ]


class ServiceVisitCreateSerializer(serializers.ModelSerializer):
    items = ServiceItemCreateSerializer(
        many=True
    )

    class Meta:
        model = ServiceVisit
        fields = [
            "vehicle",
            "date",
            "odometer",
            "notes",
            "items",
        ]