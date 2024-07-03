// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeautomated/firebase_options.dart';
import 'package:homeautomated/privider.dart';
import 'package:homeautomated/screens/home_screen.dart';
import 'package:homeautomated/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'Your App Title',
        theme: ThemeData(
          brightness: Brightness.light,
          // Add your theme configurations here
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error loading data. Please try again later.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        } else {
          bool isLoggedIn = snapshot.data?.getBool('isLoggedIn') ?? false;
          return isLoggedIn ? HomeScreen() : LoginScreen();
        }
      },
    );
  }
}

// class AuthenticationWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     return FutureBuilder<SharedPreferences>(
//       future: SharedPreferences.getInstance(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           bool isLoggedIn = snapshot.data?.getBool('isLoggedIn') ?? false;
//           if (isLoggedIn) {
//             return HomeScreen();
//           } else {
//             return LoginScreen();
//           }
//         }
//       },
//     );
//   }
// }
