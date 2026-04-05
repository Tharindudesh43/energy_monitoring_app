import 'package:energy_monitoring_app/auth-pages/signin.dart';
import 'package:energy_monitoring_app/user-pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://qptekvmlvfawciihykds.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFwdGVrdm1sdmZhd2NpaWh5a2RzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUzNzIzODYsImV4cCI6MjA5MDk0ODM4Nn0.BHWkIjJb3beTTTVt39HZlcYAEA6hae0O5N3eqT_Bx9M",
  );

  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Energy Monitoring App',
      theme: ThemeData(
        // colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StreamBuilder(
        stream: supabase.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final session = snapshot.data?.session;
          return session != null ? const HomePage() : const Signin();
        },
      ),
    );
  }
}
