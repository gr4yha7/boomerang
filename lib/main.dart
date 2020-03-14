import 'package:flutter/material.dart';
import 'package:boomerang/screens/splashscreen.dart';
import 'package:boomerang/screens/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boomerang',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => Login(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}

