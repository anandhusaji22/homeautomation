// // main.dart
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:home/screens/login_screen.dart'; // Assuming LoginScreen.routeName is defined in this file

// const String clientId = '342223894001-qbo6u1p4ih2t8u47q58sgg6hn5uhngma.apps.googleusercontent.com';

// Future<void> signupGoogle(BuildContext context) async {
//   try {
//     // Initialize Firebase app
//     await Firebase.initializeApp();

//     // Initialize GoogleSignIn with your client ID
//     final GoogleSignIn _googleSignIn = GoogleSignIn(
//       clientId: clientId,
//     );

//     // Check if the user is already signed in
//     final GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
//     if (googleUser != null) {
//       await _handleSignIn(googleUser, context);
//       return;
//     }

//     // Render Google Sign-In button
//     final Widget googleSignInButton = ElevatedButton(
//       onPressed: () async {
//         try {
//           // Start the Google sign-in process
//           final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//           if (googleUser != null) {
//             await _handleSignIn(googleUser, context);
//           } else {
//             print('Google sign in aborted by user.');
//           }
//         } catch (error) {
//           print('Error signing in with Google: $error');
//         }
//       },
//       child: Text('Sign in with Google'),
//     );

//     // Display the Google Sign-In button
//     print('Google Sign-In button: $googleSignInButton');
//   } catch (error) {
//     print('Error initializing Firebase or signing in with Google: $error');
//   }
// }

// Future<void> _handleSignIn(GoogleSignInAccount googleUser, BuildContext context) async {
//   try {
//     // Create a Firebase credential using the Google authentication credentials
//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       idToken: googleAuth.idToken,
//       accessToken: googleAuth.accessToken,
//     );

//     // Sign in to Firebase with the Google credentials
//     final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

//     // Get the user information
//     final User? user = userCredential.user;

//     if (user != null) {
//       // If user is signed in successfully, navigate to login screen
//       String email = user.email ?? "Unknown Email";
//       String displayName = user.displayName ?? "Unknown";

//       print('User signed in with email: $email');
//       print('User signed in with display name: $displayName');

//       // Save user data to Firestore
//       await saveUserData(email, displayName);

//       // Navigate to another screen
//       Navigator.pushNamed(context, LoginScreen.routeName, arguments: {
//         'userEmail': email,
//         'userName': displayName,
//       });
//     } else {
//       print('Error signing in with Google: user is null');
//     }
//   } catch (error) {
//     print('Error handling sign in with Google: $error');
//   }
// }

// Future<void> saveUserData(String email, String displayName) async {
//   // Code to save user data to Firestore
//   // For example:
//   // await FirebaseFirestore.instance.collection('users').doc(email).set({
//   //   'displayName': displayName,
//   //   'email': email,
//   // });
// }
