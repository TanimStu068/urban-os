import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:urban_os/UrbanOSApp.dart';
import 'package:urban_os/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(AppProviders(child: Urbanosapp()));
}
