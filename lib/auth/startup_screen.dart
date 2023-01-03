// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wave/auth/login.dart';
import 'package:wave/auth/sign_up.dart';
import 'package:wave/core/core_page.dart';
import 'package:wave/core/widgets/home/details.dart';

class StartUpScreen extends StatefulWidget {
  const StartUpScreen({Key? key}) : super(key: key);

  @override
  _StartUpScreenState createState() => _StartUpScreenState();
}

const images = [
  "assets/images/1am.png",
  "assets/images/archive.png",
  "assets/images/blush.png",
  "assets/images/coffee.png",
  "assets/images/drive.png",
  "assets/images/email.png",
  "assets/images/enora.png",
  "assets/images/garyvee.png",
  "assets/images/greek.png",
  "assets/images/heavyweight.png",
];

class _StartUpScreenState extends State<StartUpScreen> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        );
      }
    });

    AwesomeNotifications().createdStream.listen((notification) {
      /*  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Notification Created on ${notification.channelKey}',
        ),
      )); */
    });

    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Details(
            image: '${notification.payload!['image']}',
          ),
        ),
      );
    });
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print(dynamicLinkData.link.queryParameters.values.first);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Details(
            image: dynamicLinkData.link.queryParameters.values.first,
          ),
        ),
      );
      // Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/unfiltered.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          GridView.builder(
              itemCount: images.length,
              gridDelegate:

                  // crossAxisCount stands for number of columns you want for displaying
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                // return your grid widget here, like how your images will be displayed
                return Image.asset(
                  images[index],
                );
              }),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [
                  0.1,
                  0.4,
                  0.6,
                  0.9,
                ],
                colors: const [
                  Colors.black87,
                  Colors.black87,
                  Colors.black,
                  Colors.black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/svgs/Logo.svg',
                    height: 40,
                    width: 40,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'WAVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10,
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Text(
                  'Premium Podcasts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    'Relax and stream episodes from your favorite shows. Unlimited access to over 700,000 shows.',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 19,
                      fontWeight: FontWeight.w100,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 130,
                ),
                /* ElevatedButton(
                  child: SizedBox(
                      width: 320,
                      child: ListTile(
                        leading: SvgPicture.asset('assets/svgs/google.svg',
                            semanticsLabel: 'Google'),
                        title: Center(
                          child: Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        trailing: Container(
                          width: 10,
                        ),
                      )),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                    primary: Colors.white,
                    minimumSize: const Size(
                      310,
                      50,
                    ),
                  ),
                ), */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: ElevatedButton(
                    child: SizedBox(
                        width: 320,
                        child: ListTile(
                          title: Center(
                            child: Text(
                              'Welcome',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        )),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CorePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                      primary: Colors.blueAccent,
                      minimumSize: const Size(
                        310,
                        50,
                      ),
                    ),
                  ),
                ),
                /*  OutlinedButton(
                  child: Text(
                    "Login",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      width: 0.7,
                      color: Colors.transparent,
                    ),
                    minimumSize: const Size(
                      170,
                      45,
                    ),
                  ),
                ), */
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
