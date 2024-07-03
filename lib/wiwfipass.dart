import 'package:flutter/material.dart';
import 'package:homeautomated/bluetooth.dart'; // Corrected import path
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler package

class WifiScreen extends StatefulWidget {
  final String data;

  WifiScreen({required this.data});

  @override
  _WifiScreenState createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  List<WifiNetwork> wifiList = [];
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    // Check if location permission is granted
    PermissionStatus locationStatus = await Permission.location.status;
    if (locationStatus != PermissionStatus.granted) {
      // Request location permission
      await Permission.location.request();
    }

    // Check if Wi-Fi permission is granted
    PermissionStatus wifiStatus = await Permission.locationWhenInUse.status;
    if (wifiStatus != PermissionStatus.granted) {
      // Request Wi-Fi permission
      await Permission.locationWhenInUse.request();
    }

    // After getting permissions, load Wi-Fi list
    getWifiList();
  }

  Future<void> getWifiList() async {
    try {
      List<WifiNetwork> _wifiList = await WiFiForIoTPlugin.loadWifiList();
      setState(() {
        wifiList = _wifiList;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WIFI'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage('assets/images/back1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'WARNING CONTEXT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: const Text(
                  'sELECT YOUR wifi NETWORK AND ENTER THE USERNAME AND PASSWORD',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("List of WiFi Networks"),
                        content: Container(
                          width: double.minPositive,
                          height: 300,
                          child: ListView.builder(
                            itemCount: wifiList.length,
                            itemBuilder: (context, index) {
                              var network = wifiList[index];
                              return ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            const Text("Enter WiFi Password"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: passwordController,
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                labelText: 'Password',
                                                errorText: passwordController
                                                        .text.isEmpty
                                                    ? 'Password is required'
                                                    : null,
                                              ),
                                            ),
                                            TextField(
                                              controller:
                                                  confirmPasswordController,
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                labelText: 'Confirm Password',
                                                errorText: passwordController
                                                            .text !=
                                                        confirmPasswordController
                                                            .text
                                                    ? 'Passwords do not match'
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (passwordController
                                                      .text.isNotEmpty &&
                                                  passwordController.text ==
                                                      confirmPasswordController
                                                          .text) {
                                                // Handle password confirmation here
                                                print('SSID: ${network.ssid}');
                                                print(
                                                    'Password: ${passwordController.text}');
                                                Navigator.of(context).pop();
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BluetoothCheck(
                                                            data: widget.data,
                                                            ssid:
                                                                network.ssid ??
                                                                    'null',
                                                            password:
                                                                passwordController
                                                                    .text,
                                                          )),
                                                );
                                              }
                                            },
                                            child: const Text('Connect'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  primary: Colors.white,
                                  onPrimary: Colors.black,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(network.ssid ?? 'Unknown SSID',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                      Text('Signal Strength: ${network.level}',
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Show WiFi Networks'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
