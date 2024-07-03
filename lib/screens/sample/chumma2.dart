// ignore_for_file: unused_import

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:http/http.dart' as http;

class FetchData66 extends StatefulWidget {
  final String textData; // Data from the previous screen

  FetchData66({required this.textData});

  @override
  _FetchData66State createState() => _FetchData66State();
}

class _FetchData66State extends State<FetchData66> {
  final ref = FirebaseDatabase.instance.reference().child('123');
  bool renaming = false;
  String? selectedLightCode;
  String? code4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(renaming ? 'Rename Light' : 'Realtime Database Example'),
        actions: [
          if (!renaming)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  renaming = true;
                });
              },
            ),
          if (renaming)
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                setState(() {
                  renaming = false;
                });
              },
            ),
        ],
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/background_image.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/back1.jpg"),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: FirebaseAnimatedList(
                  query: ref.orderByChild('room').equalTo(widget.textData),
                  itemBuilder: (context, snapshot, animation, index) {
                    if (snapshot.value != null) {
                      final room = snapshot.child('room').value.toString();

                      final name = snapshot.child('name').value.toString();
                      final status = snapshot.child('status').value.toString();
                      final code = snapshot.child('code').value.toString();
                      code4 = code;
                      final bool isLightOn =
                          status == 'true'; // Convert status to bool

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(66, 103, 102, 102),
                            borderRadius: BorderRadius.circular(52.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (!renaming) {
                                    _changeLightState(!isLightOn, '123', code);
                                  } else {
                                    setState(() {
                                      selectedLightCode = code;
                                    });
                                    _showRenameDialog(name, room);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: renaming && selectedLightCode == code
                                      ? const Icon(Icons.edit)
                                      : Text(
                                          name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                              if (!renaming || selectedLightCode != code)
                                Switch(
                                  value: isLightOn,
                                  onChanged: (value) {
                                    _changeLightState(value, '123',
                                        code); // Call function to change state
                                  },
                                  activeColor: Colors.yellow,
                                ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox(); // Return an empty widget if snapshot is null
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeLightState(bool value, String id, String code) async {
    final response = await http.get(
      Uri.https(
        'fxmtqpfni7o3kwciyrwdkykely0pvlnx.lambda-url.ap-south-1.on.aws',
        '/path/to/endpoint',
        {
          'type': 'action',
          'status': value.toString(),
          'id': id,
          'code': code,
        },
      ),
    );
    if (response.statusCode == 200) {
      print('Success');
    } else {
      print('Failed to change light state');
      // Handle errors, display error message, or retry option
    }
  }

  // Future<void> _showRenameDialog(String oldName) async {
  //   final TextEditingController _renameController = TextEditingController();
  //   _renameController.text = oldName;

  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Rename Light'),
  //         content: TextField(
  //           controller: _renameController,
  //           decoration: InputDecoration(
  //             hintText: 'Enter new name',
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               _renameLight(_renameController.text,context,widget.textData,'device');
  //               Navigator.pop(context);
  //             },
  //             child: Text('Rename'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  Future<void> _showRenameDialog(String oldName, String oldRoom) async {
    final TextEditingController _renameController = TextEditingController();
    final TextEditingController _roomController = TextEditingController();
    _renameController.text = oldName;
    _roomController.text = oldRoom;

    String selectedType = 'LIGHT'; // Default selected type

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Rename Device and Room'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _renameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter new device name',
                    ),
                  ),
                  TextField(
                    controller: _roomController,
                    decoration: const InputDecoration(
                      hintText: 'Enter new room name',
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: selectedType,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedType = newValue.toUpperCase();
                        });
                      }
                    },
                    items: <String>[
                      'LIGHT',
                      'FAN',
                      'AC_UNIT',
                      'OUTLET',
                      'SWITCH',
                      'TV'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _renameDeviceAndRoom(
                      _roomController.text,
                        _renameController.text,
                        
                        ("action.devices.types.s.$selectedType"),
                        oldRoom);
                    Navigator.pop(context);
                  },
                  child: const Text('Rename'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _renameDeviceAndRoom(
      String newName, String newRoom, String device, String oldRoom) async {
    Map<String, String> userData = {
      "room": newRoom,
      "name": newName,
      "device": device,
      "oldRoom": oldRoom,
      'code': code4!
    };

    String data = jsonEncode(userData);

    final uri = Uri.https(
      'fxmtqpfni7o3kwciyrwdkykely0pvlnx.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      {'type': 'rename', 'data': data, 'id': '123'},
    );

    try {
      final response = await http.get(uri);

      if (response.body == "success") {
                Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device and Room Name Changed Successfully'),
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

  void _renameLight(String newName, BuildContext context, String newroom,
      String device, String code) async {
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
}
