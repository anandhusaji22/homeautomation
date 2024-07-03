
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:homeautomated/firebasedata/selectdata.dart';
import 'package:homeautomated/merge/merge_copy.dart';

class Fetchdata555 extends StatefulWidget {
  @override
  _Fetchdata555State createState() => _Fetchdata555State();
}

class _Fetchdata555State extends State<Fetchdata555> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.reference().child('merge');
  Map<String, List<String>> dataMap = {}; // Map to store room names and corresponding switch names

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realtime Database Example'),
      ),
      body: Container(
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
               
                child: StreamBuilder(
                  stream: ref.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                      Map<dynamic, dynamic>? map = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
                      dataMap.clear(); // Clear the map before updating
                      map!.forEach((key, value) {
                        List<String> switches = [];
                        value.forEach((switchKey, _) {
                          switches.add(switchKey.toString());
                        });
                        dataMap[key.toString()] = switches;
                      });

                      return Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: ListView(
                          children: dataMap.entries.map((entry) {
                            String roomName = entry.key;
                           
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ElevatedButton(
                                onPressed: () {
                                  print('${entry.key}');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FirebaseDataScreen123654(selectedNodeKey: entry.key, selectednextnode: '123', destinationNodeName: 'merge',)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(52.5),
                                  ),
                                  primary: Color.fromARGB(66, 103, 102, 102),
                                  elevation: 0,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      roomName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                   
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
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
           Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => FirebaseDataScreen1234(selectedNodeKey: '123',)),
                      );
          // Add onPressed action for the floating action button
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
