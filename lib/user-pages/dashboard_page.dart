import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _supabase = Supabase.instance.client;

  bool _isLoading = true;
  List<Map<String, dynamic>> _hourlyData = [];
  List<Map<String, dynamic>> _dailyData = [];

  double _currentPower = 0;
  double _currentVoltage = 0;
  double _todayEnergy = 0;
  double _monthEnergy = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final hourly = await _supabase
          .from('electricity_meter_data')
          .select('timestamp, power_kw, voltage_v, energy_kwh, temperature_c')
          .order('timestamp', ascending: false)
          .limit(24);

      final daily = await _supabase
          .from('electricity_meter_data')
          .select('timestamp, energy_kwh')
          .order('timestamp', ascending: false)
          .limit(168); // 7 days × 24 hours

      if (mounted) {
        setState(() {
          _hourlyData = List<Map<String, dynamic>>.from(
            hourly,
          ).reversed.toList();
          _dailyData = List<Map<String, dynamic>>.from(daily);

          // Latest reading
          if (_hourlyData.isNotEmpty) {
            _currentPower = (_hourlyData.last['power_kw'] ?? 0).toDouble();
            _currentVoltage = (_hourlyData.last['voltage_v'] ?? 0).toDouble();
          }

  
          _todayEnergy = _hourlyData.fold(
            0.0,
            (sum, row) => sum + (row['energy_kwh'] ?? 0).toDouble(),
          );

          _monthEnergy = _dailyData.fold(
            0.0,
            (sum, row) => sum + (row['energy_kwh'] ?? 0).toDouble(),
          );

          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }
  Map<String, double> _getDailyTotals() {
    final Map<String, double> totals = {};
    for (final row in _dailyData) {
      final date = DateTime.parse(row['timestamp'].toString());
      final key = '${date.month}/${date.day}';
      totals[key] = (totals[key] ?? 0) + (row['energy_kwh'] ?? 0).toDouble();
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F17),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF13EC92)),
            )
          : RefreshIndicator(
              onRefresh: _fetchData,
              color: const Color(0xFF13EC92),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _SummaryCard(
                          label: 'Live Power',
                          value: '${_currentPower.toStringAsFixed(2)} kW',
                          icon: Icons.bolt,
                          color: const Color(0xFF13EC92),
                        ),
                        _SummaryCard(
                          label: 'Voltage',
                          value: '${_currentVoltage.toStringAsFixed(1)} V',
                          icon: Icons.electric_meter,
                          color: const Color(0xFF4FC3F7),
                        ),
                        _SummaryCard(
                          label: "Today's Usage",
                          value: '${_todayEnergy.toStringAsFixed(2)} kWh',
                          icon: Icons.today,
                          color: const Color(0xFFFFB74D),
                        ),
                        _SummaryCard(
                          label: 'This Week',
                          value: '${_monthEnergy.toStringAsFixed(1)} kWh',
                          icon: Icons.calendar_month,
                          color: const Color(0xFFCE93D8),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Power Line Chart ──────────────────────
                    _SectionTitle(title: 'Power Trend (24h)'),
                    const SizedBox(height: 12),
                    _buildSimpleTrend(),

                    const SizedBox(height: 24),

                    // Replace _buildBarChart() with:
                    _SectionTitle(title: 'Daily Consumption'),
                    const SizedBox(height: 12),
                    _buildSimpleUsageList(),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }


  Widget _buildSimpleTrend() {
    if (_hourlyData.isEmpty) return const SizedBox.shrink();

    final dataPoints = _hourlyData
        .map((e) => (e['power_kw'] ?? 0.0).toDouble())
        .toList();

    final spots = dataPoints
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    final maxY = (dataPoints.reduce((a, b) => a > b ? a : b) * 1.2).clamp(
      1.0,
      double.infinity,
    );

    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF193328),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF234839)),
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF13EC92),
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF13EC92).withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleUsageList() {
    final dailyTotals = _getDailyTotals();
    if (dailyTotals.isEmpty) return const SizedBox.shrink();

    double maxVal = dailyTotals.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF193328),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: dailyTotals.entries.map((e) {
          double percentage = e.value / maxVal;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 45,
                  child: Text(
                    e.key,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    color: const Color(0xFF13EC92),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${e.value.toStringAsFixed(1)} kWh',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

//Reusable Widgets
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF193328),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF234839)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
