import 'package:cafeteria_business/widgets/progress_bar.dart';
import 'package:cafeteria_business/widgets/status_banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cafeteria_business/global/global.dart';

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
    });
  }







  @override
  void initState() {
    super.initState();

    getOrderInfo();



  }






  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
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
                      children: [
                        StatusBanner(
                          status: dataMap!["isSuccess"],
                          orderStatus: orderStatus,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "€  " + dataMap["totalAmount"].toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order Id = " + widget.orderID!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order at: ${DateFormat("dd MMMM, yyyy - hh:mm aa")
                                    .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"])))}",
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        ElevatedButton(onPressed: !clicked?(){
                          FirebaseFirestore.instance.collection("orders").doc(widget.orderID).update({"status":"picked"}).then((value){
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(orderByUser)
                                .collection("orders").doc(widget.orderID).update({"status":"picked"}).then((value){
                                    const clicked=true;

                            });
                          });
                        }:null, child:
                        Text("Order Picked Up !")),
                        const Divider(thickness: 4,),
                        orderStatus == "ready"
                            ? Image.asset("assets/images/ready1.jpg")
                            : Image.asset("assets/images/picked.png"),


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
