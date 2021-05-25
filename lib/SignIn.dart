import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackit_hosp/shared/constants.dart';
import 'package:trackit_hosp/shared/loading.dart';
import 'package:trackit_hosp/shared/loading_on_button.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  /* Intialize FirebaseAuth & GoogleSignIn and give an instance */

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /* Creating key to check FormState(status) */

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String _email, _passwaord;

  /* Checking whether the user is logged in or not when App starts */

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  /* Method for Navigation to Sign Up page (optional) */

  navigateToSignUpScreen() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  /* Whenever App starts/restarts i.e. a lifecylce finishes 
     and starts again following methods are executed   
  */

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  /* Method to check whether the user is signed in 
     after all the validation of form is done 
  */

  void signin() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      try {
        AuthResult user = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _passwaord,
        );
      } catch (e) {
        //print(e.message);
        showError(e.toString());
      }
    }
  }

  /* Showing the error message */

  void showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              child: Center(
                child: ListView(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 80),
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assets/frontlogo.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: <Widget>[
                                // E-mail TextField
                                Container(
                                  child: TextFormField(
                                    autofocus: false,
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white),
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Provide an email';
                                      }
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        hintText: 'E-mail'),
                                    onSaved: (input) => _email = input,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                // Password TextField
                                Container(
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white),
                                    obscureText: true,
                                    validator: (input) {
                                      if (input.length < 6) {
                                        return 'Password must be atleast 6 char long';
                                      }
                                    },
                                    decoration: textInputDecoration.copyWith(
                                        hintText: 'Password'),
                                    onSaved: (input) => _passwaord = input,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 40),
                                ),
                                //  Sign In button
                                RaisedButton(
                                    padding:
                                        EdgeInsets.fromLTRB(80, 15, 80, 15),
                                    color: Colors.pink[400],
                                    hoverColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    onPressed: signin,
                                    child: Text(
                                      'Log In',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                ),

                                SizedBox(
                                  height: 15,
                                ),
                                TextButton(
                                  onPressed: () async {
                                    navigateToSignUpScreen();
                                    setState(() => loading = true);
                                  },
                                  child: Text(
                                    'Create an account',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
