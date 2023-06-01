
import 'package:cafeteria_business/mainScreens/home.dart';
import 'package:cafeteria_business/model/items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';


class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  ItemDetailsScreen({this.model});
  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {

  TextEditingController counterTextEditingController = TextEditingController();


  deleteItem(String itemId)
  {
    FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid")).collection("categories")
        .doc(widget.model!.menuID!).collection("items").doc(itemId)
        .delete().then((value){
      FirebaseFirestore.instance.collection("items").doc(itemId).delete();
      Fluttertoast.showToast(msg: "The selected item has been deleted successfully !");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>const HomeScreen()));
    });





  }
  @override





  Widget build(BuildContext context) {
    return  Container(
        child: Container(constraints: BoxConstraints.expand(),
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover,) ),
      child: Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.teal[900]?.withOpacity(0.85),

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width,
              child: Image.network(widget.model!.thumbnailUrl.toString(),fit: BoxFit.cover,),
            ),




            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.title.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14,color: Colors.teal),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.price.toString() + " Rs",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),

            const SizedBox(height: 10,),

            Center(
              child: InkWell(
                onTap: ()
                {
                 //delete item
                  deleteItem(widget.model!.itemID!);

                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.teal
                  ),
                  width: MediaQuery.of(context).size.width - 13,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Delete item",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
