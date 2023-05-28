
import 'dart:io';

import 'package:cafeteria_business/global/global.dart';
import 'package:cafeteria_business/mainScreens/home.dart';
import 'package:cafeteria_business/model/categories.dart';
import 'package:cafeteria_business/widgets/error_dialog.dart';
import 'package:cafeteria_business/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class ItemsUploadScreen extends StatefulWidget {
  final Categories? model;
  ItemsUploadScreen({ this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {

  XFile? imageXFile;
  final ImagePicker _picker =ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();


  bool uploading=false;
  String uniqueId=DateTime.now().millisecondsSinceEpoch.toString();
  defaultScreen()
  {
    return Container(
        constraints: BoxConstraints.expand(),
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover,) ),
  child: Scaffold(
  backgroundColor: Colors.transparent,
  appBar: AppBar(
  backgroundColor: Colors.teal[900]?.withOpacity(0.85),
  title: const Text("Add New Item",),
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
              const Icon(Icons.shop_2_sharp, size: 150,color: Colors.white ),
              ElevatedButton(onPressed: (){
                takeImage(context);
              }, child: Text("Add New Item",style: TextStyle(color: Colors.white,fontSize: 18,),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
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
    ));
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

  itemsUploadFormScreen()
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uploading New Item"),
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
                  hintText: " Info",
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
                  hintText: " Title",
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
            leading: const Icon(Icons.description
              ,color: Colors.grey,),
            title: Container(
              width: 250,
              child:  TextField(
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: " Description",
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
            leading: const Icon(Icons.monetization_on,color: Colors.grey,),
            title: Container(
              width: 250,
              child:  TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: " Price",
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
      priceController.clear();
      descriptionController.clear();
      imageXFile=null;
    });
  }

  validateUploadForm() async
  {


    if(imageXFile!=null)
    {
      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && priceController.text.isNotEmpty)
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
    storageRef.Reference reference=storageRef.FirebaseStorage.instance.ref().child("items");
    storageRef.UploadTask uploadTask=reference.child(uniqueId+".jpg").putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot=await uploadTask.whenComplete((){

    });
    String downloadUrl= await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveInfo(String downloadUrl)
  {
    final ref=FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid"))
        .collection("categories").doc(widget.model!.menuId).collection("items");
    ref.doc(uniqueId).set({
      "itemID":uniqueId,
      "menuID":widget.model!.menuId,
      "sellerUID":sharedPreferences!.getString("uid"),
      "sellerName":sharedPreferences!.getString("name"),
      "shortInfo": shortInfoController.text.toString(),
      "longDescription": descriptionController.text.toString(),
      "price": int.parse(priceController.text),
      "title": titleController.text.toString(),
      "publishedDate":DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    }).then((value){
      final itemRef=FirebaseFirestore.instance.collection("items");

      itemRef.doc(uniqueId).set({
        "itemID":uniqueId,
        "menuID":widget.model!.menuId,
        "sellerUID":sharedPreferences!.getString("uid"),
        "sellerName":sharedPreferences!.getString("name"),
        "shortInfo": shortInfoController.text.toString(),
        "longDescription": descriptionController.text.toString(),
        "price": int.parse(priceController.text),
        "title": titleController.text.toString(),
        "publishedDate":DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
      });
    }).then((value) {

      clearMenuUploadForm();
      setState(() {
        uniqueId=DateTime.now().millisecondsSinceEpoch.toString();
        uploading=false;
      });
    });



  }


  @override
  Widget build(BuildContext context)
  {
    return imageXFile==null? defaultScreen() : itemsUploadFormScreen();
  }
}
