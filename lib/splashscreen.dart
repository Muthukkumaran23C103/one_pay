import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/signlog.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}
class _SplashScreen extends State<SplashScreen>{
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>SignLog()),);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icons/logo.png', width: 250, height: 250,),
              SizedBox(height: 20),
              CircularProgressIndicator(
                strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              )
            ],
          ),
        )
    );
  }
}