import 'package:trackit_hosp/SignIn.dart';
import 'package:trackit_hosp/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'HomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

// First put json file in android and json
// use gradle in android plugin
// yaml for firebase

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Loogin',
      theme: ThemeData(
        brightness: Brightness.light,
        backgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(color: Colors.white),

        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        appBarTheme: AppBarTheme(color: Colors.black),
        /* dark theme settings */
      ),
      themeMode: ThemeMode.system,
      home: HomePage(),
      routes: {
        '/signin': (BuildContext context) => SignIn(),
        '/home': (BuildContext context) => HomePage(),
        '/signup': (BuildContext context) => SignUp(),
      },
    );
  }
}
