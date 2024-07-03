// ignore_for_file: use_build_context_synchronously, unused_element, library_private_types_in_public_api, use_key_in_widget_constructors, unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:homeautomated/bluetooth.dart';
import 'package:homeautomated/screens/home_screen.dart';
import 'package:homeautomated/wiwfipass.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();



  

  void _signupWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification link
      await authResult.user!.sendEmailVerification();

      // Save user details in the database
      await _database.child('users').child(authResult.user!.uid).set({
        'name': name,
        'email': email,
      });

     Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WifiScreen(data: '123'),
                            ),
                          );
    } catch (e) {
      String errorMessage =
          'Signup failed. Please check your email and password.';
      if (e is FirebaseAuthException) {
        // Handle specific Firebase Authentication errors
        switch (e.code) {
          case 'weak-password':
            errorMessage = 'Password is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage = 'The email address is already in use.';
            break;
          // Add more error cases as needed
        }
      }

      print('Signup error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    }
  }


  void _renameLight( String newName,BuildContext context,
      String newroom,
      String device,
      String code
     )
       async {
        Map<String, String> userData = {
    "room": newroom,
    "name": newName,
    "device": device,
    'code': code
    
  };

  String data = jsonEncode(userData);

  // Append query parameters directly to the URI
  final uri = Uri.https(
    'fxmtqpfni7o3kwciyrwdkykely0pvlnx.lambda-url.ap-south-1.on.aws',
    '/path/to/endpoint',
    {'type': 'rename', 'data': data, 'id': '123'},
  );

  
    try {
      final response = await http.get(uri);

      if (response.body == "success") {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Name Change Successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        print(response.body);
        Navigator.of(context).pop();

      } else {
                print(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('$error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error during request: '),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                    icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                obscureText: _hidePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hideConfirmPassword = !_hideConfirmPassword;
                      });
                    },
                    icon: Icon(_hideConfirmPassword ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                obscureText: _hideConfirmPassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password.';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _signupWithEmailAndPassword(
                      _nameController.text,
                      _emailController.text,
                      _passwordController.text,
                    );
                  }
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 20),
              // const Center(
              //   child: Text(
              //     '-------- or --------',
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //   ),
              // ),
              // const SizedBox(height: 20),
              // _googleSignInButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _googleSignInButton() {
  //   return Center(
  //     child: SizedBox(
  //       height: 50,
  //       child: SignInButton(
  //         Buttons.google,
  //         text: "Sign up with Google",
  //         onPressed: () {
  //           // Navigator.pushReplacement(
  //           //   context,
  //           //   MaterialPageRoute(builder: (context) => const HomePage558()),
  //           // );
  //         },
  //       ),
  //     ),
  //   );
  // }
}
