// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:homeautomated/screens/firebase_renam.dart';
import 'package:homeautomated/screens/login_screen.dart';
import 'package:http/http.dart' as http;

class FetchData667 extends StatefulWidget {
  static const routeName = '/firebase-data-screen';
  final String selectedNodeKey;
  

  const FetchData667(
      {Key? key, required this.selectedNodeKey, required String textData })
      : super(key: key);

  @override
  _FetchData667State createState() => _FetchData667State();
}

class _FetchData667State extends State<FetchData667> {
  final DatabaseReference _ref = FirebaseDatabase.instance.reference();
  // final List<String> _selectedNodesToDelete = [];
  final List<String> _selectedSwitches = [];
  bool _isDeleteMode = false;

  // void changeTitle(String? oldTitle) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       TextEditingController newTitleController =
  //           TextEditingController(text: oldTitle ?? '');
  //       return AlertDialog(
  //         title: const Text("Change Title"),
  //         content: TextField(
  //           controller: newTitleController,
  //           decoration: const InputDecoration(labelText: "New Title"),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text("Cancel"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text("Save"),
  //             onPressed: () {
  //               _ref
  //                   .child(widget.selectedNodeKey)
  //                   .update({newTitleController.text: newTitleController.text});
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  
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
  //












//























Future<void> _showRenameDialog(String oldName, String oldRoom,String code) async {
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
                        ("action.devices.types.$selectedType"),
                        oldRoom,code);
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
      String newName, String newRoom, String device, String oldRoom,String code) async {
    Map<String, String> userData = {
      "room": newRoom,
      "name": newName,
      "device": device,
      "oldRoom": oldRoom,
      "code": code
      
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
































//

  Future<void> deleteSelectedNodes() async {
    try {
      for (String nodeKey in _selectedSwitches) {
        await _ref.child(widget.selectedNodeKey).child(nodeKey).remove();
      }
      _selectedSwitches.clear();
      setState(() {
        _isDeleteMode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nodes deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting nodes: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void toggleSwitch(String title) {
    setState(() {
      if (_selectedSwitches.contains(title)) {
        _selectedSwitches.remove(title);
      } else {
        _selectedSwitches.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Light Control"),
        actions: [
          PopupMenuButton(
            onSelected: (String choice) {
              if (choice == 'rename') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DatabaseRename(selectedNodeKey: widget.selectedNodeKey),
                  ),
                );
              } else if (choice == 'delete') {
                setState(() {
                  _isDeleteMode = true;
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem(
                  value: 'rename',
                  child: Text('Rename'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),





                ///
                ///
                ///
                ///
                ///
                ///
                ///
               child: FirebaseAnimatedList(
  query: _ref.child(widget.selectedNodeKey),
  itemBuilder: (context, snapshot, animation, index) {
    if (snapshot.key != null && snapshot.value != null) {
      final code = snapshot.key!;
      final dynamic data = snapshot.value;

      if (data is Map<dynamic, dynamic>) {
        final String name = data['name'] ?? "Unknown";
        final String room = data['room'] ?? "Unknown";
                final String codea = data['code'] ?? "Unknown";

        final bool isSwitchOn = data['status'];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isDeleteMode)
                    GestureDetector(
                      onTap: () {
                        toggleSwitch(code);
                      },
                      child: Row(
                        children: [
                          Text(name),
                          Checkbox(
                            value: _selectedSwitches.contains(code),
                            onChanged: (value) {
                              toggleSwitch(code);
                            },
                          ),
                        ],
                      ),
                    ),
                  if (!_isDeleteMode)
                    GestureDetector(
                      onTap: () {
                        _showRenameDialog(name, room,codea);
                      },
                      child: Text(name),
                    ),
                  if (!_isDeleteMode)
                    Switch(
                      value: isSwitchOn,
                      onChanged: (newValue) {
                        _ref
                            .child(widget.selectedNodeKey)
                            .child(code)
                            .update({'status': newValue}).then(
                                (_) {
                              setState(() {
                                data['status'] = newValue;
                                              _changeLightState(newValue,'123',code); // Call the function here

                              });
                            }).catchError((error) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error updating node "$name": $error'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            });
                      },
                    ),
                ],
              ),
              subtitle: isSwitchOn
                  ? const Text("ON")
                  : const Text("OFF"),
            ),
          ),
        );
      } else if (data is bool) {
        final String name = "Unknown";
        final String room = "Unknown";
        bool isSwitchOn = data;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isDeleteMode)
                    GestureDetector(
                      onTap: () {
                        toggleSwitch(code);
                      },
                      child: Row(
                        children: [
                          Text(name),
                          Checkbox(
                            value: _selectedSwitches.contains(code),
                            onChanged: (value) {
                              toggleSwitch(code);
                            },
                          ),
                        ],
                      ),
                    ),
                  if (!_isDeleteMode)
                    GestureDetector(
                      onTap: () {
                       _showRenameDialog(name, room,code);
                      },
                      child: Text(name),
                    ),
                  if (!_isDeleteMode)
                    Switch(
                      value: isSwitchOn,
                      onChanged: (newValue) {
                        _ref
                            .child(widget.selectedNodeKey)
                            .child(code)
                            .set(newValue).then(
                                (_) {
                              setState(() {
                                isSwitchOn = newValue;
                              });
                            }).catchError((error) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error updating node "$code": $error'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            });
                      },
                    ),
                ],
              ),
              subtitle: isSwitchOn
                  ? const Text("ON")
                  : const Text("OFF"),
            ),
          ),
        );
      }
    }

    return const ListTile(
      title: Text("No Data"),
    );
  },
),











///
///
///
///
///
///

              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !_isDeleteMode
      
      
          ? Row(  mainAxisAlignment: MainAxisAlignment.center,

            children: [
              ElevatedButton(onPressed: (){showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Are you sure?"),
                      content: Text("This action cannot be undone."),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                           
                          },
                          child: Text("Yes"),
                        ),
                      ],
                    );
                  },
                );




              }, child: Text("NEXT",style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),)),
            ],
          )
          : FloatingActionButton(
              onPressed: deleteSelectedNodes,
              child: const Icon(Icons.delete),
            ),
    );
  }
}
