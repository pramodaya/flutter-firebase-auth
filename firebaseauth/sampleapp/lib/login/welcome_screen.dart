import 'package:best_flutter_ui_templates/login/login_with_phone.dart';
import 'package:best_flutter_ui_templates/login/person_registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
import '../navigation_home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;
  bool showSpinner = false;

  @override
  void initState() {
    setState(() {
      showSpinner = true;
      print(showSpinner);
    });
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        final userProfile = await _firestore
            .collection('user_profile')
            .where("user_id", isEqualTo: loggedInUser.uid)
            .getDocuments();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        //save user data in to local storage
        var firstName = userProfile.documents[0].data['first_name'];
        var lastName = userProfile.documents[0].data['last_name'];
        var profileImg = userProfile.documents[0].data['profileImg'];

        prefs.setString('fistName', firstName);
        prefs.setString('lastName', lastName);
        prefs.setString('profileImg', profileImg);

        if (userProfile.documents.length > 0) {
          print(userProfile.documents.length);
        } else {
          print('no user exist');
        }

        //get salon data
        // final salonList =
        //     await _firestore.collection('test_salon').limit(2).getDocuments();

        // var query =
        //     _firestore.collection('user_profile').where("capital", "==");
        // for (var userProfile in userProfile.documents) {
        //   print(userProfile.data);
        // }

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
            (Route<dynamic> route) => false);
        setState(() {
          showSpinner = false;
        });
        print(loggedInUser.phoneNumber);
      } else {
        setState(() {
          showSpinner = false;
          print(showSpinner);
        });

        print('no user babe');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
        ),
        Scaffold(
          backgroundColor: Colors.orange[200],
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.50,
                      ),
                      Container(
                        child: Image.asset('assets/images/person.png'),
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  RaisedButton(
                    shape: StadiumBorder(),
                    color: Colors.orange[300],
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPhoneScreen.id);
                    },
                    child: const Text(
                      'SIGN IN / SIGN UP',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
