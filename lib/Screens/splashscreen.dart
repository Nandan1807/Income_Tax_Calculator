import 'package:flutter/material.dart';
import 'package:tax_track/Screens/MenuScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3),() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MenuScreen(),));
    },);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('T', style: TextStyle(height:1,fontSize: 130,fontWeight: FontWeight.bold),),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ax', style: TextStyle(height:0.8,fontSize: 60,fontWeight: FontWeight.bold)),
                  Text('rack', style: TextStyle(height:0.8,fontSize: 60,fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.white,
              Colors.blue
            ],
          ),
        ),
      ),
    );
  }
}
