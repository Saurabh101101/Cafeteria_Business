import 'dart:async';

import 'package:cafeteria_business/authentication/login.dart';
import 'package:cafeteria_business/mainScreens/home.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';




class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  
  startTimer()
  {
    Timer(const Duration(seconds: 3),()async
    {

      if(firebaseAuth.currentUser!=null)
        {
         Navigator.push(context, MaterialPageRoute(builder: (c)=>const HomeScreen()));
        }
      else{
       Navigator.push(context, MaterialPageRoute(builder: (c)=>const MyLogin()));
      }
    }
    
    
    );
  }
  
  @override
  void initState()
  {
    super.initState();
    
    startTimer();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(constraints: BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'), fit: BoxFit.cover,) ),

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Image.asset("assets/images/logo.png"),
            )
          ],
        ),
      ),
    );
  }
}

