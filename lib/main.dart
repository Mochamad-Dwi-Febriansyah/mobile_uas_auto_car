import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uas_fix/firebase_options.dart';
import 'package:uas_fix/screen/login.dart';
import 'package:uas_fix/screen/main/home.dart';
import 'package:uas_fix/screen/main/marketplace.dart';
import 'package:uas_fix/screen/main/notifikasi.dart';
import 'package:uas_fix/screen/main/profile.dart';
import 'package:uas_fix/screen/onboarding.dart';
import 'package:uas_fix/screen/registrasi.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/product': (context) => MarketplaceScreen(),
        '/notification': (context) => NotificationScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
 