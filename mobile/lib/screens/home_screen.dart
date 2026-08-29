import 'package:car_dashboard/providers/garage_provider.dart';
import 'package:car_dashboard/providers/auth_provider.dart';
import 'package:car_dashboard/screens/add_vehicle_screen.dart';
import 'package:car_dashboard/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // DO NOT call _controller.forward() here!

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 1. Wait for the API to fetch the cars
      await context.read<GarageProvider>().fetchVehicles();

      // 2. NOW trigger the card flip animation!
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final garageProvider = context.watch<GarageProvider>();
    final garage = garageProvider.vehicles;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Garage',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        actions: [
          // ADD VEHICLE BUTTON (Only show in AppBar if garage is not empty)
          if (garage.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.blueAccent),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddVehicleScreen()));
              },
            ),
          // LOGOUT BUTTON
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white54),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                context.read<GarageProvider>().clearVehicles();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: garageProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : garage.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
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
              model: "Spec ID: ${vehicle.engine}", // Temp mapping
              plate: vehicle.plate,
              assetPath: vehicle.assetPath,
              odometer: vehicle.odometer,
              engine: vehicle.engine,
              transmission: vehicle.transmission,
            ),
          );
        },
      ),
    );
  }

  // --- THE NEW EMPTY STATE UI ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car_outlined, size: 100, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 24),
          Text(
            "Your garage is empty.",
            style: GoogleFonts.outfit(color: Colors.white54, fontSize: 18),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 10,
              shadowColor: Colors.blueAccent.withOpacity(0.5),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              "INITIALIZE VEHICLE",
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddVehicleScreen()));
            },
          )
        ],
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