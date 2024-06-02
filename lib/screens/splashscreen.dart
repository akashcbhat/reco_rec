import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reco_rec/screens/onboarding.dart';
import 'package:reco_rec/screens/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboarding = (prefs.getBool('seen') ?? false);

    Timer(Duration(seconds: 2), () {
      if (seenOnboarding) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ImagePickerDemo(),));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Onboarding(),));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(121221),
      body: Center(
        child: Container(
          child: ElasticIn(
            child: Image.asset("assets/images/logo_recorec_plain.png", scale: 1.2,),
            duration: Duration(seconds: 2),
          ),
        ),
      ),
    );
  }
}
