import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String phoneNum;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        setState(() {
          phoneNum = user.phoneNumber;
        });

        print(loggedInUser.phoneNumber);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.black,
        gradient: new LinearGradient(
          colors: [
            AppTheme.gradientColor1,
            AppTheme.gradientColor2,
            AppTheme.gradientColor3,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      // color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        child: Scaffold(
          // backgroundColor: AppTheme.nearlyWhite,
          body: SingleChildScrollView(
            child: Container(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    gradient: new LinearGradient(
                      colors: [
                        AppTheme.gradientColor1,
                        AppTheme.gradientColor2,
                        AppTheme.gradientColor3,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                            left: 16,
                            right: 16),
                        child: Image.asset('assets/images/person.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Your FeedBack',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: const Text(
                          'Give your best time for this moment.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // _buildComposer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Center(
                          child: Container(
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.btnColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      offset: const Offset(4, 4),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: FlatButton(
                                color: AppTheme.btnColor,
                                textColor: Colors.black,
                                disabledColor: Colors.grey,
                                disabledTextColor: Colors.black,
                                padding: EdgeInsets.all(8.0),
                                splashColor: Colors.blueAccent,
                                onPressed: () {},
                                child: Text(
                                  "Send Feedback",
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void customLaunch(command) async {
  //   if (await canLaunch(command)) {
  //     await launch(command);
  //   } else {
  //     print(' could not launch $command');
  //   }
  // }
}
