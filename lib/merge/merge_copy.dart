import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class FirebaseDataScreen1234 extends StatefulWidget {
  static const routeName = '/firebase-data-screen';
  final String selectedNodeKey;

  const FirebaseDataScreen1234({
    Key? key,
    required this.selectedNodeKey,
  }) : super(key: key);

  @override
  _FirebaseDataScreen1234State createState() => _FirebaseDataScreen1234State();
}

class _FirebaseDataScreen1234State extends State<FirebaseDataScreen1234> {
  final DatabaseReference ref = FirebaseDatabase.instance.reference();
  final List<String> selectedSwitches = [];

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
                ref
                    .child(widget.selectedNodeKey)
                    .update({newTitleController.text: oldTitle});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void toggleSwitch(String title) {
    setState(() {
      if (selectedSwitches.contains(title)) {
        selectedSwitches.remove(title);
      } else {
        selectedSwitches.add(title);
      }
    });
  }

  void copySelectedSwitches(String newNodeName) {
    if (selectedSwitches.isNotEmpty && newNodeName.isNotEmpty) {
      Map<String, dynamic> dataToCopy = {};
      for (String title in selectedSwitches) {
        ref
            .child(widget.selectedNodeKey)
            .child(title)
            .once()
            .then((snapshot) {
          if (snapshot.snapshot.value != null) {
            dataToCopy[title] = snapshot.snapshot.value;
          }
          if (dataToCopy.length == selectedSwitches.length) {
            ref
                .child('merge') // Copy to 'merge' node
                .child(newNodeName) // Use the provided newNodeName
                .update(dataToCopy)
                .then((_) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Switches copied successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error copying switches: $error'),
                  duration: Duration(seconds: 2),
                ),
              );
            });
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select switches and enter a node name'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void showNewNodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController newNodeController = TextEditingController();
        return AlertDialog(
          title: const Text("Create New Node"),
          content: TextField(
            controller: newNodeController,
            decoration: const InputDecoration(labelText: "Node Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Create"),
              onPressed: () {
                String newNodeName = newNodeController.text;
                if (newNodeName.isNotEmpty) {
                  copySelectedSwitches(newNodeName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid node name'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
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
          IconButton(
            icon: Icon(Icons.create),
            onPressed: () {
              showNewNodeDialog();
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
                    if (snapshot.key != null && snapshot.value != null) {
                      final code = snapshot.key!;
                      final dynamic value = snapshot.value;

                      if (value is Map<dynamic, dynamic>) {
                        final String name = value['name'] ?? "Unknown";
                        // final String room = value['room'] ?? "Unknown";
                        final bool isSwitchOn = value['status'] ?? false;

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
                                  GestureDetector(
                                    onTap: () {
                                      changeTitle(name);
                                    },
                                    child: Text(name),
                                  ),
                                  Checkbox(
                                    value: selectedSwitches.contains(code),
                                    onChanged: (value) {
                                      toggleSwitch(code);
                                    },
                                  ),
                                ],
                              ),
                              subtitle: isSwitchOn ? const Text("ON") : const Text("OFF"),
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
    );
  }
}
