// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:firebase_database/firebase_database.dart';
// // import 'package:google_sign_in/google_sign_in.dart';
// // import 'package:sign_in_button/sign_in_button.dart';

// // const String clientId = '69844578088-164m5qarj8bh4628h99qu4jbnvit6uci.apps.googleusercontent.com';

// // class GoogleSignInPage extends StatefulWidget {
// //   const GoogleSignInPage({Key? key});

// //   @override
// //   State<GoogleSignInPage> createState() => _GoogleSignInPageState();
// // }

// // class _GoogleSignInPageState extends State<GoogleSignInPage> {
// //   final GoogleSignIn _googleSignIn = GoogleSignIn(
// //     clientId: clientId,
// //     scopes: ['email'],
// //   );
// //   User? _user;

// //   Future<void> _signInWithGoogle() async {
// //     try {
// //       final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
// //       if (googleSignInAccount == null) {
// //         _showErrorSnackBar('Google sign-in cancelled');
// //         return;
// //       }
// //       final GoogleSignInAuthentication googleSignInAuthentication =
// //           await googleSignInAccount.authentication;
// //       final OAuthCredential credential = GoogleAuthProvider.credential(
// //         accessToken: googleSignInAuthentication.accessToken,
// //         idToken: googleSignInAuthentication.idToken,
// //       );

// //       final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
// //       setState(() {
// //         _user = userCredential.user;
// //       });

// //       await _handleSignInResult(_user!);
// //     } catch (e) {
// //       print(e);
// //       _showErrorSnackBar('Error signing in: $e');
// //     }
// //   }

// //   Future<void> _handleSignInResult(User user) async {
// //     final bool emailExists = await checkIfEmailExists(user.email!);
// //     if (!emailExists) {
// //       await saveUserToDatabase(user);
// //       _navigateToDeviceConfigureScreen();
// //     } else {
// //       _navigateToHomeScreen();
// //     }
// //   }

// //   Future<bool> checkIfEmailExists(String email) async {
// //     // Check if the email exists in the database
// //     DataSnapshot dataSnapshot =
// //         (await FirebaseDatabase.instance.reference().child('users').child(email.replaceAll('.', ',')).once()) as DataSnapshot;
// //     return dataSnapshot.value != null;
// //   }

// //   Future<void> saveUserToDatabase(User user) async {
// //     // Save user details to the database
// //     await FirebaseDatabase.instance
// //         .reference()
// //         .child('users')
// //         .child(user.email!.replaceAll('.', ','))
// //         .set({'email': user.email});
// //   }

// //   void _navigateToDeviceConfigureScreen() {
// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(builder: (context) => DeviceConfigureScreen()),
// //     );
// //   }

// //   void _navigateToHomeScreen() {
// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(builder: (context) => HomeScreen()),
// //     );
// //   }

// //   void _showErrorSnackBar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             SignInButton(
// //               Buttons.google,
// //               text: "Sign up with Google",
// //               onPressed: _signInWithGoogle,
// //             ),
// //             if (_user != null)
// //               Column(
// //                 children: [
// //                   Text('Welcome, ${_user!.displayName ?? 'User'}!'),
// //                   Text('Email: ${_user!.email}'),
// //                 ],
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class DeviceConfigureScreen extends StatelessWidget {
// //   const DeviceConfigureScreen({Key? key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Device Configure Screen'),
// //       ),
// //       body: const Center(
// //         child: Text('Device Configure Screen'),
// //       ),
// //     );
// //   }
// // }

// // class HomeScreen extends StatelessWidget {
// //   const HomeScreen({Key? key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Home Screen'),
// //       ),
// //       body: const Center(
// //         child: Text('Home Screen'),
// //       ),
// //     );
// //   }
// // }



// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class CheckNamePage extends StatefulWidget {
//   const CheckNamePage({Key? key}) : super(key: key);

//   @override
//   _CheckNamePageState createState() => _CheckNamePageState();
// }

// class _CheckNamePageState extends State<CheckNamePage> {
//   final TextEditingController _nameController = TextEditingController();
//   bool _nameNotFound = false;

//   // Initialize Firebase database reference
//   final DatabaseReference _database = FirebaseDatabase.instance.reference();

//   Future<void> _checkNameExists() async {
//     final String nameToCheck = _nameController.text.trim();
//     if (nameToCheck.isNotEmpty) {
//       final DataSnapshot snapshot = (await _database.child('users').orderByChild('name').equalTo(nameToCheck).once()) as DataSnapshot;
//       if (snapshot.value == null) {
//         setState(() {
//           _nameNotFound = true;
//         });
//       } else {
//         setState(() {
//           _nameNotFound = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Check Name'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Name',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _checkNameExists,
//               child: Text('Check Name'),
//             ),
//             SizedBox(height: 20),
//             if (_nameNotFound)
//               Text(
//                 'Name not found in the database.',
//                 style: TextStyle(color: Colors.green),
//               )
//             else if (_nameController.text.isNotEmpty)
//               Text(
//                 'Name exists in the database.',
//                 style: TextStyle(color: Colors.red),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
