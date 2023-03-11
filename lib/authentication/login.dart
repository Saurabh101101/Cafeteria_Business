
import 'package:cafeteria_business/authentication/signup.dart';
import 'package:cafeteria_business/global/global.dart';
import 'package:cafeteria_business/mainScreens/home.dart';
import 'package:cafeteria_business/widgets/error_dialog.dart';
import 'package:cafeteria_business/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';


class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TextEditingController emailController =TextEditingController() ;
  TextEditingController passwordController =TextEditingController() ;

  bool _isHidden=true;

  void _toggle()
  {
    setState(() {
      _isHidden=!_isHidden;
    });
  }


  formValidation()
  {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
      {
        //login
        loginNow();
      }
    else{
      showDialog(context: context, builder: (c){
        return ErrorDialog(message:"Please Enter all details",);
      });
    }
  }

  loginNow() async
  {
    showDialog(context: context, builder: (c) {
      return LoadingDialog(message: "Authenticating..",);
    }
    );
    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(email: emailController.text.trim(),
        password: passwordController.text.trim(),).then((auth) {
          currentUser=auth.user!;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context, builder: (c){
        return ErrorDialog(message: error.message.toString(),);
      });
    });
    if(currentUser!=null)
      {
      readDataAndSaveLocally(currentUser!);
      }
      }


  Future readDataAndSaveLocally(User currentUser) async
  {
    await FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).get().then((snapshot)async {
      if(snapshot.exists)
        {
      await sharedPreferences!.setString("uid", currentUser.uid);
      await sharedPreferences!.setString("name",snapshot.data()!["sellerName"]);
      await sharedPreferences!.setString("photoUrl", snapshot.data()!["sellerAvatarUrl"]);
      await sharedPreferences!.setString("email", snapshot.data()!["sellerEmail"]);
      await sharedPreferences!.setString("phone", snapshot.data()!["sellerPhone"]);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
    }
      else{
      firebaseAuth.signOut();
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const MyLogin()));
      showDialog(context: context, builder: (c){
        return ErrorDialog(
          message: "No record found ! ",
        );
      }
      );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover,) ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35,top:MediaQuery.of(context).size.height*0.1),
              child: Text('Welcome',style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 40,
              ),),
              
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,top:MediaQuery.of(context).size.height*0.20),
              child: Row(
                children: [
                  Text('SIGN IN',style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,)),
                      SizedBox(width: 10),
                      Icon(Icons.restaurant_outlined, color: Colors.white,size: 45),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 35,right: 35,top:MediaQuery.of(context).size.height*0.30),
              child: SizedBox(
                height: 45,
                width: 340,
                child: ElevatedButton(onPressed: (){

                  // final provider=Provider.of(context,listen: false);
                  // provider.googleLogin();
                },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[900]?.withOpacity(0.5),
                      shape: StadiumBorder(),
                      elevation: 0,),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/google.png",
                            height: 40,
                            width: 40,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Login with Google",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                color: Colors.white),
                          ),
                        ],
                      ),)
                ),
              ),),
            Padding(
              padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height*0.39,left:35,right:35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Container(height:1.0,width:100.0,color:Colors.white),
                 SizedBox(width: 10),
                  Text("or",style: TextStyle(color:Colors.white,fontSize: 20)),
                  SizedBox(width: 10),
                  Container(height:1.0,width:100.0,color:Colors.white),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.45,right: 35,left: 35),
                child: Column(
                  children: [
                    Form(
                      key: _formkey,
                      child: Column(
                          children:
                          [
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail_sharp),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText:'Enter Email',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                              ),
                            ),
                            SizedBox(height: 30),
                            TextField(
                              obscureText: _isHidden,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.key_outlined),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText:'Enter Password',
                                  suffix: InkWell(onTap:_toggle,child: Icon(_isHidden?Icons.visibility:Icons.visibility_off,)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                              ),
                            ),
                          ],
                    ),),

                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 45,
                      width: 150,
                      child: ElevatedButton(onPressed: (){
                        formValidation();
                      },

                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[900],
                        shape: StadiumBorder(),
                        elevation: 10.0,
                        textStyle: const TextStyle(color:Colors.blueAccent)

                       ),
                       child: const Text('Sign in')),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't Have a account ?",style: TextStyle(color:Colors.white), ),
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MySignup()));
                          },
                           child: const Text("Sign Up",style: TextStyle(color:Colors.lightGreenAccent),)),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}