// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class DatabaseRename extends StatefulWidget {
  static const routeName = '/databaserenam'; // Update the route name

  final String selectedNodeKey; // Add selectedNodeKey as a parameter

  const DatabaseRename({Key? key, required this.selectedNodeKey})
      : super(key: key);

  @override
  _DatabaseRenameState createState() => _DatabaseRenameState();
}

class _DatabaseRenameState extends State<DatabaseRename> {
  final DatabaseReference ref = FirebaseDatabase.instance.reference();

  void editData(String oldTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController =
            TextEditingController(text: oldTitle);
        return AlertDialog(
          title: const Text("Edit Title"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
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
              child: const Text("Save"),
              onPressed: () {
                // Update the title in the database
                String newTitle = titleController.text;
                ref
                    .child(widget.selectedNodeKey) // Use widget.selectedNodeKey
                    .child(oldTitle)
                    .remove(); // Remove old title
                ref
                    .child(widget.selectedNodeKey) // Use widget.selectedNodeKey
                    .child(newTitle)
                    .set(true); // Set new title
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
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: ref.child(widget.selectedNodeKey), // Use widget.selectedNodeKey
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
                  // Handle null or missing data
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
