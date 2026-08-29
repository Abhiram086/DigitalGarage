from django.db import models
from django.contrib.auth.models import User

class VehicleMake(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class VehicleModel(models.Model):
    make = models.ForeignKey(
        VehicleMake,
        on_delete=models.CASCADE,
        related_name="models"
    )
    name = models.CharField(max_length=100)

    def __str__(self):
        return f"{self.make.name} {self.name}"


class VehicleGeneration(models.Model):
    model = models.ForeignKey(
        VehicleModel,
        on_delete=models.CASCADE,
        related_name="generations"
    )
    name = models.CharField(max_length=100)
    year_from = models.PositiveIntegerField()
    year_to = models.PositiveIntegerField(null=True, blank=True)

    def __str__(self):
        return f"{self.model.name} - {self.name}"


class Engine(models.Model):
    name = models.CharField(max_length=100)
    displacement_cc = models.PositiveIntegerField()
    fuel_type = models.CharField(max_length=20)
    aspiration = models.CharField(max_length=30)

    def __str__(self):
        return f"{self.name} ({self.displacement_cc}cc {self.fuel_type})"


class VehicleSpecification(models.Model):
    TRANSMISSION_CHOICES = [
        ("MANUAL", "Manual"),
        ("AUTOMATIC", "Automatic"),
    ]

    generation = models.ForeignKey(
        VehicleGeneration,
        on_delete=models.CASCADE,
        related_name="specifications"
    )
    year = models.PositiveIntegerField()
    engine = models.ForeignKey(
        Engine,
        on_delete=models.CASCADE,
        related_name="vehicle_specifications"
    )
    transmission_type = models.CharField(
        max_length=20,
        choices=TRANSMISSION_CHOICES
    )

    def __str__(self):
        return (
            f"{self.generation.model.name} "
            f"{self.year} "
            f"{self.engine.name} "
            f"{self.transmission_type}"
        )


class UserVehicle(models.Model):
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="vehicles"
    )

    vehicle_specification = models.ForeignKey(
        VehicleSpecification,
        on_delete=models.PROTECT,
        related_name="user_vehicles"
    )

    nickname = models.CharField(
        max_length=100,
        blank=True
    )

    odometer = models.PositiveIntegerField(
        default=0
    )

    def __str__(self):
        return f"{self.user.username} - {self.nickname}"