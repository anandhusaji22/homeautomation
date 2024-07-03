import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:homeautomated/screens/firebase_renam.dart';

class FirebaseDataScreen extends StatefulWidget {
  static const routeName = '/firebase-data-screen';
  final String selectedNodeKey; // Add selectedNodeKey as a parameter
  const FirebaseDataScreen({Key? key, required this.selectedNodeKey})
      : super(key: key);

  @override
  _FirebaseDataScreenState createState() => _FirebaseDataScreenState();
}

class _FirebaseDataScreenState extends State<FirebaseDataScreen> {
  final auth=FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('123');


  Map<String, bool> switchStates = {}; // Store switch states

  @override
  void initState() {
    super.initState();
    // Fetch initial switch states from Firebase
    ref.child(widget.selectedNodeKey).onValue.listen((event) {
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
        if (data != null) {
          data.forEach((key, value) {
            final Map<dynamic, dynamic>? roomData = value;
            if (roomData != null) {
              roomData.forEach((roomKey, roomValue) {
                final Map<dynamic, dynamic>? nameData = roomValue;
                if (nameData != null) {
                  nameData.forEach((nameKey, isOn) {
                    switchStates[nameKey.toString()] = isOn == true;
                  });
                }
              });
            }
          });
        }
        setState(() {}); // Update UI with fetched switch states
      }
    });
  }

  void changeTitle(String oldTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController newTitleController =
            TextEditingController(text: oldTitle);
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
                ref.child(widget.selectedNodeKey).update({
                  newTitleController.text: {
                    'name': {
                      oldTitle: switchStates[oldTitle] ?? false,
                    }
                  },
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                          DatabaseRename(selectedNodeKey: widget.selectedNodeKey)),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem(
                  value: 'rename',
                  child: Text('Rename'),
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
                child: FirebaseAnimatedList(
                  query: ref.child(widget.selectedNodeKey),
                  itemBuilder: (context, snapshot, animation, index) {
                    if (snapshot.value != null) {
                      final Map<dynamic, dynamic>? data =
                          snapshot.value as Map<dynamic, dynamic>?;
                      if (data == null || data.isEmpty) {
                        return const ListTile(
                          title: Text("No Data"),
                        );
                      }
                      final List<String> keys =
                          data.keys.cast<String>().toList();

                      return Expanded(
                        child: ListView.builder(
                          itemCount: keys.length,
                          itemBuilder: (context, index) {
                            final String key = keys[index];
                            final Map<dynamic, dynamic>? roomData =
                                data[key] as Map<dynamic, dynamic>?;

                            if (roomData != null) {
                              final List<dynamic> roomKeys =
                                  roomData.keys.toList();

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: roomKeys.length,
                                itemBuilder: (context, index) {
                                  final String roomKey =
                                      roomKeys[index].toString();
                                  final bool isSwitchOn =
                                      switchStates.containsKey(roomKey)
                                          ? switchStates[roomKey]!
                                          : false;

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(17),
                                      ),
                                      child: ListTile(
                                        title: GestureDetector(
                                          child: Text(roomKey),
                                          onTap: () {
                                            changeTitle(roomKey);
                                          },
                                        ),
                                        trailing: Switch(
                                          value: isSwitchOn,
                                          onChanged: (newValue) {
                                            setState(() {
                                              switchStates[roomKey] = newValue;
                                            });
                                            ref
                                                .child(widget.selectedNodeKey)
                                                .update({
                                              key: {
                                                'name': {
                                                  roomKey: newValue,
                                                }
                                              }
                                            });
                                          },
                                        ),
                                        subtitle: isSwitchOn
                                            ? const Text("ON")
                                            : const Text("OFF"),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const ListTile(
                                title: Text("No Data"),
                              );
                            }
                          },
                        ),
                      );
                    } else {
                      return const ListTile(
                        title: Text("No Data"),
                      );
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
}
