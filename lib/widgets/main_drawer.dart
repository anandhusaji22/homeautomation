// Import necessary packages
// ignore_for_file: sized_box_for_whitespace, use_key_in_widget_constructors, unused_import

import 'package:flutter/material.dart';

import 'package:homeautomated/screens/change_key.dart';
import 'package:homeautomated/screens/home_screen.dart';
import 'package:homeautomated/screens/login_screen.dart';
import 'package:homeautomated/screens/power_usage.dart';
import 'package:homeautomated/screens/signup_screen.dart';

// Define a custom drawer widget for the main app navigation
class MainDrawer4 extends StatelessWidget {
  // Define a text style for drawer items
  final TextStyle itemStyle =
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header section with an image
          Container(
            height: 200,
            child: Image.asset(
              'assets/images/side_header.jpg',
              fit: BoxFit.fitHeight,
            ),
          ),
          // Drawer items with icons and text
          ListTile(
            leading: const Icon(
              Icons.verified_user_outlined,
              color: Colors.black87,
            ),
            title: Text('Add User', style: itemStyle),
            onTap: () {
              // Navigate to the HomeScreen when Home is selected
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupScreen()),
              );
            },
          ),
          const Divider(), // Add a divider between items
          ListTile(
            leading: const Icon(
              Icons.vpn_key,
              color: Colors.black87,
            ),
            title: Text(
              'Change password',
              style: itemStyle,
            ),
            onTap: () {
              // Navigate to the ChangeKey screen when Change Key is selected
              Navigator.of(context)
                  .pushReplacementNamed(ChangePasswordScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.av_timer,
              color: Colors.black87,
            ),
            title: Text(
              'Power Usage',
              style: itemStyle,
            ),
            onTap: () {
              // Navigate to the PowerUsage screen when Power Usage is selected
              Navigator.of(context).pushReplacementNamed(PowerUsage.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
            title: Text(
              'Logout',
              style: itemStyle,
            ),
            onTap: () {
              // Navigate to the LoginScreen when Logout is selected
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          ),
          const Divider(), // Add a divider at the end
        ],
      ),
    );
  }
}
