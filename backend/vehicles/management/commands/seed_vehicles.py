import json
from pathlib import Path

from django.core.management.base import BaseCommand
from django.db import transaction

from vehicles.models import (
    Engine,
    VehicleGeneration,
    VehicleMake,
    VehicleModel,
    VehicleSpecification,
)


class Command(BaseCommand):
    help = "Seed the database with vehicle data"

    def handle(self, *args, **options):
        data_path = (
            Path(__file__).resolve().parents[3]
            / "data"
            / "vehicles"
            / "vehicles.json"
        )

        with open(data_path, "r", encoding="utf-8") as file:
            data = json.load(file)

        with transaction.atomic():      #rolls back transaction of not fully complete so we dont end up with half done database
            self.seed_vehicles(data)

        self.stdout.write(
            self.style.SUCCESS("Vehicle data seeded successfully!")
        )

    def seed_vehicles(self, data):
        for make_data in data["makes"]:
            make, _ = VehicleMake.objects.get_or_create(        #get_or_create: if present, get else create, returns the value,if it was created or not(boolean)
                name=make_data["name"]
            )

            self.stdout.write(f"Processing {make.name}...")

            for model_data in make_data["models"]:
                model, _ = VehicleModel.objects.get_or_create(
                    make=make,
                    name=model_data["name"]
                )

                for generation_data in model_data["generations"]:
                    generation, _ = VehicleGeneration.objects.get_or_create(
                        model=model,
                        name=generation_data["name"],
                        defaults={
                            "year_from": generation_data["year_from"],
                            "year_to": generation_data["year_to"],
                        }
                    )

                    for engine_data in generation_data["engines"]:
                        engine, _ = Engine.objects.get_or_create(
                            name=engine_data["name"],
                            displacement_cc=engine_data["displacement_cc"],
                            fuel_type=engine_data["fuel_type"],
                            aspiration=engine_data["aspiration"],
                        )

                        for year in engine_data["years"]:
                            for transmission in engine_data["transmissions"]:
                                VehicleSpecification.objects.get_or_create(
                                    generation=generation,
                                    year=year,
                                    engine=engine,
                                    transmission_type=transmission,
                                )