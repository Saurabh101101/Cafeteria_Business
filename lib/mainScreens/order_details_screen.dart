import 'dart:convert';

import 'package:cafeteria_business/widgets/progress_bar.dart';
import 'package:cafeteria_business/widgets/status_banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cafeteria_business/global/global.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';


class OrderDetailsScreen extends StatefulWidget
{
  final String? orderID;


  OrderDetailsScreen({this.orderID});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}




class _OrderDetailsScreenState extends State<OrderDetailsScreen>
{

  String orderStatus = "";
  String orderByUser = "";
  String sellerId = "";
  String token="";

  bool clicked=false;






  getOrderInfo()
  {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID).get().then((DocumentSnapshot)
    {
      orderStatus = DocumentSnapshot.data()!["status"].toString();
      orderByUser = DocumentSnapshot.data()!["orderBy"].toString();
      sellerId = DocumentSnapshot.data()!["sellerUID"].toString();
      token=DocumentSnapshot.data()!["token"].toString();
    });
  }











  @override
  void initState() {
    super.initState();

    getOrderInfo();



  }

  // getToken() async
  // {
  //   await FirebaseFirestore.instance.collection("users").doc(orderByUser).get().then((DocumentSnapshot) {
  //     token=DocumentSnapshot.data()!["token"].toString();
  //
  //   });
  // }

  void sendPushMessage(String token, String body, String title) async
  {
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers:<String,String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAACVXrvxg:APA91bHpRrad2YKFRmqt-YGgis9xWMr1T9mRkISQnBLn6bkCjrRthSLy8pgj6N8Jd-tJlPp4yaW3t9XrXKwjGJFTr_FbGKX3KVe6qQhUyNyG4tSdBWHVKKXvX5gXgCEMxKcJN2sIoOUM'
        },
        body: jsonEncode(
          <String,dynamic>{

            'priority':'high',
            'data':<String,dynamic>{
              'click_action':'FLUTTER_NOTIFICATION_CLICK',
              'status':'done',
              'body':body,
              'title':title,
            },

            "notification":<String,dynamic>{
              "title":title,
              "body":body,
              "android_channel_id":"cafeteria_app",
            },
            "to": token,
          },

        ),
      );
    } catch(e){
      if(kDebugMode){
        print("Error");
      }
    }
  }






  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
      appBar: AppBar(
        title: Text("O R D E R   D E T A I L S",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'
          ), ),
        centerTitle:true ,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal[900]?.withOpacity(0.85),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (c, snapshot)
          {
            Map? dataMap;
            if(snapshot.hasData)
            {
              dataMap = snapshot.data!.data()! as Map<String, dynamic>;
              orderStatus = dataMap["status"].toString();
            }
            return snapshot.hasData
                ? Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Text(
                            "Total Amount : ₹ " + dataMap!["totalAmount"].toString(),
                            style: const  TextStyle(
                                fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 17,fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),

                        Text( "Order Id :"+dataMap!["orderId"].toString(),style: TextStyle(
                            fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 17,fontStyle: FontStyle.italic
                        ),),
                        const SizedBox(height: 10,),
                        Text("Order Time : ${DateFormat("dd MMMM, yyyy - hh:mm aa")
                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"])))}",style: TextStyle(
                            fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 17,fontStyle: FontStyle.italic
                        ),),
                        const SizedBox(height: 10,),
                        Text("Order Pickup Time : "+dataMap["pickUpTime"].toString(),style: TextStyle(
                            fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 17,fontStyle: FontStyle.italic
                        ),),
                        const SizedBox(height: 10,),
                        Text("Order By : "+dataMap["orderUserName"].toString(),style: TextStyle(
                            fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 17,fontStyle: FontStyle.italic
                        ),),
                        const SizedBox(height: 10,),
                        Text("Contact Info : "+dataMap["userPhone"].toString(),style: TextStyle(
                            fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 17,fontStyle: FontStyle.italic
                        ),),
                        Divider(thickness: 2,color: Colors.teal,),
                        const SizedBox(height: 10,),


                        Center(
                          child: orderStatus == "ready"
                              ? Image.asset("assets/images/ready1.jpg")
                              : Image.asset("assets/images/picked.png"),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20,top: 30),
                              child: SizedBox(
                                height: 50,
                                width: 150,
                                child: ElevatedButton(style:ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    elevation: 0
                                )
                                    ,onPressed: !clicked?(){
                                  FirebaseFirestore.instance.collection("orders").doc(widget.orderID).update({"status":"picked"}).then((value){
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(orderByUser)
                                        .collection("orders").doc(widget.orderID).update({"status":"picked"}).then((value){
                                      sendPushMessage(token, "Your Order is Picked up and moved to History Tab", "Order Status !");
                                      setState(() {

                                          const clicked=true;
                                      });

                                    });
                                  });
                                }:null, child:
                                Text("Order Picked !",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
                              ),
                            ),

          InkWell(
          onTap: ()
          {
          Navigator.pop(context);
          },
          child: Padding(
          padding: const EdgeInsets.only(left: 50,top: 30),

          child: Container(
          decoration: BoxDecoration(

          color: Colors.teal,
          ),

          height:50 ,
          width: 150,
          child: Center(
          child: Text(" Go Back",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
            ),
            ),
            ),
            ),],
                        )


                      ],
                    ),
                  )
                : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
