
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:homeautomated/screens/seduling/seduliinglights.dart';

class Fetchdata5 extends StatefulWidget {
  @override
  _FetchdataState5 createState() => _FetchdataState5();
}

class _FetchdataState5 extends State<Fetchdata5> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.reference().child('123');
  Set<String> dataSet = {}; // Use Set to store unique values

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realtime Database Example'),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/background_image.jpg"), // Replace "assets/background_image.jpg" with your image path
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
                    image: AssetImage("assets/images/back1.jpg"), // Replace "assets/images/back1.jpg" with your image path
                    fit: BoxFit.cover,
                  ),
                  color: Colors.black.withOpacity(0.5), // Set background color with opacity
                  borderRadius: BorderRadius.circular(30.0), // Adjust border radius as needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5), // Set shadow color
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: StreamBuilder(
                  stream: ref.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                      Map<dynamic, dynamic>? map = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
                      dataSet.clear(); // Clear the set before updating
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
                          builder: (context) =>FetchData665(textData: roomValue,)),
                    );
                                  // Action for each button
                                  print(roomValue);
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
                      return Center(child: CircularProgressIndicator());
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
