import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:homeautomated/screens/sample/blue/bluetooth.dart';

import 'package:http/http.dart' as http;

class BluetoothCheck extends StatefulWidget {
  final String data;
  final String ssid;
  final String password;

  const BluetoothCheck({
    required this.data,
    required this.ssid,
    required this.password,
  });

  @override
  _BluetoothCheckState createState() => _BluetoothCheckState();
}

class _BluetoothCheckState extends State<BluetoothCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Check'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'THE CONNECTION IS ESTABLISHED',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    
            Text('SSID: ${widget.ssid}'),
            Text('Password: ${widget.password}'),
            ElevatedButton(onPressed: (){_renameLight(widget.password, context, widget.ssid, widget.data);}, child: Text('connect'))
                  ],
                ),
              ),
           
          ],
        ),
      ),
    );
  }
  
  void _renameLight( String password,BuildContext context,
      String ssid,
      
      String code
     )
       async {
        Map<String, String> userData = {
    "password": password,
    "ssid": ssid,
    // 'code': code
    
  };

  String data = jsonEncode(userData);

  // Append query parameters directly to the URI
  final uri = Uri.https(
    'fxmtqpfni7o3kwciyrwdkykely0pvlnx.lambda-url.ap-south-1.on.aws',
    '/path/to/endpoint',
    {'type': 'bluetooth', 'data': data, 'id': '123'},
  );

  
    try {
      final response = await http.get(uri);

      if (response.body == "sucesses") {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('bluetooth connction successed  ssid and password succefully shared'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FetchData667( selectedNodeKey: '123', textData: '123',)),
            );
        print(response.body);
        // Navigator.of(context).pop();

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
}
