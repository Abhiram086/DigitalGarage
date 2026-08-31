from rest_framework import serializers

from .models import(
    Engine,
    UserVehicle,
    VehicleGeneration,
    VehicleMake,
    VehicleModel,
    VehicleSpecification
)

class VehicleMakeSerializer(serializers.ModelSerializer):
    class Meta:
        model = VehicleMake
        fields = ["id","name"]

class VehicleModelSerializer(serializers.ModelSerializer):
    make = VehicleMakeSerializer(read_only=True)
    class Meta:
        model = VehicleModel
        fields = ["id", "name","make"]


class VehicleGenerationSerializer(serializers.ModelSerializer):
    model = VehicleModelSerializer(read_only=True)
    class Meta:
        model = VehicleGeneration
        fields = ["id", "name", "year_from", "year_to","model"]


class EngineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Engine
        fields = [
            "id",
            "name",
            "displacement_cc",
            "fuel_type",
            "aspiration",
        ]


class VehicleSpecificationSerializer(serializers.ModelSerializer):
    engine = EngineSerializer(read_only=True)
    generation = VehicleGenerationSerializer(read_only=True)
    class Meta:
        model = VehicleSpecification
        fields = [
            "id",
            "year",
            "engine",
            "generation",
            "transmission_type",
        ]


class UserVehicleSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserVehicle
        fields = [
            "id",
            "vehicle_specification",
            "nickname",
            "odometer",
        ]

class UserVehicleDetailSerializer(serializers.ModelSerializer):
    vehicle_specification = VehicleSpecificationSerializer(read_only=True)

    class Meta:
        model = UserVehicle
        fields = [
            "id",
            "vehicle_specification",
            "nickname",
            "odometer",
        ]