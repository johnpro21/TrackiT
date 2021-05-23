import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSmall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 50,
      color: Colors.transparent,
      child: Center(
        child: SpinKitChasingDots(
          color: Color(0xff1967d2),
          size: 15.0,
        ),
      ),
    );
  }
}
