
import 'dart:io';


import 'package:cafeteria_business/mainScreens/home.dart';
import 'package:cafeteria_business/widgets/error_dialog.dart';
import 'package:cafeteria_business/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';



class MySignup extends StatefulWidget {
  const MySignup({Key? key}) : super(key: key);

  @override
  MySignupState createState() => MySignupState();
}

class MySignupState extends State <MySignup> {
   bool _isHidden1=true;

  void _toggle1()
  {
    setState(() {
      _isHidden1=!_isHidden1;
    });
  }
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TextEditingController nameController =TextEditingController() ;
  TextEditingController phoneController =TextEditingController() ;
  TextEditingController emailController =TextEditingController() ;
  TextEditingController passwordController =TextEditingController() ;
  XFile? imageXFile;
  final ImagePicker _picker=ImagePicker();
  String usersImageUrl="";

  Future<void> _getImage() async
  {
    imageXFile= await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  Future<void> formValidation()async
  {
    if(imageXFile==null)
      {
        showDialog(
          context: context,
          builder:(c)
            {
              return ErrorDialog(message: "Please Select an image",);
            }
        );
      }
    else{
      if(nameController.text.isNotEmpty && phoneController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
      {
        //start upload
        showDialog(context: context, builder: (c)
        {
          return LoadingDialog(
            message: "Signing you up..",
          );
        }
        );
        
        String fileName=DateTime.now().millisecondsSinceEpoch.toString();
        fStorage.Reference reference=fStorage.FirebaseStorage.instance.ref().child("sellers").child(fileName);
        fStorage.UploadTask uploadTask=reference.putFile(File(imageXFile!.path));
        fStorage.TaskSnapshot taskSnapshot=await uploadTask.whenComplete((){});
        await taskSnapshot.ref.getDownloadURL().then((url) {
          usersImageUrl=url;

          //save info firestore
          authenticateUserAndSignUp();
        });
      }
      else{
        showDialog(
            context: context,
            builder:(c)
            {
              return ErrorDialog(message: "Please fill all required fields",);
            }
        );
      }
    }
  }


  void authenticateUserAndSignUp() async
  {
    User? currentUser;


    await firebaseAuth.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim()).then((auth){
      currentUser=auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder:(c)
          {
            return ErrorDialog(message:error.message.toString(),
            );
          }
      );
    });

    if(currentUser !=null)
      {
        saveDataToFirestore(currentUser!).then((value){
          Navigator.pop(context);
          //send to home
          Route newRoute=MaterialPageRoute(builder: (c)=>HomeScreen());
          Navigator.pushReplacement(context, newRoute);
        });
      }

  }

  Future saveDataToFirestore(User currentUser) async
  {
    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
      "sellerUID": currentUser.uid,
      "sellerEmail": currentUser.email,
      "sellerName" : nameController.text.trim(),
      "sellerPhone" : phoneController.text.trim(),
      "sellerAvatarUrl" : usersImageUrl,
      "status" : "verified",
      "earnings": 0.0,
    });

    //save data locally
     sharedPreferences=await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", usersImageUrl);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("phone", phoneController.text.trim());
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
              child: Row(
                children: [
                  Text('Welcome',style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 40,
                  ),),
                      SizedBox(width: 10),
                      Icon(Icons.restaurant_outlined, color: Colors.white,size: 45),
                ],
                
              ),
              
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,top:MediaQuery.of(context).size.height*0.20),
              child: 
                  Text('Create Account',style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,)),
                      
              ),
            SingleChildScrollView(

              child: Container(
                padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.25,right: 35,left: 35),
                child: Column(
                  children: [
                    InkWell(
                      onTap:()
                  {
                    _getImage();
                  },
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width*0.10,
                        backgroundColor: Colors.white,
                        backgroundImage:imageXFile==null ?null :FileImage(File(imageXFile!.path)) ,
                        child: imageXFile==null? Icon(Icons.add_a_photo_sharp,size: MediaQuery.of(context).size.width*0.10,color: Colors.grey,):null,
                      ),
                    ),

                    SizedBox(height: 15),
                    Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_add_outlined),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText:'Full Name',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                              ),
                            ),
                            SizedBox(height: 15),
                            TextField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.call_rounded),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText:'Phone Number',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                              ),
                            ),
                            SizedBox(height: 15),
                            TextField(
                              controller: emailController,

                              decoration: InputDecoration(

                                  prefixIcon: Icon(Icons.mail_sharp),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText:'Email',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                              ),
                            ),
                            SizedBox(height: 15),
                            TextField(
                              controller: passwordController,

                              obscureText: _isHidden1,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.key_outlined),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText:'Enter Password',
                                  suffix: InkWell(onTap:_toggle1,child: Icon(_isHidden1?Icons.visibility:Icons.visibility_off,)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                              ),
                            ),
                          ],
                        )),

                    SizedBox(height: 22),
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
                       child: const Text('Sign up')),
                    ),
          ],
        ),
        )),
        Padding(
              padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height*0.82,left:35,right:35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Container(height:2.0,width:100.0,color:Colors.white),
                 SizedBox(width: 10),
                  Text("or",style: TextStyle(color:Colors.white,fontSize: 20)),
                  SizedBox(width: 10),
                  Container(height:2.0,width:100.0,color:Colors.white),
                ],
              ),
            ),
        Padding(
          padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height*0.84,left: 100,right: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
           children:[ 
            SizedBox(height: 25),
             Text('Already have an account ?',style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 15),
                    SizedBox(
                      height: 45,
                      width: 150,
                      child: ElevatedButton(onPressed: (){
                        Navigator.pop(context);
                      },
                       
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[900],
                        shape: StadiumBorder(),
                        elevation: 10.0,
                        textStyle: const TextStyle(color:Colors.teal)
                        
                       ),
                       child: const Text('Sign in')),
                    ),
           ]
          ),
        )
        ]
        )
        )
        );
  }
}