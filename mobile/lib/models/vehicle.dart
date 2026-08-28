class Vehicle {
  final String id;
  final String type;
  final String nickname;
  final String plate;
  final int odometer;
  final String assetPath;
  final String engine;       // NEW
  final String transmission; // NEW

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
      nickname: json['nickname'] ?? 'My Vehicle',
      plate: json['plate'] ?? 'XX 00 X 0000',
      odometer: json['odometer'] ?? 0,
      engine: json['engine'] ?? 'Unknown Engine',
      transmission: json['transmission'] ?? 'Unknown',
      assetPath: (json['type'] == 'Motorcycle' || json['type'] == 'Scooter')
          ? 'assets/models/generic_bike.glb'
          : 'assets/models/generic_car.glb',
    );
  }
}