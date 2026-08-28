import 'package:car_dashboard/providers/garage_provider.dart';
import 'package:car_dashboard/screens/add_vehicle_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math; // Required for 3D angles
import 'vehicle_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // The master timer controls the total duration of all flips
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    // Automatically start the animation when the screen loads
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes
    final garage = context.watch<GarageProvider>().vehicles;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Select Vehicle',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blueAccent),
            onPressed: () {
              // Navigate to Add Vehicle flow
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddVehicleScreen()),
              );
            },
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: garage.length,
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final vehicle = garage[index];
          return _buildAnimatedCard(
            index: index,
            child: _buildVehicleCard(
              context,
              nickname: vehicle.nickname,
              model: "Spec ID: ${vehicle.id}",
              plate: vehicle.plate,
              assetPath: vehicle.assetPath,
              odometer: vehicle.odometer,
              engine: vehicle.engine,             // PASS TO CARD
              transmission: vehicle.transmission, // PASS TO CARD
            ),
          );
        },
      ),
    );
  }

  // The 3D Hinge Logic
  Widget _buildAnimatedCard({required int index, required Widget child}) {
    // Calculates the delay based on the index (0.2 seconds between each card)
    final double start = index * 0.2;
    final double end = (start + 0.6).clamp(0.0, 1.0);

    final animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutQuint),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Map the animation value (0 to 1) into an angle (90 degrees to 0 degrees)
        final angle = (1 - animation.value) * (math.pi / 2);

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002) // Adds 3D camera depth
            ..rotateX(-angle), // Flips the card down
          alignment: Alignment.topCenter, // Anchors the "hinge" to the top edge
          child: child,
        );
      },
      child: child,
    );
  }

  Widget _buildVehicleCard(BuildContext context,
      {required String nickname, required String model, required String plate, required String assetPath, required int odometer, required String engine, required String transmission,}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => VehicleDashboard(
              nickname: nickname,
              model: model,
              engine: engine, // Pending backend GET update
              transmission: transmission, // Pending backend GET update
              plate: plate,
              odometer: odometer,
              assetPath: assetPath,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      // ... keep the rest of your card UI here
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2A2D34), Color(0xFF1E1F24)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.directions_car_filled,
                size: 180,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      plate,
                      style: GoogleFonts.robotoMono(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    nickname,
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    model,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}