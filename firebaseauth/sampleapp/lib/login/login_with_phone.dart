import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:best_flutter_ui_templates/login/person_registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:best_flutter_ui_templates/help_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';
import '../navigation_home_screen.dart';

class LoginPhoneScreen extends StatefulWidget {
  static const String id = 'login_phone_screen';

  @override
  _LoginPhoneScreenState createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final _firestore = Firestore.instance;

  final _phoneContrller = TextEditingController();
  final _codeController = TextEditingController();

  void returnErrorMsg(String errorMsg) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          child: AlertDialog(
            title: Text('Error'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$errorMsg',
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                textColor: Colors.black,
                color: AppTheme.btnColor,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> loginUser(String phone, BuildContext context) async {
    final _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = result.user;
          if (user != null) {
            // Navigator.pushReplacementNamed(context, LoginPhoneScreen.id);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => HelpScreen(user: user);
            //   ),
            // );

            //if user is a new user -> show the prson-registration page
            final userProfile = await _firestore
                .collection('user_profile')
                .where("user_id", isEqualTo: user.uid)
                .getDocuments();

            SharedPreferences prefs = await SharedPreferences.getInstance();
            //save user data in to local storage
            var firstName = userProfile.documents[0].data['first_name'];
            var lastName = userProfile.documents[0].data['last_name'];
            var nic = userProfile.documents[0].data['nic'];

            prefs.setString('fistName', firstName);
            prefs.setString('lastName', lastName);
            prefs.setString('nic', nic);

            var phonenum = user.phoneNumber;
            print('user automatically registerd: $phonenum');

            if (userProfile.documents.length > 0) {
              if (userProfile.documents[0].data['userType'] == 'customer') {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => NavigationHomeScreen()),
                    (Route<dynamic> route) => false);
              } else {
                //ur not a customer - cant create 2 accounts by same mobile number
                returnErrorMsg('You\'re already registered with this number');
              }
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => PersonRegistration()),
                  (Route<dynamic> route) => false);
            }

            //else just pass to the home page

            //Navigator.pushNamed(context, PersonRegistration.id);

          } else {
            print('auto error');
          }
          //this callback gets called when verification is done automatically
        },
        verificationFailed: (AuthException exception) {
          returnErrorMsg('Mobile Verification Error... Try Again...');
        },
        codeSent: (String verificationId, [int forceResendtionToken]) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Container(
                child: AlertDialog(
                  title: Text('Enter the code'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        textAlign: TextAlign.center,
                        controller: _codeController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Text is empty';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    //cancel button
                    FlatButton(
                      child: Text('Cancel'),
                      textColor: Colors.black,
                      color: AppTheme.btnColor,
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Confirm'),
                      textColor: Colors.black,
                      color: AppTheme.btnColor,
                      onPressed: () async {
                        try {
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.getCredential(
                            verificationId: verificationId,
                            smsCode: code,
                          );

                          AuthResult result =
                              await _auth.signInWithCredential(credential);

                          FirebaseUser user = result.user;

                          if (user != null) {
                            // Navigator.of(context).pop();
                            final userProfile = await _firestore
                                .collection('user_profile')
                                .where("user_id", isEqualTo: user.uid)
                                .getDocuments();

                            // var phonenum = user.phoneNumber;
                            // print('user manually registerd: $phonenum');

                            if (userProfile.documents.length > 0) {
                              if (userProfile.documents[0].data['userType'] ==
                                  'customer') {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                //save user data in to local storage
                                var firstName =
                                    userProfile.documents[0].data['first_name'];
                                var lastName =
                                    userProfile.documents[0].data['last_name'];
                                var nic = userProfile.documents[0].data['nic'];

                                prefs.setString('fistName', firstName);
                                prefs.setString('lastName', lastName);
                                prefs.setString('nic', nic);

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NavigationHomeScreen()),
                                    (Route<dynamic> route) => false);
                              } else {
                                //ur not a customer - cant create 2 accounts by same mobile number
                                returnErrorMsg(
                                    'You\'re already registered with this number');
                              }
                            } else {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PersonRegistration()),
                                  (Route<dynamic> route) => false);
                            }
                          } else {
                            returnErrorMsg(
                                'something is wrong... Try Again...');
                          }
                        } catch (e) {}
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        codeAutoRetrievalTimeout: null);
  }

  //FirebaseUser loggedInUser;
  String mobileNumber;

  @override
  void initState() {
    super.initState();
    //getCurrentUser();
    getData();
  }

  // void getCurrentUser() async {
  //   try {
  //     final user = await _auth.currentUser();
  //     if (user != null) {
  //       loggedInUser = user;
  //       print(loggedInUser.email);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void getData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Register Mobile Number'),
      //   backgroundColor: Colors.pinkAccent,
      // ),
      backgroundColor: Colors.white,
      body: Container(
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
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 235.0,
                ),
                Container(
                  child: Image.asset('assets/images/person.png'),
                  height: 120.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _phoneContrller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    // password = value;
                  },
                  validator: (value) {
                    Pattern pattern = r'^(\+\d{1,3}[- ]?)?\d{10}$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(value))
                      return 'Enter Valid Number';
                    else
                      return null;

                    // if (value.isEmpty) {
                    //   return 'Please enter some text';
                    // }
                    // return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your mobile number.',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.btnColor, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.btnColor, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: AppTheme.btnColor,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () {
                        try {
                          // final user = await _auth.signInWithEmailAndPassword(
                          //   email: email,
                          //   password: password,
                          // );
                          // if (user != null) {
                          //   // return NavigationHomeScreen();
                          //   // Navigator.pushNamed(context, NavigationHomeScreen.id);
                          //   Navigator.pushReplacementNamed(
                          //       context, NavigationHomeScreen.id);
                          // }

                          if (_formKey.currentState.validate()) {
                            print('validated');
                            final phone = _phoneContrller.text.trim();
                            loginUser(phone, context);
                          }
                          // print('clicked me');

                        } catch (e) {
                          print(e);
                        }
                      },
                      minWidth: double.infinity,
                      height: 42.0,
                      child: Text(
                        'Continue',
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 16.0),
                //   child: Material(
                //     color: Colors.pinkAccent,
                //     borderRadius: BorderRadius.all(Radius.circular(30.0)),
                //     elevation: 5.0,
                //     child: MaterialButton(
                //       onPressed: () async {
                //         FirebaseAuth.instance.signOut();
                //       },
                //       minWidth: double.infinity,
                //       height: 42.0,
                //       child: Text(
                //         'Log Out',
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 300.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
