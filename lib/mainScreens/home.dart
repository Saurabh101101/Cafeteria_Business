
import 'package:cafeteria_business/authentication/login.dart';
import 'package:cafeteria_business/global/global.dart';
import 'package:cafeteria_business/model/categories.dart';
import 'package:cafeteria_business/uploadScreens/category_upload.dart';
import 'package:cafeteria_business/widgets/info_design.dart';
import 'package:cafeteria_business/widgets/my_drawer.dart';
import 'package:cafeteria_business/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>false,
      child: Container(constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover,) ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: MyDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.teal[900]?.withOpacity(0.85),
            title: Text("Welcome "+sharedPreferences!.getString("name")!,),
            centerTitle: true,
            automaticallyImplyLeading: true,
            actions: [
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=>const CategoryUploadScreen()));
              }, icon: const Icon(Icons.post_add_sharp))
            ],
          ),
          body: CustomScrollView(
            slivers: [
             const SliverToBoxAdapter(
                child: ListTile(
                  title: Text("Categories",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.
                collection("sellers").doc(sharedPreferences!.getString("uid"))
                .collection("categories").snapshots(),
                builder: (context,snapshot) {
                  return !snapshot.hasData
                      ? SliverToBoxAdapter(
                    child: Center(
                      child: circularProgress(),
                    ),
                  )
                      :SliverStaggeredGrid.countBuilder(crossAxisCount: 2, staggeredTileBuilder: (c)=>StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      Categories model =Categories.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String,dynamic>,
                      );
                      return InfoDesignWidget(
                        model: model,
                        context: context,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                }
                )
            ]

    ),
        ),
      ),
    );
  }
}
