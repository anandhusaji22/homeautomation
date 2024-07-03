// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, avoid_print, deprecated_member_use, prefer_typing_uninitialized_variables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:homeautomated/screens/bill_estimation.dart';
import 'package:homeautomated/screens/home_screen.dart';
import 'package:homeautomated/screens/total_usage.dart';
import 'package:homeautomated/widgets/main_drawer.dart';

import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

// Define the PowerUsage class as a StatefulWidget
class PowerUsage extends StatefulWidget {
  static const routeName = '/power-usage';

  @override
  _PowerUsageState createState() => _PowerUsageState();
}

// Define the state for the PowerUsage class
class _PowerUsageState extends State<PowerUsage> {
  ProgressDialog? pr;
  final DatabaseReference _database =
      FirebaseDatabase().reference().child('data');
  var isDataAvailable = false;
  String _displayDate =
      DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
  String _urlDate = DateFormat('yyyy/MM/dd').format(DateTime.now()).toString();
  var _power;
  var _time;
  var _amount;
  var _timeString;
  final TextStyle _titleStyle = const TextStyle(
      fontSize: 16, color: Colors.lightBlue, fontWeight: FontWeight.bold);
  final TextStyle _valueStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 24);
  final TextStyle _noValueStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Color.fromRGBO(255, 0, 0, 0.3));

  // Function to display a date picker dialog
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _displayDate = DateFormat('dd-MM-yyyy').format(pickedDate).toString();
          _urlDate = DateFormat('yyyy/MM/dd').format(pickedDate).toString();
        });
        print('display date : $_displayDate');
        print('url date : $_urlDate');
      },
    );
  }

  // Function to format a Duration object as a user-friendly string
  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration >= const Duration(seconds: 3600)) {
      return "${twoDigits(duration.inHours)} h : $twoDigitMinutes m";
    } else if (duration >= const Duration(seconds: 60)) {
      return "$twoDigitMinutes m : $twoDigitSeconds s";
    } else {
      return "$twoDigitSeconds seconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false, showLogs: false);
    pr!.style(
      message: 'No internet ‼️\nPlease try again later',
      textAlign: TextAlign.center,
    );
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Power Usage'),
        ),
        drawer: MainDrawer4(),
        body: StreamBuilder(
          stream: _database.child(_urlDate).onValue,
          builder: (context, snap) {
            if (snap.hasData && snap.data!.snapshot.value != null) {
              isDataAvailable = true;
              Map<dynamic, dynamic>? data =
                  (snap.data!.snapshot.value as Map<dynamic, dynamic>?) ?? {};

              _amount = data['amount'].toStringAsFixed(3);
              _power = data['power'].toStringAsFixed(2);
              _time = data['time'];
              _timeString = _printDuration(Duration(seconds: _time));
            } else {
              isDataAvailable = false;
              _amount = 0000;
              _power = 0000;
              _time = 000;
              _timeString = '0 seconds';
            }
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Power Usage Statistics',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          '- - - - - - - - - - - - - - - - - - - - - - ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      child: const Text(
                        '👉🏻  select a date for viewing data according to a particular date.',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                      ),
                      onPressed: _presentDatePicker,
                      child: Text(
                        _displayDate,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 8,
                            margin: const EdgeInsets.only(
                                top: 10, left: 10, bottom: 10, right: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Power',
                                    style: _titleStyle,
                                  ),
                                  const Divider(),
                                  Text(
                                    '$_power Kwh',
                                    style: isDataAvailable
                                        ? _valueStyle
                                        : _noValueStyle,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 8,
                            margin: const EdgeInsets.only(
                                top: 10, left: 5, bottom: 10, right: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Time',
                                    style: _titleStyle,
                                  ),
                                  const Divider(),
                                  Text(
                                    _timeString,
                                    style: isDataAvailable
                                        ? _valueStyle
                                        : _noValueStyle,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Card(
                      elevation: 8,
                      margin: const EdgeInsets.only(
                          top: 10, left: 80, bottom: 10, right: 80),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Amount',
                              style: _titleStyle,
                            ),
                            const Divider(),
                            Text(
                              '$_amount ₹',
                              style:
                                  isDataAvailable ? _valueStyle : _noValueStyle,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: isDataAvailable
                            ? const Text(
                                '',
                                style: TextStyle(fontSize: 20),
                              )
                            : const Text(
                                '⚠️ No data available for this date ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              )),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(BillEstimation.routeName);
                                },
                                child: const Text(
                                  'Bill Estimation',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(TotalUsage.routeName);
                                },
                                child: const Text(
                                  'Total Usage',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
