import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ruh_care/screens/login_screen.dart';
import 'package:ruh_care/screens/main_navigation.dart';
import 'package:ruh_care/screens/splash_screen.dart';
import 'firebase_options.dart';
//import 'package:ruh_care/helpers/sample_data_helper.dart'; // UNCOMMENT TO POPULATE DATA
//import 'package:ruh_care/helpers/update_therapy_images.dart'; // UNCOMMENT TO ADD IMAGES

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // UNCOMMENT BELOW TO POPULATE SAMPLE THERAPIES (RUN ONCE ONLY)
    // await SampleDataHelper().addSampleTherapies();
    //print('✅ Sample data populated! Comment out this line now.');

    // UNCOMMENT BELOW TO ADD IMAGES TO THERAPIES (RUN ONCE ONLY)
    // await UpdateTherapyImages().updateTherapyImages();
    // print('🎉 Images added! Comment out this line now.');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    runApp(ErrorApp(error: e.toString()));
    return;
  }
  runApp(const MyApp());
}

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Initialization Error',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Make sure you are running the app on Android. If testing on Windows/Web, you need firebase_options.dart.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruh-Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B7B3A)),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}
