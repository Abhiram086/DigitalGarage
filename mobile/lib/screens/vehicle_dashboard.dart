import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VehicleDashboard extends StatelessWidget {
  final String nickname;
  final String model;
  final String plate;

  const VehicleDashboard({
    super.key,
    required this.nickname,
    required this.model,
    required this.plate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          nickname,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // The Futuristic 3D HUD Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: 350,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Placeholder for your future 3D Model (.glb)
                  Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.2),
                          blurRadius: 50,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      size: 100,
                      color: Colors.white24,
                    ),
                  ),

                  // Futuristic Pointers / Telemetry Callouts
                  _buildPointer(top: 40, left: 20, label: 'ENG TEMP\n88°C', alignRight: false),
                  _buildPointer(top: 80, right: 20, label: 'AERO\nACTIVE', alignRight: true),
                  _buildPointer(bottom: 60, left: 30, label: 'TYRES\n32 PSI', alignRight: false),
                  _buildPointer(bottom: 40, right: 30, label: 'BATTERY\n12.4V', alignRight: true),
                ],
              ),
            ),
          ),

          // The Scrollable Details Section
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'SYSTEM DIAGNOSTICS',
                  style: GoogleFonts.robotoMono(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailCard('Powertrain', 'All systems nominal. Next service in 4,200 km.'),
                const SizedBox(height: 12),
                _buildDetailCard('Telemetry', 'Sync active. Last ping 2 mins ago.'),
                const SizedBox(height: 12),
                _buildDetailCard('Chassis', 'Suspension alignment within factory spec.'),
                const SizedBox(height: 40), // Extra space for scrolling
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Futuristic HUD Pointer UI
  Widget _buildPointer({double? top, double? bottom, double? left, double? right, required String label, required bool alignRight}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignRight) Container(width: 40, height: 1, color: Colors.blueAccent.withOpacity(0.5)),
          if (alignRight) const SizedBox(width: 8),
          Text(
            label,
            textAlign: alignRight ? TextAlign.left : TextAlign.right,
            style: GoogleFonts.robotoMono(
              color: Colors.white70,
              fontSize: 12,
              height: 1.2,
            ),
          ),
          if (!alignRight) const SizedBox(width: 8),
          if (!alignRight) Container(width: 40, height: 1, color: Colors.blueAccent.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(subtitle, style: GoogleFonts.outfit(fontSize: 14, color: Colors.white60)),
        ],
      ),
    );
  }
}