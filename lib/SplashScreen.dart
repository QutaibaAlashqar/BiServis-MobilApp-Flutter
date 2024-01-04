import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hopethelasone/ServicesActivity.dart';
import 'package:hopethelasone/WorkerActivity.dart';
import 'package:hopethelasone/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadPreferencesAndNavigate();
  }

  _loadPreferencesAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String eposta = prefs.getString('eposta') ?? '';
    String userName = prefs.getString('userName') ?? '';
    String stat = prefs.getString('stat') ?? '';
    // Perform any actions with eposta and userName here if needed.

    Future.delayed(Duration(seconds: 4), () {
      if(eposta.isNotEmpty && userName.isNotEmpty){
        if(stat=="1"){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ServicesActivity()),
          );
        }else{
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => WorkerActivity()),
          );
        }
      }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainActivity()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animation.json', // Path to your Lottie animation file
          width: 400, // Adjust width and height as needed
          height: 400,
          repeat: true, // Set to true if you want the animation to loop
          reverse: false, // Set to true if you want the animation to play in reverse
          animate: true, // Set to false if you want to pause the animation
        ),
      ),
    );
  }
}
