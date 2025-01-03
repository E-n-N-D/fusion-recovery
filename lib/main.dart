import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fusion_recovery/firebase_options.dart';
import 'package:fusion_recovery/pages/home_page.dart';
import 'package:fusion_recovery/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.blue,
    ),
    initialRoute: "/",
    routes: {
      "/": (context) => const SplashScreen(),
      "/home": (context) => const HomePage(),
    },
  ));
}
