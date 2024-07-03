import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:http/http.dart' as http;

class FetchData665 extends StatefulWidget {
  final String textData; // Data from the previous screen

  FetchData665({required this.textData});

  @override
  _FetchData665State createState() => _FetchData665State();
}

class _FetchData665State extends State<FetchData665> {
  final ref = FirebaseDatabase.instance.reference().child('123');
  bool renaming = false;
  List<String> selectedLightCodes = [];
  String? code4;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedAction = 'on';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(renaming ? 'Rename Light' : 'Realtime Database Example'),
        actions: [
          if (!renaming)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  renaming = true;
                });
              },
            ),
          if (renaming)
            IconButton(
              icon: Icon(Icons.done),
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
                margin: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
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
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: FirebaseAnimatedList(
                  query: ref.orderByChild('room').equalTo(widget.textData),
                  itemBuilder: (context, snapshot, animation, index) {
                    if (snapshot.value != null) {
                      final room = snapshot.child('room').value.toString();
                      final name = snapshot.child('name').value.toString();
                      final code = snapshot.child('code').value.toString();
                      code4 = code;

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(66, 103, 102, 102),
                            borderRadius: BorderRadius.circular(52.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (!renaming) {
                                    setState(() {
                                      if (selectedLightCodes.contains(code)) {
                                        selectedLightCodes.remove(code);
                                      } else {
                                        selectedLightCodes.add(code);
                                      }
                                    });
                                  } else {
                                    _showRenameDialog(name, room);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: renaming
                                      ? Icon(Icons.edit)
                                      : Text(
                                          name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                              if (!renaming)
                                Checkbox(
                                  value: selectedLightCodes.contains(code),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null && value) {
                                        selectedLightCodes.add(code);
                                      } else {
                                        selectedLightCodes.remove(code);
                                      }
                                    });
                                  },
                                  checkColor: Colors.white,
                                  activeColor: Color.fromARGB(255, 238, 235, 235),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(); // Return an empty widget if snapshot is null
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSchedulingDialog();
        },
        child: Icon(Icons.schedule),
      ),
    );
  }

  Future<void> _showSchedulingDialog() async {
    selectedLightCodes = []; // Reset selected lights

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Schedule Lights'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Date'),
              SizedBox(height: 10),
              ListTile(
                title: Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                ),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedDate)
                    setState(() {
                      selectedDate = picked;
                    });
                },
              ),
              SizedBox(height: 10),
              Text('Select Time'),
              SizedBox(height: 10),
              ListTile(
                title: Text(
                  "${selectedTime.format(context)}",
                ),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null && picked != selectedTime)
                    setState(() {
                      selectedTime = picked;
                    });
                },
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Select Action'),
                trailing: DropdownButton<String>(
                  value: selectedAction,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAction = newValue!;
                    });
                  },
                  items: <String>['on', 'off'].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toUpperCase()),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {int epochTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    ).millisecondsSinceEpoch;
                print('date=$selectedDate,time=$selectedTime,action=$selectedAction,code=$code4,$epochTime,roomvalue=${widget.textData}');
                // _scheduleLights(selectedLightCodes);
                Navigator.pop(context);
              },
              child: Text('Schedule'),
            ),
          ],
        );
      },
    );
  }

  
  Future<void> _scheduleLights(
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
  

  Future<void> _showRenameDialog(String oldName, String oldRoom) async {
    final TextEditingController _renameController = TextEditingController();
    _renameController.text = oldName;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename Light'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _renameController,
                decoration: InputDecoration(
                  hintText: 'Enter new name',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _renameLight(_renameController.text, oldRoom);
                Navigator.pop(context);
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _renameLight(String newName, String oldRoom) async {
    // Implement renaming logic here
  }
}



