import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:homeautomated/firebasedata/displaydata.dart';
import 'package:homeautomated/firebasedata/master/master.dart';
import 'package:homeautomated/screens/sample/blue/bluetooth.dart';
import 'package:homeautomated/screens/sample/chumma.dart';
import 'package:homeautomated/widgets/main_drawer.dart';
import 'package:homeautomated/wiwfipass.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

enum _OptionsMenu {
  TermsCondition,
  AboutApp,
}

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProgressDialog? pr;

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(context);
    pr!.style(
      message: 'No internet ‼️\nPlease try again later',
      textAlign: TextAlign.center,
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    bool confirmExit = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: const Text('Do you want to exit the app?'),
          contentPadding: const EdgeInsets.all(20),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Stay in the app
              },
              child: const Text("NO"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Exit the app
              },
              child: const Text("YES"),
            ),
          ],
        );
      },
    );

    return confirmExit;
  }

  void _showDialogBox({
    String? title,
    String? message,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title ?? ''),
        content: Text(message ?? ''),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Home Automation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                'Hey friend, I developed a small project in which you can control your appliances. You may also try it by clicking on the download link:\n\nhttps://iottest-7498a.firebaseapp.com/download/Home%20Automation.apk',
              );
            },
          ),
          PopupMenuButton(
            onSelected: (_OptionsMenu selectedValue) {
              if (selectedValue == _OptionsMenu.TermsCondition) {
                _showDialogBox(
                  title: 'Terms & Conditions',
                  message:
                      '• Need an internet connection.\n\n• Need power to the circuitry.\n\n• You need to install Google Assistant to use voice control.\n\n• Must have a Wi-Fi connection nearby the circuit with the following credentials:\n\nSSID - internet\nPassword - 012356789',
                );
              } else {
                _showDialogBox(
                  title: 'About This Application',
                  message:
                      'This Application for Smart Homes typically allows users to control various aspects of smart homes devices such as light , fan and other connected appliances through smartphones. These App offers features like Scheduling, Remote access and integration with voice assistant',
                );
              }
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: _OptionsMenu.TermsCondition,
                child: Text('Terms & Conditions'),
              ),
              const PopupMenuItem(
                value: _OptionsMenu.AboutApp,
                child: Text('About This Application'),
              ),
            ],
          ),
        ],
      ),
      drawer: MainDrawer4(),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back1.jpg'), // Replace 'your_background_image_path.jpg' with your image path
              fit: BoxFit.cover,
            ),
          ),
        child: Column(
          children: [
            // Logo with reduced size
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Image.asset(
            //     'assets/images/bulb.gif', // Replace 'bulb.png' with your image path
            //     height: 100, // Adjust the height as needed
            //   ),
            // ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                    //         Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => FirebaseDataScreen(selectedNodeKey: '123',)),
                    // );
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>Fetchdata()),
                    );
                            // Action for Button 1
                            print('Button 1 pressed');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 70,
                                horizontal: 50), // Adjust padding for Button 1
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  52.5), // Adjust border radius as needed
                            ),
                            backgroundColor: const Color.fromARGB(225, 0, 0, 0)
                                .withOpacity(0.7), // Set color with opacity
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Add your icon here
                              Text(
                                'Controller',
                                style: TextStyle(
                                    color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold), // Text color
                              ),
                              SizedBox(
                                  height:
                                      10), // Adjust spacing between icon and text

                              Icon(Icons.add),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Action for Button 2
                            print('Schedule Switch');
                            Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WifiScreen(data: '123')),
                    );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 70,
                                horizontal: 50), // Adjust padding for Button 2
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  52.5), // Adjust border radius as needed
                            ),
                            backgroundColor: const Color.fromARGB(225, 0, 0, 0)
                                .withOpacity(0.7), // Set color with opacity
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Add your icon here
                              Text(
                                'ADD NEW DEVICE',
                                style: TextStyle(
                                    color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold), // Text color
                              ),
                              SizedBox(
                                  height:
                                      10), // Adjust spacing between icon and text

                              Icon(Icons.schedule_outlined),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                                Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FirebaseDataScreen12639(selectedNodeKey: 'dev1', selectednextnode: '123',)),
                    );
                            // Action for Button 3
                            print('Button 3 pressed');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 70,
                                horizontal: 49), // Adjust padding for Button 3
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  52.5), // Adjust border radius as needed
                            ),
                            backgroundColor: const Color.fromARGB(225, 0, 0, 0)
                                .withOpacity(0.7), // Set color with opacity
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Add your icon here
                              Text(
                                'Shortcuts',
                                style: TextStyle(
                                    color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold), // Text color
                              ),
                              SizedBox(
                                  height:
                                      10), // Adjust spacing between icon and text

                              Icon(Icons.star_border_outlined),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FirebaseDataScreen123(selectedNodeKey: 'master', selectedNextNode: '123',)),
                    );
                            // Action for Button 4
                            print('Button 4 pressed');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 70,
                                horizontal: 60), // Adjust padding for Button 4
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  52.5), // Adjust border radius as needed
                            ),
                            backgroundColor: const Color.fromARGB(225, 0, 0, 0)
                                .withOpacity(0.7), // Set color with opacity
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Add your icon here
                              Text(
                                'Master',
                                style: TextStyle(
                                    color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold), // Text color
                              ),
                              SizedBox(
                                  height:
                                      10), // Adjust spacing between icon and text

                              Icon(Icons.switch_access_shortcut),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                ),
                SizedBox(height: 60,),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal:20.0),
//                   child: ElevatedButton(
//                             onPressed: () {
//                                 Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => Fetchdata555()),
//                     );
//                               // Action for Button 4
//                               print('Button 4 pressed');
//                             },
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 20,
//                                   horizontal: 40), // Adjust padding for Button 4
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(
//                                     52.5), // Adjust border radius as needed
//                               ),
//                               backgroundColor: const Color.fromARGB(225, 0, 0, 0)
//                                   .withOpacity(0.7), // Set color with opacity
//                             ),
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 // Add your icon here
//                                 Text(
//                                   'Merge',
//                                   style: TextStyle(
//                                       color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold), // Text color
//                                 ),
//                                 SizedBox(
//                                     width:
//                                         10), // Adjust spacing between icon and text
                  
// Icon(Icons.merge_outlined, color: Colors.yellow),
//                               ],
//                             ),
//                           ),
//                 ),
                 Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                            onPressed: () {
                               Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>const FetchData667(  selectedNodeKey: '123', textData: '123',)),
                    );
                              // Action for Button 4
                              print('Button 4 pressed');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 40), // Adjust padding for Button 4
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    52.5), // Adjust border radius as needed
                              ),
                              backgroundColor: const Color.fromARGB(225, 0, 0, 0)
                                  .withOpacity(0.7), // Set color with opacity
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Add your icon here
                                Text(
                                  'Add',
                                  style: TextStyle(
                                      color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold), // Text color
                                ),
                                SizedBox(
                                    width:
                                        10), // Adjust spacing between icon and text
                  
Icon(Icons.add, color: Colors.yellow),
                              ],
                            ),
                          ),
                ),
              ],
            ),
            
            
          ],
        ),
      ),
    );
  }

  Future<void> _openGoogleAssistant() async {
    try {
      bool isInstalled = await DeviceApps.isAppInstalled(
        'com.google.android.apps.googleassistant',
      );
      if (isInstalled) {
        DeviceApps.openApp('com.google.android.apps.googleassistant');
      } else {
        String url =
            'https://play.google.com/store/apps/details?id=com.google.android.apps.googleassistant&hl=en';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
