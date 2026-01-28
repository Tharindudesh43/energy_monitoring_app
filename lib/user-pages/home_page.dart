
import 'package:energy_monitoring_app/user-pages/calculation_page.dart';
import 'package:energy_monitoring_app/user-pages/dashboard_page.dart';
import 'package:energy_monitoring_app/user-pages/recommend_page.dart';
import 'package:energy_monitoring_app/user-pages/user_settings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _index = 0; 

  final List<Widget> _pages = [
    CalculationPage(),
    RecommendPage(),
    UserSettings(),
    DashboardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    String username = "Alex Devil";

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        actionsPadding: const EdgeInsets.all(10),
        actions: const [
          Icon(Icons.notifications),
        ],
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/userImage.jpg'),
        ),
        title: Text(username),
      ),

      body: _pages[_index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        onTap: (int i) {
          setState(() {
            _index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            label: "Calculate",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend_outlined),
            label: "Recommend",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
