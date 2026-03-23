import 'package:flutter/material.dart';
import 'package:urban_os/screens/auth/splash_screen.dart';

class Urbanosapp extends StatelessWidget {
  const Urbanosapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UrbanOS',
      home: const SplashScreen(),
    );
  }
}
