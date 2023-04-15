
import 'package:cafeteria_business/authentication/login.dart';
import 'package:cafeteria_business/global/global.dart';
import 'package:cafeteria_business/mainScreens/earnings_screen.dart';
import 'package:cafeteria_business/mainScreens/history_screen.dart';
import 'package:cafeteria_business/mainScreens/home.dart';
import 'package:cafeteria_business/mainScreens/new_orders_screen.dart';
import 'package:flutter/material.dart';


class MyDrawer extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: Colors.teal[900],
            padding: const EdgeInsets.only(top: 25,bottom: 10),
            child: Column(
              children:  [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(68)),
                  elevation: 5,
                  child: Padding(padding: EdgeInsets.all(1.0),
                    child: Container(
                      height: 136,
                      width: 136,
                      child: CircleAvatar(backgroundImage: NetworkImage(
                        sharedPreferences!.getString("photoUrl")!
                      ),),
                    ),
                  
                  ),
                  
                ),
                const SizedBox(height: 15,),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 12,),
          //drawer body
          Container(
            color: Colors.teal[900],
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              children: [
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 1.5,
                ),
                ListTile(
                  tileColor: Colors.teal[900],
                  leading: const Icon(Icons.home_outlined,color: Colors.white),
                  title: const Text("Home",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>const HomeScreen()));
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 1.5,
                ),
                ListTile(
                  tileColor: Colors.teal[900],
                  leading: const Icon(Icons.reorder,color: Colors.white,),
                  title: const Text("New Orders",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> NewOrdersScreen()));
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 1.5,
                ),
                ListTile(
                  tileColor: Colors.teal[900],
                  leading: const Icon(Icons.access_time,color: Colors.white,),
                  title: const Text("History",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 1.5,
                ),
                ListTile(
                  tileColor: Colors.teal[900],
                  leading: const Icon(Icons.monetization_on_sharp,color: Colors.white,),
                  title: const Text("My Earnings",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const EarningsScreen()));
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 1.5,
                ),

                ListTile(
                  tileColor: Colors.teal[900],
                  leading: const Icon(Icons.logout,color: Colors.white,),
                  title: const Text("Log Out",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  onTap: (){
                    firebaseAuth.signOut().then((value){
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>const MyLogin()));
                    });

                  },
                ),

                // Divider(
                //   height: 10,
                //   color: Colors.teal[900],
                //   thickness: 1.5,
                // ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
