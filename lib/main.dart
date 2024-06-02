
import 'package:flutter/material.dart';
import 'package:reco_rec/screens/splashscreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: SplashScreen(),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
          fontFamily: 'Inter'
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


