import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';

// Local model to handle the dynamic list of tasks in the UI
class ServiceTask {
  String? maintenanceItemId;
  String? action;
  TextEditingController notesController = TextEditingController();
}

class LogServiceScreen extends StatefulWidget {
  final String vehicleId;
  final String vehicleNickname;

  const LogServiceScreen({
    super.key,
    required this.vehicleId,
    required this.vehicleNickname,
  });

  @override
  State<LogServiceScreen> createState() => _LogServiceScreenState();
}

class _LogServiceScreenState extends State<LogServiceScreen> {
  final odometerController = TextEditingController();
  final generalNotesController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  // The dynamic list of tasks performed during this visit
  List<ServiceTask> tasks = [];
  bool isProcessing = false;

  // Mock data for dropdowns (This will later come from ApiService.getMaintenanceItems())
  final List<Map<String, String>> availableItems = [
    {"id": "1", "name": "Engine Oil"},
    {"id": "2", "name": "Oil Filter"},
    {"id": "3", "name": "Brake Pads (Front)"},
    {"id": "4", "name": "Tyres"},
    {"id": "5", "name": "Battery"},
  ];

  // Converted to maps so it uses the exact same modal logic as the items
  final List<Map<String, String>> availableActions = [
    {"id": "REPLACED", "name": "Replaced"},
    {"id": "CHANGED", "name": "Changed"},
    {"id": "INSPECTED", "name": "Inspected"},
    {"id": "SERVICED", "name": "Serviced"},
  ];

  void _addTask() {
    setState(() {
      tasks.add(ServiceTask());
    });
  }

  void _removeTask(int index) {
    setState(() {
      tasks[index].notesController.dispose();
      tasks.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Color(0xFF1E1F24),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  // --- PREMIUM BOTTOM SHEET PICKER ---
  void _showSelectionModal({
    required String title,
    required List<Map<String, String>> items,
    required String? currentValue,
    required Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                      title: Text(
                        item['name']!,
                        style: GoogleFonts.robotoMono(
                          color: isSelected ? Colors.blueAccent : Colors.white,
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Colors.blueAccent) : null,
                      onTap: () {
                        Navigator.pop(context);
                        onSelect(item['id']!);
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

  // Custom UI trigger to open the modal
  Widget _buildModalTrigger({required String hint, required String? currentValueText, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F13),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: currentValueText != null ? Colors.blueAccent.withOpacity(0.5) : Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentValueText ?? hint,
              style: GoogleFonts.robotoMono(
                color: currentValueText != null ? Colors.white : Colors.white38,
                fontSize: 14,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: currentValueText != null ? Colors.blueAccent : Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }

  void _saveLog() {
    print("Saving Service for ${widget.vehicleNickname}");
    print("Date: ${selectedDate.toIso8601String()}");
    print("Odo: ${odometerController.text}");
    print("Notes: ${generalNotesController.text}");
    for (var task in tasks) {
      print("- Task: ${task.maintenanceItemId} | ${task.action} | ${task.notesController.text}");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Service Logged Successfully!"), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    odometerController.dispose();
    generalNotesController.dispose();
    for (var task in tasks) {
      task.notesController.dispose();
    }
    super.dispose();
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
          "LOG SERVICE",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GENERAL INFO SECTION ---
            Text(
              "VISIT DETAILS",
              style: GoogleFonts.robotoMono(color: Colors.blueAccent, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1F24),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, color: Colors.blueAccent, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                            style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            MyTextField(controller: odometerController, hintText: "Current Odometer (KM)", obscureText: false),
            const SizedBox(height: 16),
            TextField(
              controller: generalNotesController,
              maxLines: 3,
              style: GoogleFonts.robotoMono(color: Colors.white),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white10)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blueAccent)),
                fillColor: const Color(0xFF1E1F24),
                filled: true,
                hintText: "General workshop notes...",
                hintStyle: GoogleFonts.robotoMono(color: Colors.white38),
              ),
            ),

            const SizedBox(height: 40),

            // --- TASKS SECTION ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "TASKS PERFORMED",
                  style: GoogleFonts.robotoMono(color: Colors.blueAccent, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                IconButton(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.blueAccent),
                )
              ],
            ),
            const SizedBox(height: 8),

            if (tasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text("No specific tasks added.", style: GoogleFonts.robotoMono(color: Colors.white38)),
                ),
              ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {

                // Helper to find the name of the selected component
                String? getSelectedComponentName() {
                  if (tasks[index].maintenanceItemId == null) return null;
                  return availableItems.firstWhere((item) => item['id'] == tasks[index].maintenanceItemId)['name'];
                }

                // Helper to find the name of the selected action
                String? getSelectedActionName() {
                  if (tasks[index].action == null) return null;
                  return availableActions.firstWhere((act) => act['id'] == tasks[index].action)['name'];
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1F24),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("TASK 0${index + 1}", style: GoogleFonts.outfit(color: Colors.white54, fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () => _removeTask(index),
                            child: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 20),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Component Modal Trigger
                      _buildModalTrigger(
                        hint: "Select Component",
                        currentValueText: getSelectedComponentName(),
                        onTap: () => _showSelectionModal(
                          title: "Component",
                          items: availableItems,
                          currentValue: tasks[index].maintenanceItemId,
                          onSelect: (val) => setState(() => tasks[index].maintenanceItemId = val),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Action Modal Trigger
                      _buildModalTrigger(
                        hint: "Select Action",
                        currentValueText: getSelectedActionName(),
                        onTap: () => _showSelectionModal(
                          title: "Action",
                          items: availableActions,
                          currentValue: tasks[index].action,
                          onSelect: (val) => setState(() => tasks[index].action = val),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Task Notes
                      TextField(
                        controller: tasks[index].notesController,
                        style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blueAccent)),
                          fillColor: const Color(0xFF0F0F13),
                          filled: true,
                          hintText: "Specific notes (e.g. 5W-30 Castrol)",
                          hintStyle: GoogleFonts.robotoMono(color: Colors.white38, fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
            MyButton(onTap: _saveLog, text: "SAVE SERVICE LOG"),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}