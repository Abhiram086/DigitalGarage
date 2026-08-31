from django.db import models

from vehicles.models import UserVehicle


class MaintenanceItem(models.Model):
    CATEGORY_CHOICES = [
        ("FLUID", "Fluids & Lubrication"),
        ("FILTER", "Filters"),
        ("BRAKE", "Brakes"),
        ("TYRE", "Tyres & Wheels"),
        ("ELECTRICAL", "Electrical"),
        ("ENGINE", "Engine"),
        ("TRANSMISSION", "Transmission"),
    ]

    name = models.CharField(max_length=100, unique=True)

    category = models.CharField(
        max_length=20,
        choices=CATEGORY_CHOICES
    )

    def __str__(self):
        return self.name


class ServiceVisit(models.Model):
    vehicle = models.ForeignKey(
        UserVehicle,
        on_delete=models.CASCADE,
        related_name="service_visits"
    )

    date = models.DateField()

    odometer = models.PositiveIntegerField(
        null=True,
        blank=True
    )

    notes = models.TextField(blank=True)

    def __str__(self):
        return f"{self.vehicle.nickname} - {self.date}"


class ServiceItem(models.Model):
    ACTION_CHOICES = [
        ("REPLACED", "Replaced"),
        ("CHANGED", "Changed"),
        ("INSPECTED", "Inspected"),
        ("SERVICED", "Serviced"),
    ]

    service_visit = models.ForeignKey(
        ServiceVisit,
        on_delete=models.CASCADE,
        related_name="items"
    )

    maintenance_item = models.ForeignKey(
        MaintenanceItem,
        on_delete=models.CASCADE,
        related_name="service_items"
    )

    action = models.CharField(
        max_length=20,
        choices=ACTION_CHOICES
    )

    notes = models.TextField(blank=True)

    def __str__(self):
        return f"{self.maintenance_item.name} - {self.action}"