import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:homeautomated/screens/sample/chumma2.dart';

class Fetchdata extends StatefulWidget {
  @override
  _FetchdataState createState() => _FetchdataState();
}

class _FetchdataState extends State<Fetchdata> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.reference().child('123');
  Set<String> dataSet = {};

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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                      Map<dynamic, dynamic>? map = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
                      dataSet.clear();
                      map!.forEach((key, value) {
                        dataSet.add(value['room'].toString());
                      });

                      return Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: ListView(
                          children: dataSet.map((roomValue) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FetchData66(textData: roomValue),
                                    ),
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      roomValue,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.add, color: Colors.yellow),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    } else {
                      return Center(child: Text("No data available"));
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


