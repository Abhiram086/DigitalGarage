from rest_framework.response import Response
from rest_framework.views import APIView

from .models import (
    Engine,
    VehicleGeneration,
    VehicleMake,
    VehicleModel,
    VehicleSpecification,
)
from .serializers import (
    EngineSerializer,
    VehicleGenerationSerializer,
    VehicleMakeSerializer,
    VehicleModelSerializer,
    VehicleSpecificationSerializer,
)


class VehicleMakeListView(APIView):
    def get(self, request):
        makes = VehicleMake.objects.all()
        serializer = VehicleMakeSerializer(makes, many=True)
        return Response(serializer.data)


class VehicleModelListView(APIView):
    def get(self, request):
        make_id = request.query_params.get("make")

        models = VehicleModel.objects.filter(make_id=make_id)

        serializer = VehicleModelSerializer(models, many=True)
        return Response(serializer.data)


class VehicleGenerationListView(APIView):
    def get(self, request):
        model_id = request.query_params.get("model")

        generations = VehicleGeneration.objects.filter(
            model_id=model_id
        )

        serializer = VehicleGenerationSerializer(
            generations,
            many=True
        )

        return Response(serializer.data)


class EngineListView(APIView):
    def get(self, request):
        generation_id = request.query_params.get("generation")

        engines = Engine.objects.filter(
            vehicle_specifications__generation_id=generation_id
        ).distinct()

        serializer = EngineSerializer(engines, many=True)

        return Response(serializer.data)


class VehicleSpecificationListView(APIView):
    def get(self, request):
        generation_id = request.query_params.get("generation")
        engine_id = request.query_params.get("engine")

        specifications = VehicleSpecification.objects.filter(
            generation_id=generation_id,
            engine_id=engine_id,
        )

        serializer = VehicleSpecificationSerializer(
            specifications,
            many=True
        )

        return Response(serializer.data)