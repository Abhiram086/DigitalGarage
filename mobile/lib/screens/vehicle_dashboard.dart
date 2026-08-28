import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class VehicleDashboard extends StatelessWidget {
  final String nickname;
  final String model;
  final String engine;
  final String transmission;
  final String plate;
  final int odometer;
  final String assetPath;

  const VehicleDashboard({
    super.key,
    required this.nickname,
    required this.model,
    required this.engine,
    required this.transmission,
    required this.plate,
    required this.odometer,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          nickname.toUpperCase(),
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // THE 3D HUD SECTION
          SliverToBoxAdapter(
            child: SizedBox(
              height: 380,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // The Live 3D Model
                  SizedBox(
                    width: double.infinity,
                    height: 380,
                    child: ModelViewer(
                      src: assetPath,
                      alt: 'A 3D model of the vehicle',
                      interactionPrompt: InteractionPrompt.auto,
                      interactionPromptStyle: InteractionPromptStyle.basic,
                      autoRotate: true,
                      rotationPerSecond: '15deg',
                      autoRotateDelay: 1000,
                      cameraControls: true,
                      disableZoom: true,
                      disablePan: true,
                      cameraOrbit: '45deg 75deg auto',
                      minCameraOrbit: 'auto 75deg auto',
                      maxCameraOrbit: 'auto 75deg auto',
                      backgroundColor: Colors.transparent,
                    ),
                  ),

                  // DYNAMIC TELEMETRY POINTERS
                  _buildPointer(
                    top: 40,
                    left: 20,
                    label: 'CHASSIS\n$model',
                    alignRight: false,
                  ),
                  _buildPointer(
                    top: 80,
                    right: 20,
                    label: 'ODO\n${_formatNumber(odometer)} KM',
                    alignRight: true,
                  ),
                  _buildPointer(
                    bottom: 60,
                    left: 30,
                    label: 'POWERTRAIN\n$engine',
                    alignRight: false,
                  ),
                  _buildPointer(
                    bottom: 40,
                    right: 30,
                    label: 'REGISTRATION\n$plate',
                    alignRight: true,
                  ),
                ],
              ),
            ),
          ),

          // THE ACTUAL METRICS SECTION
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'BASELINE METRICS',
                  style: GoogleFonts.robotoMono(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),

                _buildDataCard(
                  icon: Icons.fingerprint_rounded,
                  title: 'Vehicle Identity',
                  line1: 'Alias: $nickname',
                  line2: 'Plates: $plate',
                ),
                const SizedBox(height: 12),

                _buildDataCard(
                  icon: Icons.settings_suggest_rounded,
                  title: 'Hardware Specification',
                  line1: 'Engine: $engine',
                  line2: 'Transmission: $transmission',
                ),
                const SizedBox(height: 12),

                _buildDataCard(
                  icon: Icons.timeline_rounded,
                  title: 'Maintenance Tracking',
                  line1: 'Current Read: ${_formatNumber(odometer)} km',
                  // Simple predictive logic: adds 10k to current odo for next service interval
                  line2: 'Est. Next Service: ${_formatNumber(odometer + 10000)} km',
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to format large numbers with commas (e.g., 12500 -> 12,500)
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  // Futuristic HUD Pointer UI
  Widget _buildPointer({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required String label,
    required bool alignRight,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignRight) Container(width: 30, height: 1, color: Colors.blueAccent.withOpacity(0.5)),
          if (alignRight) const SizedBox(width: 8),
          Text(
            label,
            textAlign: alignRight ? TextAlign.left : TextAlign.right,
            style: GoogleFonts.robotoMono(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          if (!alignRight) const SizedBox(width: 8),
          if (!alignRight) Container(width: 30, height: 1, color: Colors.blueAccent.withOpacity(0.5)),
        ],
      ),
    );
  }

  // Beautiful Data Cards for the bottom section
  Widget _buildDataCard({
    required IconData icon,
    required String title,
    required String line1,
    required String line2,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  line1,
                  style: GoogleFonts.robotoMono(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  line2,
                  style: GoogleFonts.robotoMono(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}