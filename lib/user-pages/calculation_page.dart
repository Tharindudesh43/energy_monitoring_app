import 'package:flutter/material.dart';

class CalculationPage extends StatefulWidget {
  const CalculationPage({super.key});

  @override
  State<CalculationPage> createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  final _wattsController = TextEditingController();
  final _hoursController = TextEditingController();
  double _result = 0.0;

  void _calculateUnits() {
    double watts = double.tryParse(_wattsController.text) ?? 0;
    double hours = double.tryParse(_hoursController.text) ?? 0;

    setState(() {
      // Formula: (Watts * Hours) / 1000 = kWh (Units)
      _result = (watts * hours) / 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F17),
      appBar: AppBar(
        title: const Text("Unit Calculator"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Estimate your consumption",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 25),

            // Wattage Input
            _buildInput("Device Wattage (W)", _wattsController, Icons.bolt),
            const SizedBox(height: 15),

            // Hours Input
            _buildInput("Usage Hours per Day", _hoursController, Icons.timer),
            const SizedBox(height: 25),

            // Calculate Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _calculateUnits,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF13EC92),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Calculate kWh",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Result Display
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF193328),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF234839)),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Estimated Daily Units",
                      style: TextStyle(color: Colors.white38, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${_result.toStringAsFixed(2)} kWh",
                      style: const TextStyle(
                        color: Color(0xFF13EC92),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: const Color(0xFF13EC92)),
        filled: true,
        fillColor: const Color(0xFF193328),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
