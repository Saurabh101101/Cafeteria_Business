import 'package:cafeteria_business/assistant_methods/assistant_methods.dart';
import 'package:cafeteria_business/global/global.dart';
import 'package:cafeteria_business/mainScreens/order_card_new.dart';
import 'package:cafeteria_business/widgets/order_card.dart';
import 'package:cafeteria_business/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class NewOrdersScreen extends StatefulWidget
{
  @override
  _NewOrdersScreenState createState() => _NewOrdersScreenState();
}



class _NewOrdersScreenState extends State<NewOrdersScreen>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                 image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover,) ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text("N E W  O R D E R S",
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
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("orders")
                  .where("status", isEqualTo: "normal")
                  .where("sellerUID",isEqualTo: sharedPreferences!.getString("uid"))
                  .snapshots(),
              builder: (c, snapshot)
              {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (c, index)
                        {
                          return FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection("items")
                                .where("itemID", whereIn: separateOrderItemIDs((snapshot.data!.docs[index].data()! as Map<String, dynamic>) ["productIDs"]))
                                .where("sellerUID", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
                                .orderBy("publishedDate", descending: true)
                                .get(),
                            builder: (c, snap)
                            {
                              return snap.hasData
                                  ? OrderCardNew(
                                itemCount: snap.data!.docs.length,
                                data: snap.data!.docs,
                                orderID: snapshot.data!.docs[index].id,
                                seperateQuantitiesList: separateOrderItemQuantities((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"]),
                              )
                                  : Center(child: circularProgress());
                            },
                          );
                        },
                      )

                    : Center(child: circularProgress(),);
              },
            ),

          ),
    ));
  }
}
