import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Select Vehicle',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildVehicleCard(
            context,
            nickname: 'Daily Driver',
            model: 'Mahindra 3XO ',
            plate: 'KL 36 M 3020',
          ),
          const SizedBox(height: 24),
          _buildVehicleCard(
            context,
            nickname: 'Weekend Ride',
            model: 'Royal Enfield GT 650',
            plate: 'KL 36 X 9999',
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context,
      {required String nickname, required String model, required String plate}) {
    return GestureDetector(
      onTap: () {
        // We will wire this up to navigate to the specific car's dashboard later
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loading $nickname...')),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32), // Big rounded corners
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
            // Minimal Icon Placeholder for Vehicle Image
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