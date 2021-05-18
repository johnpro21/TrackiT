import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;
  bool isSignedIn = false;
  String imageUrl;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    });
  }

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
        this.imageUrl = user.photoUrl;
      });
    }
    print("${user.displayName} is the user ${user.photoUrl}");
  }

  signout() async {
    _auth.signOut();
  }

  @override
  void initState() {
    //implement initState
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Color(0xff1967d2)),
          title: Text(
            'TrackiT',
            style: TextStyle(
              color: Color(0xff1967d2),
            ),
          ),
        ),
        body: Container(
          child: Center(
            child: !isSignedIn // setting isSignedIn to true
                ? CircularProgressIndicator()
                : Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 80),
                      ),
                    ],
                  ),
          ),
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.

          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: <Widget>[
                    Text(
                      'TrackiT',
                      style: TextStyle(fontSize: 16, color: Color(0xff1967d2)),
                    ),
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ClipOval(
                            child: CircleAvatar(
                              backgroundImage: user.photoUrl != null
                                  ? NetworkImage("${user.photoUrl}")
                                  : AssetImage('assets/user_icon.png'),
                              maxRadius: 40,
                              minRadius: 30,
                            ),
                          ),
                          Text(
                            user.displayName == null
                                ? user.email
                                : user.displayName,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
              ListTile(
                title: Text(
                  'Log out',
                  style: TextStyle(color: Color(0xff1967d2)),
                ),
                onTap: () async {
                  signout();
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ));
  }
}
