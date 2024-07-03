// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:homeautomated/screens/bill_estimation.dart';
import 'package:pie_chart/pie_chart.dart';

final DatabaseReference _database =
    FirebaseDatabase().reference().child('data/2020');

class TotalUsage extends StatefulWidget {
  static const routeName = '/total-usage';

  @override
  _TotalUsageState createState() => _TotalUsageState();
}

class _TotalUsageState extends State<TotalUsage> {
  var _totalDays = 0;
  var _totalTime = 0;
  var _totalAmount = 0.0;
  var _totalPower = 0.0;
  var _monthlyPower = 0.0;
  var _timeString;
  var _isLoading = false;
  var _chartType = true;
  Map<String, double> _monthMap = {};

  String monthName(var number) {
    String name = 'default';
    switch (number) {
      case '01':
        name = 'January';
        break;
      case '02':
        name = 'February';
        break;
      case '03':
        name = 'March';
        break;
      case '04':
        name = 'April';
        break;
      case '05':
        name = 'May';
        break;
      case '06':
        name = 'June';
        break;
      case '07':
        name = 'July';
        break;
      case '08':
        name = 'August';
        break;
      case '09':
        name = 'September';
        break;
      case '10':
        name = 'October';
        break;
      case '11':
        name = 'November';
        break;
      case '12':
        name = 'December';
        break;
    }
    return name;
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration >= Duration(seconds: 3600)) {
      return "${twoDigits(duration.inHours)} hour & $twoDigitMinutes minute";
    } else if (duration >= Duration(seconds: 60)) {
      return "$twoDigitMinutes minute & $twoDigitSeconds second";
    } else {
      return "$twoDigitSeconds seconds";
    }
  }

  void _getTotal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DataSnapshot snapshot = (await _database.once()) as DataSnapshot;
      var data = snapshot.value as Map<dynamic, dynamic>;

      _totalDays = 0;
      _totalTime = 0;
      _totalAmount = 0.0;
      _totalPower = 0.0;
      _monthlyPower = 0.0;
      _monthMap.clear();

      data.forEach((month, dates) {
        Map<dynamic, dynamic> dateData = dates;
        dateData.forEach((date, values) {
          _totalDays++;
          _totalAmount += values['amount'];
          _totalTime = _totalTime + (values['time'] as int);
          _totalPower += values['power'];
          _monthlyPower += values['power'];
        });
        _monthMap[monthName(month)] = _monthlyPower;
        _monthlyPower = 0.0;
      });

      _timeString = _printDuration(Duration(seconds: _totalTime));

      _monthMap.updateAll((key, value) {
        return double.parse(((value / _totalPower) * 100).toStringAsFixed(2));
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget createCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
            children: <TextSpan>[
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _getTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Usage'),
      ),
      body: _isLoading
          ? Center(
              child: SpinKitCircle(size: 60, color: Colors.lightBlue),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Power Usage Chart Month Wise',
                        style:TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 8,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _chartType = !_chartType;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: PieChart(
                            dataMap: _monthMap,
                            animationDuration: Duration(milliseconds: 2200),
                            chartType:
                                _chartType ? ChartType.disc : ChartType.ring,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        createCard('📆 Total Days : ', '$_totalDays days'),
                        createCard('📊 Total Power :',
                            '${_totalPower.toStringAsFixed(2)} Kwh'),
                        createCard('⏰  Total Time : ', _timeString),
                        createCard('💰 Total Amount :',
                            '${_totalAmount.toStringAsFixed(3)} ₹'),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          onPressed: () {
                            // Navigate to the Bill Estimation screen
                            Navigator.of(context)
                                .pushReplacementNamed(BillEstimation.routeName);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 60),
                            child: Text(
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
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
