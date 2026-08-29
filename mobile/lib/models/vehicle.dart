class Vehicle {
  final String id;
  final String type;
  final String nickname;
  final String plate;
  final int odometer;
  final String assetPath;
  final String engine;
  final String transmission;

  Vehicle({
    required this.id,
    required this.type,
    required this.nickname,
    required this.plate,
    required this.odometer,
    required this.assetPath,
    required this.engine,
    required this.transmission,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'].toString(),
      type: json['type'] ?? 'Car',
      nickname: json['nickname'] ?? 'Unnamed Vehicle',
      odometer: json['odometer'] ?? 0,

      // Fallbacks until the backend serializer includes these fields
      plate: json['plate'] ?? 'AWAITING REG',
      engine: json['engine'] ?? 'Spec ID: ${json['vehicle_specification']}',
      transmission: json['transmission'] ?? 'UNKNOWN',

      assetPath: (json['type'] == 'Motorcycle' || json['type'] == 'Scooter')
          ? 'assets/models/generic_bike.glb'
          : 'assets/models/generic_car.glb',
    );
  }
}