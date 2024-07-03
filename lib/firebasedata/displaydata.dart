// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:homeautomated/firebasedata/selectdata.dart';
import 'package:homeautomated/screens/firebase_renam.dart';
import 'package:http/http.dart' as http;

class FirebaseDataScreen12639 extends StatefulWidget {
  static const routeName = '/firebase-data-screen';
  final String selectedNodeKey;
  final String selectednextnode;

  const FirebaseDataScreen12639(
      {Key? key, required this.selectedNodeKey, required this.selectednextnode})
      : super(key: key);

  @override
  _FirebaseDataScreen12639State createState() => _FirebaseDataScreen12639State();
}

class _FirebaseDataScreen12639State extends State<FirebaseDataScreen12639> {
  final DatabaseReference _ref = FirebaseDatabase.instance.reference();
  // final List<String> _selectedNodesToDelete = [];
  final List<String> _selectedSwitches = [];
  bool _isDeleteMode = false;

  void changeTitle(String? oldTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController newTitleController =
            TextEditingController(text: oldTitle ?? '');
        return AlertDialog(
          title: const Text("Change Title"),
          content: TextField(
            controller: newTitleController,
            decoration: const InputDecoration(labelText: "New Title"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                _ref
                    .child(widget.selectedNodeKey)
                    .update({newTitleController.text: newTitleController.text});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
        // final String room = data['room'] ?? "Unknown";
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
                        changeTitle(name);
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
        // final String room = "Unknown";
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
                        changeTitle(name);
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
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FirebaseDataScreen123654(
                      selectedNodeKey: widget.selectednextnode,
                      destinationNodeName: widget.selectedNodeKey, selectednextnode: '',
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: deleteSelectedNodes,
              child: const Icon(Icons.delete),
            ),
    );
  }
}
