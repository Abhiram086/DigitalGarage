from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated

from .models import (
    Engine,
    VehicleGeneration,
    VehicleMake,
    VehicleModel,
    VehicleSpecification,
    UserVehicle,
)
from .serializers import (
    EngineSerializer,
    VehicleGenerationSerializer,
    VehicleMakeSerializer,
    VehicleModelSerializer,
    VehicleSpecificationSerializer,
    UserVehicleSerializer,
    UserVehicleDetailSerializer,
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

class UserVehicleListView(APIView):
    permission_classes = [IsAuthenticated]  #Only allow requests from authenticated user

    def get(self, request):                         #get for showing current User's cars
        vehicles = UserVehicle.objects.filter(
            user=request.user
        )

        serializer = UserVehicleSerializer(
            vehicles,
            many=True
        )

        return Response(serializer.data)

    def post(self, request):                    #Post for creating new car
        serializer = UserVehicleSerializer(         #gets data of a new car created by user
            data=request.data
        )

        if serializer.is_valid():                   #if data is valid, then proceed to create UserVehicle in database row
            vehicle = serializer.save(
                user=request.user
            )

            return Response(
                UserVehicleSerializer(vehicle).data,
                status=201
            )

        return Response(
            serializer.errors,
            status=400
        )

class UserVehicleDetailView(APIView):           #used to retrieve specific car data/info
    permission_classes = [IsAuthenticated]

    def get_object(self, request, pk):
        return UserVehicle.objects.get(
            pk=pk,
            user=request.user
        )

    def get(self, request, pk):
        vehicle = self.get_object(request, pk)

        serializer = UserVehicleDetailSerializer(vehicle)

        return Response(serializer.data)

    def patch(self, request, pk):
        vehicle = self.get_object(request, pk)

        serializer = UserVehicleSerializer(
            vehicle,
            data=request.data,
            partial=True
        )

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors, status=400)

    def delete(self, request, pk):                          #delete specific car
        vehicle = self.get_object(request, pk)  

        vehicle.delete()

        return Response(status=204)