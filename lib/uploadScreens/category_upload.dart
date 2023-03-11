import 'dart:convert';
import 'dart:io';

import 'package:cafeteria_business/global/global.dart';
import 'package:cafeteria_business/mainScreens/home.dart';
import 'package:cafeteria_business/widgets/error_dialog.dart';
import 'package:cafeteria_business/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class CategoryUploadScreen extends StatefulWidget {
  const CategoryUploadScreen({Key? key}) : super(key: key);

  @override
  State<CategoryUploadScreen> createState() => _CategoryUploadScreenState();
}

class _CategoryUploadScreenState extends State<CategoryUploadScreen> {

  XFile? imageXFile;
  final ImagePicker _picker =ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  bool uploading=false;
  String uniqueId=DateTime.now().millisecondsSinceEpoch.toString();
  defaultScreen()
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Category"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon:const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
          },
        ),

      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shop_2_sharp, size: 150,),
              ElevatedButton(onPressed: (){
                takeImage(context);
              }, child: Text("Add New Category",style: TextStyle(color: Colors.white,fontSize: 18,),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

              ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  takeImage(mContext)
  {
    return showDialog(
        context: mContext,
        builder: (context)
        {
          return  SimpleDialog(
            title: const Text("Category Image",style: TextStyle(
              color: Colors.amber,fontWeight: FontWeight.bold,
            ),),
            children: [
              SimpleDialogOption(
                child: const Text("Capture with Camera",style:TextStyle(
                  color: Colors.grey,fontWeight: FontWeight.bold,
                ) ,),
                onPressed:captureImageWithCamera,
              ),
              SimpleDialogOption(
                  child: const Text("Select from Gallery",style:TextStyle(
                    color: Colors.grey,fontWeight: FontWeight.bold,
                  ) ,),
                  onPressed:pickImageFromGallery,
              ),
              SimpleDialogOption(
                  child: const Text("Cancel",style:TextStyle(
                    color: Colors.grey,fontWeight: FontWeight.bold,
                  ) ,),
                  onPressed:()=>Navigator.pop(context),
              ),
            ],
          );
        }
    );
  }


  captureImageWithCamera() async
  {
    Navigator.pop(context);
    imageXFile=await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async
  {

    Navigator.pop(context);
    imageXFile=await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  menusUploadFormScreen()
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uploading New Category"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon:const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: ()
          {
            clearMenuUploadForm();
          },
        ),
        actions: [
          TextButton(
              onPressed: uploading?null:()=>validateUploadForm(),

              child: Text("Add",style: TextStyle(color: Colors.white,
                  fontWeight:FontWeight.bold,fontSize: 18),
              ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading==true?linearProgress():const Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width*0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(imageXFile!.path)),
                      fit: BoxFit.fill,
                    )
                  ),
                ),
              ),
            ),
          ),
           ListTile(
            leading: const Icon(Icons.perm_device_information_outlined,color: Colors.grey,),
            title: Container(
              width: 250,
              child:  TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: "Menu Info",
                  hintStyle: TextStyle(color:Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
           Divider(
             color: Colors.amber,
             thickness: 2,
           ),
           ListTile(
            leading: const Icon(Icons.title_sharp,color: Colors.grey,),
            title: Container(
              width: 250,
              child:  TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Menu Title",
                  hintStyle: TextStyle(color:Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.amber,
            thickness: 2,
          ),
        ],
      ),

    );
  }

  clearMenuUploadForm()
  {

    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile=null;
    });
  }

  validateUploadForm() async
  {


    if(imageXFile!=null)
      {
        if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty)
          {
            setState(() {
              uploading=true;

            });
            //upload image
            String downloadurl= await uploadImage(File(imageXFile!.path));
            //save info

            saveInfo(downloadurl);
          }
        else{
          showDialog(
              context: context,
              builder:(c)
              {
                return ErrorDialog(
                  message:"Please write Title and Info for Category !",
                );
              }
          );
        }
      }
    else{
      showDialog(
          context: context,
          builder:(c)
          {
            return ErrorDialog(
              message:"Please pick an image for Category !",
            );
          }
      );
    }
  }


  uploadImage(mImageFile) async
  {
    storageRef.Reference reference=storageRef.FirebaseStorage.instance.ref().child("categories");
    storageRef.UploadTask uploadTask=reference.child(uniqueId+".jpg").putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot=await uploadTask.whenComplete((){

    });
    String downloadUrl= await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveInfo(String downloadUrl)
  {
    final ref=FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid")).collection("categories");
    ref.doc(uniqueId).set({
      "menuID":uniqueId,
      "sellerUID":sharedPreferences!.getString("uid"),
      "menuInfo": shortInfoController.text.toString(),
      "menuTitle": titleController.text.toString(),
      "publishedDate":DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    });

    clearMenuUploadForm();
    setState(() {
      uniqueId=DateTime.now().millisecondsSinceEpoch.toString();
      uploading=false;
    });

  }


  @override
  Widget build(BuildContext context)
  {
    return imageXFile==null? defaultScreen() : menusUploadFormScreen();
  }
}
