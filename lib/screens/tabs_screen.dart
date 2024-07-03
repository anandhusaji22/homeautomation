// Import necessary packages
// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:homeautomated/screens/bill_estimation.dart';
import 'package:homeautomated/screens/total_usage.dart';

// Define a StatefulWidget for the TabsScreen
class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

// Define the state for the TabsScreen
class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Define the number of tabs
      // initialIndex: 0, // Optional: Set the initial tab index
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meals'), // Title for the app bar
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Total Usage', // First tab with the text 'Total Usage'
              ),
              Tab(
                text:
                    'Bill Estimation', // Second tab with the text 'Bill Estimation'
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            TotalUsage(), // Display the TotalUsage screen in the first tab
            BillEstimation(), // Display the BillEstimation screen in the second tab
          ],
        ),
      ),
    );
  }
}
