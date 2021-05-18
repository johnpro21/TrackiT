import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return Container(
      color: themeData.scaffoldBackgroundColor,
      child: Center(
        child: SpinKitChasingDots(
          color: Color(0xff1967d2),
          size: 80.0,
        ),
      ),
    );
  }
}
