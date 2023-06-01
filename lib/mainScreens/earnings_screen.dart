import 'package:cafeteria_business/global/global.dart';
import 'package:cafeteria_business/mainScreens/home.dart';
import 'package:cafeteria_business/splash_screen/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class EarningsScreen extends StatefulWidget
{
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  _EarningsScreenState createState() => _EarningsScreenState();
}




class _EarningsScreenState extends State<EarningsScreen>
{
  double sellerTotalEarnings = 0;

  retrieveSellerEarnings() async
  {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .get().then((snap)
    {
      setState(() {
        sellerTotalEarnings = double.parse(snap.data()!["earnings"].toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();

    retrieveSellerEarnings();
  }

  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
        child: Container(constraints: BoxConstraints.expand(),
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover,) ),
    child: Scaffold(
    backgroundColor: Colors.transparent,
    appBar: AppBar(
    title: Text("M Y   E A R N I N G S",
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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  " ₹ " + sellerTotalEarnings!.toString(),
                  style: const TextStyle(
                    fontSize: 80,
                    color: Colors.white,
                    fontFamily: "Signatra"
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
                width: 250,
                child: Divider(
                  color: Colors.white,
                  thickness: 2,
                ),
              ),

              const SizedBox(height: 50.0,),

              Center(
                  child: InkWell(
                    onTap: ()
                    {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(

                        color: Colors.teal,
                      ),

                      height:50 ,
                      width: MediaQuery.of(context).size.width-40,
                      child: Center(
                        child: Text(" GO BACK",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                      ),
                    ),
                  )
              )


            ],
          ),
        ),
      ),
    )));
  }
}
