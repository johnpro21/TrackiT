import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:trackit_hosp/shared/constants.dart';
import 'package:trackit_hosp/shared/loading.dart';
import 'package:trackit_hosp/shared/loading_on_button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final _reqkey = GlobalKey<FormState>();
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;
String mainselctDist = "Select District";
String desc, qty, usrPhno;
List<String> reqList = ["Tifin", "Medicine", "Oxygen", "Ambulance", "Blood"];
List<String> distlst = [
  "Thiruvananthapuram",
  "Kollam",
  "Alappuzha",
  "Pathanamthitta",
  "Kottayam",
  "Idukki",
  "Ernakulam",
  "Thrissur",
  "Palakkad",
  "Malappuram",
  "Kozhikode",
  "Wayanadu",
  "Kannur",
  "Kasaragod",
];
Map distno = {
  "Thiruvananthapuram": "1001",
  "Kollam": "1002",
  "Alappuzha": "1003",
  "Pathanamthitta": "1004",
  "Kottayam": "1005",
  "Idukki": "1006",
  "Ernakulam": "1007",
  "Thrissur": "1008",
  "Palakkad": "1009",
  "Malappuram": "1010",
  "Kozhikode": "1011",
  "Wayanadu": "1012",
  "Kannur": "1013",
  "Kasaragod": "1014",
};

class _HomePageState extends State<HomePage> {
//  final FirebaseAuth _auth = FirebaseAuth.instance;
  String hselctDist;
  bool isSignedIn = false;
  String imageUrl, phno;
  final reqkey = GlobalKey<FormState>();

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
        user = firebaseUser;
        this.isSignedIn = true;
        this.imageUrl = user.photoUrl;
        this.phno = user.phoneNumber;
      });
    }
  }

  void _showDialog() {
    var themeData = Theme.of(context);
    slideDialog.showSlideDialog(
      context: context,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        //controller: controller,
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please Select your District",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  value: hselctDist,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: themeData.backgroundColor,
                    labelText: 'District',
                    border: textInputDecoration.border,
                  ),
                  items: distlst.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (input) => hselctDist = input,
                ),
                TextButton(
                  child: Text("Save"),
                  onPressed: () {
                    setState(() {
                      mainselctDist = hselctDist;
                    });

                    print(mainselctDist);
                    Navigator.pop(context);
                  },
                )
              ]),
        ),
      ),
    );
  }

  signout() async {
    _auth.signOut();
  }

  void del_req() {}

  @override
  void initState() {
    //implement initState
    super.initState();
    this.checkAuthentication();
    this.getUser();
    Timer.run(() => _showDialog());
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return !isSignedIn // setting isSignedIn to true
        ? Loading()
        : Scaffold(
            body: DefaultTabController(
              length: 2,
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("user")
                      .document(user.uid)
                      .collection("mydata")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return Loading();

                    DocumentSnapshot data = snapshot.data.documents[0];
                    usrPhno = data['phone_no'];
                    print(usrPhno);
                    return NestedScrollView(
                      headerSliverBuilder: (context, value) {
                        return [
                          SliverAppBar(
                            floating: true,
                            pinned: true,
                            //centerTitle: true,
                            iconTheme:
                                new IconThemeData(color: Color(0xff1967d2)),
                            title: Text(
                              'TrackiT Hospital',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xff1967d2)),
                            ),
                            actions: <Widget>[
                              FlatButton.icon(
                                  onPressed: () {
                                    _showDialog();
                                  },
                                  icon: Icon(Icons.place,
                                      color: Color(0xff1967d2)),
                                  label: Text(
                                    "$mainselctDist",
                                    style: TextStyle(fontSize: 9),
                                  )),
                            ],
                            backgroundColor: themeData.appBarTheme.color,
                            bottom: TabBar(
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.w700),
                              indicatorSize: TabBarIndicatorSize.label,
                              labelColor: Color(0xff1967d2),
                              unselectedLabelColor: Color(0xff5f6368),
                              isScrollable: true,
                              indicator: MD2Indicator(
                                  indicatorHeight: 2,
                                  indicatorColor: Color(0xff1967d2),
                                  indicatorSize: MD2IndicatorSize.normal),
                              tabs: <Widget>[
                                Tab(
                                  text: "My Requirements",
                                ),
                                Tab(
                                  text: "Requirments Near",
                                ),
                              ],
                            ),
                          )
                        ];
                      },
                      body: TabBarView(
                        children: [
                          Container(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection("reqlist")
                                  .document(distno[mainselctDist])
                                  .collection(mainselctDist)
                                  .where(
                                    'user_uid',
                                    isEqualTo: user.uid,
                                  )
                                  .snapshots(),
                              builder: (context, snapshot) {
                                bool mydata = snapshot.hasData;
                                return !mydata
                                    ? Center(
                                        child: Container(
                                            child: Text("No Requirements")))
                                    : ListView.builder(
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot data =
                                              snapshot.data.documents[index];
                                          for (var i
                                              in snapshot.data.documents) {
                                            if (i.data["user_uid"] == user.uid)
                                              var docId = i.documentID;
                                          }
                                          String dsp, qnty;
                                          dsp = data['description'];
                                          qnty = data['quantity'];
                                          return Container(
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              bottom: 4.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            data['reqname'],
                                                            style:
                                                                new TextStyle(
                                                                    fontSize:
                                                                        25.0),
                                                          ),
                                                          Spacer(),
                                                          IconButton(
                                                              icon: Icon(Icons
                                                                  .delete_forever),
                                                              onPressed: () {
                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        "reqlist")
                                                                    .document(
                                                                        distno[
                                                                            mainselctDist])
                                                                    .collection(
                                                                        mainselctDist)
                                                                    .document(data
                                                                        .documentID)
                                                                    .delete();
                                                              })
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0,
                                                              bottom: 15.0),
                                                      child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                                "$dsp - $qnty"),
                                                            Spacer(),
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                              },
                            ),
                          ),
                          Container(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection("reqlist")
                                  .document(distno[mainselctDist])
                                  .collection(mainselctDist)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                bool mydata = snapshot.hasData;
                                return !mydata
                                    ? Center(
                                        child: Container(
                                            child: Text("No Requirements")))
                                    : ListView.builder(
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot data =
                                              snapshot.data.documents[index];
                                          String dsp, qnty, rphno;
                                          dsp = data['description'];
                                          qnty = data['quantity'];
                                          rphno = data['reqstnt_phno'];
                                          return Container(
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              bottom: 4.0),
                                                      child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              data['reqname'],
                                                              style:
                                                                  new TextStyle(
                                                                      fontSize:
                                                                          25.0),
                                                            ),
                                                            Spacer(),
                                                          ]),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0,
                                                              bottom: 15.0),
                                                      child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                                "$dsp - $qnty"),
                                                            Spacer(),
                                                          ]),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              bottom: 8.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            data[
                                                                'reqstnt_name'],
                                                            style:
                                                                new TextStyle(
                                                                    fontSize:
                                                                        15.0),
                                                          ),
                                                          Spacer(),
                                                          IconButton(
                                                            onPressed: () => launch(
                                                                "tel://$rphno"),
                                                            icon: Icon(
                                                                Icons.call),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                          // ListTile(
                                          //   title: Text(data['reqstnt_name']),
                                          //   subtitle: Text(data['description']),
                                          // );
                                        },
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddReq()),
                );
              },
              label: Text(
                'Add Requirment',
                style: TextStyle(color: Colors.red),
              ),
              icon: Icon(Icons.add, color: Colors.red),
              backgroundColor: Color(0xff1967d2),
            ),
            drawer: Drawer(
              child: user == null
                  ? LoadingSmall()
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          child: user == null
                              ? LoadingSmall()
                              : Column(
                                  children: <Widget>[
                                    Text(
                                      'TrackiT Hospital',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff1967d2)),
                                    ),
                                    Container(
                                        child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ClipOval(
                                          child: CircleAvatar(
                                            backgroundImage: user != null
                                                ? NetworkImage(
                                                    "${user.photoUrl}")
                                                : AssetImage(
                                                    'assets/user_icon.png'),
                                            maxRadius: 40,
                                            minRadius: 30,
                                          ),
                                        ),
                                        Text(
                                          user == null
                                              ? "My Account"
                                              : user.displayName,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
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
            ),
          );
  }
}

class AddReq extends StatelessWidget {
  String reqName;
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    void submitReq() async {
      Firestore.instance
          .collection("reqlist")
          .document(distno[mainselctDist])
          .collection(mainselctDist)
          .document()
          .setData({
        "reqname": reqName,
        "reqstnt_name": user.displayName,
        'user_uid': user.uid,
        'description': desc,
        'quantity': qty,
        'reqstnt_phno': usrPhno
      });
    }

    void _showDialog() {
      String errorm = "";
      slideDialog.showSlideDialog(
          context: context,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            //controller: controller,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _reqkey,
                    child: Text(
                      reqName,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Discription'),
                    validator: (input) {
                      if (input.isNotEmpty) {
                        return 'Please enter Quantity!';
                      }
                    },
                    onChanged: (input) => desc = input,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Quantity'),
                    validator: (input) {
                      if (input.isNotEmpty) {
                        return 'Please enter Quantity!';
                      }
                    },
                    onChanged: (input) => qty = input,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    errorm,
                    style: TextStyle(color: Colors.red),
                  ),
                  RaisedButton(
                      child: Text(
                        'Add Requirement',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      color: Colors.pink[400],
                      hoverColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(50, 20, 50, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () async {
                        if (_reqkey.currentState.validate()) {
                          print(reqName);
                          print(desc);
                          print(qty);

                          if (mainselctDist == "Select District") {
                            errorm = "Please enter your Location";
                          } else {
                            submitReq();
                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                          }
                        }
                      })
                ],
              ),
            ),
          ));
    }

    return Scaffold(
      //backgroundColor: themeData.backgroundColor,

      appBar: AppBar(
        leading: IconButton(
          color: Color(0xff1967d2),
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Text("Select Your Requirement"),
            SizedBox(height: 15),
            ListView.builder(
                shrinkWrap: true,
                itemCount: reqList.length,
                itemBuilder: (BuildContext context, int position) {
                  var name = reqList[position];
                  return Card(
                      margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: ListTile(
                          title: Text(name),
                          onTap: () async {
                            reqName = reqList[position];
                            _showDialog();
                          }));
                })
          ],
        ),
      ),
    );
  }
}
