import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:trackit_hosp/shared/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _reqkey = GlobalKey<FormState>();
String reqName;

class AddReq extends StatelessWidget {
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
        "reqstnt_name": usrname,
        'user_uid': user.uid,
        'description': desc,
        'quantity': qty,
        'reqstnt_phno': usrPhno
      });
    }

    void _showDialogreq() {
      slideDialog.showSlideDialog(
          context: context,
          backgroundColor: themeData.appBarTheme.color,
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Form(
                      key: _reqkey,
                      child: Column(
                        children: [
                          Text(
                            reqName,
                            style: TextStyle(fontSize: 18),
                          ),
                          Divider(color: Color(0xFFD21919)),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Discription'),
                            validator: (input) => input.isEmpty
                                ? 'Enter your Discription.'
                                : null,
                            onChanged: (input) => desc = input,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Quantity'),
                            validator: (input) =>
                                input.isEmpty ? 'Enter your Quantity.' : null,
                            onChanged: (input) => qty = input,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                              child: Text(
                                'Add Requirement',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
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
                                    int count = 0;

                                    Fluttertoast.showToast(
                                      msg:
                                          "Please add your location to add Requirment",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      // textColor: Color(0xFFDD4010),
                                      // backgroundColor:
                                      //     themeData.appBarTheme.color,
                                    );

                                    Navigator.of(context)
                                        .popUntil((_) => count++ >= 2);
                                  } else {
                                    submitReq();
                                    int count = 0;
                                    Navigator.of(context)
                                        .popUntil((_) => count++ >= 2);
                                  }
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
    }

    return Scaffold(
      backgroundColor: themeData.backgroundColor,
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
                            _showDialogreq();
                          }));
                })
          ],
        ),
      ),
    );
  }
}
