import 'package:cafeteria_business/widgets/progress_bar.dart';
import 'package:cafeteria_business/widgets/status_banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';


class OrderDetailsScreenNew extends StatefulWidget
{
  final String? orderID;

  OrderDetailsScreenNew({this.orderID});

  @override
  _OrderDetailsScreenNewState createState() => _OrderDetailsScreenNewState();
}




class _OrderDetailsScreenNewState extends State<OrderDetailsScreenNew>
{
  String orderStatus = "";
  String orderByUser = "";
  String sellerId = "";
  double orderPrice=0.0;
  double previousEarning=0.0;
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
      orderPrice=double.parse(DocumentSnapshot.data()!["totalAmount"].toString());

    });
  }
  
  
  getPreviousEarning()
  {
    FirebaseFirestore.instance.collection("sellers").doc("DpuAj3utfVef9klNf5Pyb3tTwyH3").get().then((DocumentSnapshot) {
      previousEarning=double.parse(DocumentSnapshot.data()!["earnings"].toString());
    });
  }

  @override
  void initState() {
    super.initState();

    getOrderInfo();
    getPreviousEarning();
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
                  const Divider(thickness: 4,),
                  ElevatedButton(onPressed: !clicked? (){
                    FirebaseFirestore.instance.collection("orders").doc(widget.orderID).update({"status":"ready"}).then((value){
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(orderByUser)
                          .collection("orders").doc(widget.orderID).update({"status":"ready"}).then((value){
                        FirebaseFirestore.instance
                            .collection("sellers")
                            .doc("DpuAj3utfVef9klNf5Pyb3tTwyH3").update({"earnings":(previousEarning+orderPrice)}).then((value){
                          const clicked=true;
                        });
                      });
                    });
                  }:null,  child:
                  Text("Order Ready !")),
                  orderStatus == "ready"
                      ? Image.asset("assets/images/ready1.jpg")
                      : Image.asset("assets/images/placed.png"),


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
