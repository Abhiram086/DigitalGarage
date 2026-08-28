import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'vehicle_metrics_screen.dart'; // We will create this next!

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  List<dynamic> makes = [];
  List<dynamic> models = [];
  List<dynamic> generations = [];
  List<dynamic> engines = [];
  List<dynamic> specifications = [];

  int? selectedMakeId;
  int? selectedModelId;
  int? selectedGenerationId;
  int? selectedEngineId;
  int? selectedSpecId;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final fetchedMakes = await ApiService.getMakes();
    setState(() {
      makes = fetchedMakes;
      isLoading = false;
    });
  }

  Future<void> _onMakeSelected(int? makeId) async {
    if (makeId == null) return;
    setState(() {
      selectedMakeId = makeId;
      selectedModelId = null;
      selectedGenerationId = null;
      selectedEngineId = null;
      selectedSpecId = null;
      models = [];
      generations = [];
      engines = [];
      specifications = [];
    });
    final fetchedModels = await ApiService.getModels(makeId);
    setState(() => models = fetchedModels);
  }

  Future<void> _onModelSelected(int? modelId) async {
    if (modelId == null) return;
    setState(() {
      selectedModelId = modelId;
      selectedGenerationId = null;
      selectedEngineId = null;
      selectedSpecId = null;
      generations = [];
      engines = [];
      specifications = [];
    });
    final fetchedGenerations = await ApiService.getGenerations(modelId);
    setState(() => generations = fetchedGenerations);
  }

  Future<void> _onGenerationSelected(int? genId) async {
    if (genId == null) return;
    setState(() {
      selectedGenerationId = genId;
      selectedEngineId = null;
      selectedSpecId = null;
      engines = [];
      specifications = [];
    });
    final fetchedEngines = await ApiService.getEngines(genId);
    setState(() => engines = fetchedEngines);
  }

  Future<void> _onEngineSelected(int? engineId) async {
    if (engineId == null) return;
    setState(() {
      selectedEngineId = engineId;
      selectedSpecId = null;
      specifications = [];
    });
    final fetchedSpecs = await ApiService.getSpecifications(selectedGenerationId!, engineId);
    setState(() => specifications = fetchedSpecs);
  }

  void _onSpecSelected(int? specId) {
    if (specId == null) return;
    setState(() => selectedSpecId = specId);
  }

  // --- PREMIUM BOTTOM SHEET PICKER ---
  void _showSelectionModal({
    required String title,
    required List<dynamic> items,
    required int? currentValue,
    required Function(int?) onSelect,
    String Function(dynamic)? displayFormat,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Allows it to size dynamically
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1F24),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Select $title",
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = item['id'] == currentValue;
                    final displayText = displayFormat != null ? displayFormat(item) : item['name'];

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      title: Text(
                        displayText,
                        style: GoogleFonts.robotoMono(
                          color: isSelected ? Colors.blueAccent : Colors.white,
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Colors.blueAccent) : null,
                      onTap: () {
                        Navigator.pop(context); // Close the sheet
                        onSelect(item['id']);   // Trigger the domino effect
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- UPDATED UI BUILDER ---
  Widget _buildStepCard({
    required String label,
    required int? currentValue,
    required List<dynamic> items,
    required Function(int?) onChanged,
    required bool isEnabled,
    String Function(dynamic)? displayFormat,
  }) {
    final bool isCompleted = currentValue != null;

    // Find the display text for the currently selected item
    String getSelectedText() {
      if (!isCompleted) return isEnabled ? "Tap to select..." : "Awaiting previous step";
      final selectedItem = items.firstWhere((item) => item['id'] == currentValue, orElse: () => null);
      if (selectedItem == null) return "Unknown";
      return displayFormat != null ? displayFormat(selectedItem) : selectedItem['name'];
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: isEnabled ? 1.0 : 0.3,
      child: GestureDetector(
        onTap: isEnabled
            ? () => _showSelectionModal(
          title: label,
          items: items,
          currentValue: currentValue,
          onSelect: onChanged,
          displayFormat: displayFormat,
        )
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1F24),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCompleted
                  ? Colors.blueAccent.withOpacity(0.5)
                  : (isEnabled ? Colors.white10 : Colors.transparent),
              width: 1.5,
            ),
            boxShadow: isCompleted
                ? [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 4),
              )
            ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: GoogleFonts.outfit(
                      color: isCompleted ? Colors.blueAccent : Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (isCompleted)
                    const Icon(Icons.check_circle_rounded, color: Colors.blueAccent, size: 16)
                  else if (isEnabled)
                    const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                getSelectedText(),
                style: GoogleFonts.robotoMono(
                  color: isEnabled ? Colors.white : Colors.white24,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          "Configure Baseline",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vehicle Telemetry Sync",
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Select your exact vehicle specifications to ensure accurate predictive maintenance tracking.",
              style: GoogleFonts.robotoMono(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 32),

            _buildStepCard(
              label: "Make",
              currentValue: selectedMakeId,
              items: makes,
              onChanged: _onMakeSelected,
              isEnabled: true,
            ),

            _buildStepCard(
              label: "Model",
              currentValue: selectedModelId,
              items: models,
              onChanged: _onModelSelected,
              isEnabled: selectedMakeId != null,
            ),

            _buildStepCard(
              label: "Generation",
              currentValue: selectedGenerationId,
              items: generations,
              onChanged: _onGenerationSelected,
              isEnabled: selectedModelId != null,
            ),

            _buildStepCard(
              label: "Engine",
              currentValue: selectedEngineId,
              items: engines,
              onChanged: _onEngineSelected,
              isEnabled: selectedGenerationId != null,
              displayFormat: (item) => "${item['name']} (${item['fuel_type']})",
            ),

            _buildStepCard(
              label: "Transmission & Year",
              currentValue: selectedSpecId,
              items: specifications,
              onChanged: _onSpecSelected,
              isEnabled: selectedEngineId != null,
              displayFormat: (item) => "${item['year']} - ${item['transmission_type']}",
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              child: selectedSpecId != null
                  ? Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16, bottom: 40),
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Color(0xFF1E88E5)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // Find the actual names from the lists based on the selected IDs
                      final engineData = engines.firstWhere((e) => e['id'] == selectedEngineId);
                      final specData = specifications.firstWhere((s) => s['id'] == selectedSpecId);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleMetricsScreen(
                            specificationId: selectedSpecId!,
                            engineName: engineData['name'],                   // PASS ENGINE
                            transmissionName: specData['transmission_type'],  // PASS TRANSMISSION
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        "CONFIRM SPECIFICATION",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              )
                  : const SizedBox(width: double.infinity),
            )
          ],
        ),
      ),
    );
  }
}