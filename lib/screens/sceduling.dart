// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, avoid_print, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class DatabaseScheduling extends StatefulWidget {
  static const routeName = '/databasescheduling';

  @override
  _DatabaseSchedulingState createState() => _DatabaseSchedulingState();
}

class _DatabaseSchedulingState extends State<DatabaseScheduling> {
  final DatabaseReference ref = FirebaseDatabase.instance.reference();
  final String selectedNodeKey = "dev1";

  String selectedAction = "On"; // Default action is On
  TimeOfDay selectedTime = TimeOfDay.now();

  void editData(String oldTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController =
            TextEditingController(text: oldTitle);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Set Schedule"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Day"),
                  ),
                  Row(
                    children: [
                      Text("Time: ${selectedTime.format(context)}"),
                      TextButton(
                        onPressed: () {
                          showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          ).then((pickedTime) {
                            if (pickedTime != null) {
                              setState(() {
                                selectedTime = pickedTime;
                              });
                            }
                          });
                        },
                        child: const Text("Change Time"),
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: selectedAction,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAction = newValue!;
                      });
                    },
                    items: <String>['On', 'Off']
                        .map<DropdownMenuItem<String>>((String value) {
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
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Save Schedule"),
                  onPressed: () {
                    String day = titleController.text;
                    String time = selectedTime.format(context);
                    bool action = selectedAction == "On";

                    DatabaseReference selectedNodeRef =
                        ref.child(selectedNodeKey);
                    selectedNodeRef.update({
                      'day': day,
                      'time': time,
                      'action': action,
                    });

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Light Control"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: ref.child(selectedNodeKey),
              itemBuilder: (context, snapshot, animation, index) {
                if (snapshot.key != null && snapshot.value != null) {
                  final title = snapshot.key;

                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Text(title!),
                          onTap: () {
                            editData(title);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            editData(title);
                          },
                        ),
                      ],
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
        ],
      ),
    );
  }
}
