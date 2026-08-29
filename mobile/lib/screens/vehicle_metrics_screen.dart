import 'package:car_dashboard/models/vehicle.dart';
import 'package:car_dashboard/providers/garage_provider.dart';
import 'package:car_dashboard/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';

class VehicleMetricsScreen extends StatefulWidget {
  final int specificationId;
  final String engineName;       // NEW
  final String transmissionName; // NEW

  const VehicleMetricsScreen({
    super.key,
    required this.specificationId,
    required this.engineName,
    required this.transmissionName,
  });

  @override
  State<VehicleMetricsScreen> createState() => _VehicleMetricsScreenState();
}

class _VehicleMetricsScreenState extends State<VehicleMetricsScreen> {
  final nicknameController = TextEditingController();
  final plateController = TextEditingController();
  final odometerController = TextEditingController();

// Add a loading state variable at the top of your state class:
  bool isProcessing = false;

  void _saveVehicle() async {
    final nickname = nicknameController.text.trim();
    final plate = plateController.text.trim();
    final odometer = int.tryParse(odometerController.text.trim()) ?? 0;

    if (nickname.isEmpty || plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all identity fields.")),
      );
      return;
    }

    setState(() => isProcessing = true);

    // 1. PING DJANGO: Save to the real database
    bool success = await ApiService.addMyVehicle(
      widget.specificationId,
      nickname,
      odometer,
    );

    if (success) {
      // 2. UPDATE UI: If successful, create the local 3D card
      final newVehicle = Vehicle(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'Car',
        nickname: nickname,
        plate: plate,
        odometer: odometer,
        assetPath: 'assets/models/generic_car.glb',
        engine: widget.engineName,
        transmission: widget.transmissionName,
      );

      // Add to local memory so it appears instantly without reloading
      if (mounted) {
        context.read<GarageProvider>().addVehicle(newVehicle);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Telemetry Sync Successful!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to sync with server. Try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() => isProcessing = false);
    }
  }

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
          "Set Metrics",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Identity & Odometer",
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter current readings to initialize the predictive maintenance algorithms.",
              style: GoogleFonts.robotoMono(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 32),

            Text("NICKNAME", style: GoogleFonts.outfit(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            MyTextField(
              controller: nicknameController,
              hintText: "e.g., Daily Driver, The Beast",
              obscureText: false,
            ),
            const SizedBox(height: 24),

            Text("LICENSE PLATE", style: GoogleFonts.outfit(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            MyTextField(
              controller: plateController,
              hintText: "e.g., KL 36 M 3020",
              obscureText: false,
            ),
            const SizedBox(height: 24),

            Text("CURRENT ODOMETER (KM)", style: GoogleFonts.outfit(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            TextField(
              controller: odometerController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.robotoMono(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white10)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blueAccent)),
                fillColor: const Color(0xFF1E1F24),
                filled: true,
                hintText: "000000",
                hintStyle: GoogleFonts.robotoMono(color: Colors.white38),
              ),
            ),

            const SizedBox(height: 48),
            isProcessing
                ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
                : MyButton(
              onTap: _saveVehicle,
              text: "INITIALIZE TELEMETRY",
            ),
          ],
        ),
      ),
    );
  }
}