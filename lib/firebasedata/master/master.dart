import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:homeautomated/firebasedata/selectdata.dart';
import 'package:homeautomated/screens/firebase_renam.dart';
import 'package:http/http.dart' as http;

class FirebaseDataScreen123 extends StatefulWidget {
  static const routeName = '/firebase-data-screen';
  final String selectedNodeKey;
  final String selectedNextNode;

  const FirebaseDataScreen123({
    Key? key,
    required this.selectedNodeKey,
    required this.selectedNextNode,
  }) : super(key: key);

  @override
  _FirebaseDataScreen123State createState() => _FirebaseDataScreen123State();
}

class _FirebaseDataScreen123State extends State<FirebaseDataScreen123> {
  final DatabaseReference _ref = FirebaseDatabase.instance.reference();
  final List<String> _selectedSwitches = [];
  bool _isDeleteMode = false;
  bool _masterSwitchState = false;
  List<String> roomDataList = [];

  @override
  void initState() {
    super.initState();
    roomDataList = [];
  }

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
        SnackBar(
          content: Text('Nodes deleted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting nodes: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void toggleMasterSwitch(bool value) async {
    setState(() {
      _masterSwitchState = value;
      roomDataList.forEach((code) {
        print(code);
        print('success');
        _changeLightState(value, '123', code);
      });
    });
  }

  void toggleSwitch(String code) {
    setState(() {
      if (_selectedSwitches.contains(code)) {
        _selectedSwitches.remove(code);
      } else {
        _selectedSwitches.add(code);
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
                    builder: (context) => DatabaseRename(
                      selectedNodeKey: widget.selectedNodeKey,
                    ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Master Switch",
                  style: TextStyle(fontSize: 18),
                ),
                Switch(
                  value: _masterSwitchState,
                  onChanged: toggleMasterSwitch,
                ),
              ],
            ),
            Expanded(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                child: FirebaseAnimatedList(
                  key: ValueKey(widget.selectedNodeKey),
                  query: _ref.child(widget.selectedNodeKey),
                  itemBuilder: (context, snapshot, animation, index) {
                    if (snapshot.key != null && snapshot.value != null) {
                      final code = snapshot.key!;
                      final dynamic data = snapshot.value;

                      if (data is Map<dynamic, dynamic>) {
                        final String name = data['name'] ?? "Unknown";
                        final bool isSwitchOn = data['status'] ?? false;

                        roomDataList.add(code);

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
                                              _changeLightState(newValue, '123', code);
                                            });
                                          }).catchError((error) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Error updating node "$name": $error'),
                                                duration: Duration(seconds: 2),
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
                    builder: (context) =>  FirebaseDataScreen123654(
                      selectedNodeKey: widget.selectedNextNode,
                      destinationNodeName: widget.selectedNodeKey, selectednextnode: '',
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: deleteSelectedNodes,
              child: Icon(Icons.delete),
            ),
    );
  }
}
