import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'log_service_screen.dart';

class VehicleDashboard extends StatefulWidget {
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
  State<VehicleDashboard> createState() => _VehicleDashboardState();
}

class _VehicleDashboardState extends State<VehicleDashboard> {
  bool _isLoaded = false;
  bool _isPowertrainExpanded = false; // Controls the expandable detail view

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _isLoaded = true);
    });
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C10),
      body: Stack(
        children: [
          // --- AMBIENT GLOWS FOR GLASSMORPHISM ---
          Positioned(
            top: screenHeight * 0.45,
            left: -50,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.15),
                boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 100, spreadRadius: 50)],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -50,
            child: Container(
              width: 150, height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Changed from purple to a dark, modern teal/cyan blend
                color: Colors.tealAccent.withOpacity(0.08),
                boxShadow: [BoxShadow(color: Colors.tealAccent.withOpacity(0.15), blurRadius: 100, spreadRadius: 50)],
              ),
            ),
          ),

          // --- STATIC 3D MODEL VIEWER (FIXED IN PLACE) ---
          Positioned(
            top: screenHeight * 0.10, // Pushed down slightly to give the huge title room
            left: 0, right: 0,
            height: screenHeight * 0.45,
            child: IgnorePointer(
              child: ModelViewer(
                src: widget.assetPath,
                alt: '3D vehicle model',
                cameraControls: false,
                autoRotate: false,
                disableZoom: true,
                disablePan: true,
                cameraOrbit: '45deg 75deg auto',
                backgroundColor: Colors.transparent,
              ),
            ),
          ),

          // --- SCROLLABLE FOREGROUND UI (WITH SMOOTH FADE EFFECT) ---
          Positioned.fill(
            child: ShaderMask(
              // This shader creates the smooth fade-out blur effect at the center of the screen
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent, // Completely invisible at the top
                    Colors.transparent,
                    Colors.white,       // Fully visible at the bottom
                    Colors.white,
                  ],
                  stops: [
                    0.0,
                    0.45, // Starts fading in at 45% of the screen height
                    0.55, // Fully solid by 55% of the screen height
                    1.0,
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                // Padding pushes the cards down so they start below the car
                padding: EdgeInsets.only(
                  top: screenHeight * 0.55,
                  left: 20,
                  right: 20,
                  bottom: 40,
                ),
                children: [
                  AnimatedOpacity(
                    opacity: _isLoaded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 600),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: GlassBentoCard(
                                title: "ODOMETER",
                                value: _formatNumber(widget.odometer),
                                unit: "KM",
                                icon: Icons.speed_rounded,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: GlassBentoCard(
                                title: "REGISTRATION",
                                value: widget.plate,
                                isSmallText: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // EXPANDABLE POWERTRAIN CARD
                        GestureDetector(
                          onTap: () => setState(() => _isPowertrainExpanded = !_isPowertrainExpanded),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn,
                            child: GlassBentoCard(
                              title: "POWERTRAIN",
                              value: widget.engine,
                              subtitle: "Transmission: ${widget.transmission}",
                              icon: Icons.memory_rounded,
                              isFullWidth: true,
                              isExpanded: _isPowertrainExpanded,
                              expandedContent: Column(
                                children: [
                                  const SizedBox(height: 16),
                                  Divider(color: Colors.white.withOpacity(0.1)),
                                  const SizedBox(height: 16),
                                  _buildDetailRow("Fuel Type", "Petrol"),
                                  const SizedBox(height: 8),
                                  _buildDetailRow("Aspiration", "Naturally Aspirated"),
                                  const SizedBox(height: 8),
                                  _buildDetailRow("Displacement", "1197 cc"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // MAINTENANCE ACTION CARD
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                                  colors: [Colors.blueAccent.withOpacity(0.15), Colors.blueAccent.withOpacity(0.05)],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.auto_awesome_rounded, color: Colors.blueAccent, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        "MAINTENANCE TRACKER",
                                        style: GoogleFonts.robotoMono(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Next scheduled service estimated at ${_formatNumber(widget.odometer + 10000)} km.",
                                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 16),
                                  ),
                                  const SizedBox(height: 24),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LogServiceScreen(vehicleId: "TEMP_ID", vehicleNickname: widget.nickname)));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(16)),
                                      child: Center(
                                        child: Text("Log New Service", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- FIXED TOP HEADER & TITLE (Never moves) ---
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fixed Back Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: _buildFloatingAction(Icons.arrow_back_ios_new_rounded),
                    ),
                    const SizedBox(width: 16),

                    // Massive Fixed Title Block
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.nickname,
                            style: GoogleFonts.manrope(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.1,
                              letterSpacing: -1.0, // Tight kerning for a modern editorial look
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                              widget.model,
                              style: GoogleFonts.robotoMono(fontSize: 14, color: Colors.white54)
                          ),
                        ],
                      ),
                    ),

                    // Fixed Action Buttons
                    Column(
                      children: [
                        _buildFloatingAction(Icons.settings_rounded),
                        const SizedBox(height: 12),
                        _buildFloatingAction(Icons.share_rounded),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 12)),
        Text(val, style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFloatingAction(IconData icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.02)],
            ),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// REUSABLE GLASS BENTO CARD
// -----------------------------------------------------------------------------
class GlassBentoCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final String? subtitle;
  final IconData? icon;
  final bool isFullWidth;
  final bool isSmallText;
  final bool isExpanded;
  final Widget? expandedContent;

  const GlassBentoCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.subtitle,
    this.icon,
    this.isFullWidth = false,
    this.isSmallText = false,
    this.isExpanded = false,
    this.expandedContent,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          width: isFullWidth ? double.infinity : null,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Colors.white.withOpacity(0.12), Colors.white.withOpacity(0.02)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white54, size: 16),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.robotoMono(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 1.2),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (expandedContent != null)
                    Icon(isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: Colors.white54, size: 18)
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: GoogleFonts.outfit(fontSize: isSmallText ? 18 : 28, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (unit != null) ...[
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(unit!, style: GoogleFonts.robotoMono(fontSize: 14, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                    ),
                  ]
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(subtitle!, style: GoogleFonts.robotoMono(fontSize: 12, color: Colors.white54)),
              ],

              if (expandedContent != null)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: isExpanded ? expandedContent! : const SizedBox.shrink(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}