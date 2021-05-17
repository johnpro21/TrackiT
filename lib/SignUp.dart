import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackit/shared/constants.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String _name, _email, _password;

  checkAuthincation() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  navigateToSignInScreen() {
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.checkAuthincation();
  }

  signup() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();

      try {
        AuthResult user = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        if (user != null) {
          UserUpdateInfo userUpdateInfo = UserUpdateInfo();
          userUpdateInfo.displayName = _name;
          user.user.updateProfile(userUpdateInfo);
        }
      } catch (e) {
        showError(e);
      }
    }
  }

  showError(String errormessage) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text('Sign Up'),
//      ),
      body: Container(
        child: Center(
          child: ListView(
            children: <Widget>[
              Column(
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
//                        Name box
                          Container(
                            child: TextFormField(
                              //maxLength: 30,
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Provide an name';
                                }
                              },
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Name'),
                              onSaved: (input) => _name = input,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
//                      email
                          Container(
                            child: TextFormField(
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
                          Container(
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
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
                              onSaved: (input) => _password = input,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          SizedBox(height: 15),
//                    button
                          RaisedButton(
                              padding: EdgeInsets.fromLTRB(80, 15, 80, 15),
                              color: Colors.pink[400],
                              hoverColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              onPressed: signup,
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
//                      redirect to signup page
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: navigateToSignInScreen,
                            child: Text(
                              'Already have an account? Login here',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16.0, color: Colors.blue),
                            ),
                          )
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
