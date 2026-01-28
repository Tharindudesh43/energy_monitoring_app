import 'package:energy_monitoring_app/auth-pages/auth_page.dart';
import 'package:energy_monitoring_app/auth-pages/signin.dart';
import 'package:energy_monitoring_app/user-pages/home_page.dart';
import 'package:flutter/material.dart';


void main() async {
  runApp( MyApp());                               
}

class MyApp extends StatelessWidget {
  bool user_logged = false;

  MyApp({super.key});
 
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: user_logged ? HomePage() : Signin()
    );
  }
}
