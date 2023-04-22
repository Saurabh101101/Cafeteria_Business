import 'package:cafeteria_business/global/global.dart';
import 'package:cafeteria_business/model/categories.dart';
import 'package:cafeteria_business/model/items.dart';
import 'package:cafeteria_business/uploadScreens/items_upload_screen.dart';
import 'package:cafeteria_business/widgets/info_design.dart';
import 'package:cafeteria_business/widgets/items_design.dart';
import 'package:cafeteria_business/widgets/my_drawer.dart';
import 'package:cafeteria_business/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ItemsScreen extends StatefulWidget {
  final Categories? model;
  ItemsScreen({ this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(constraints: BoxConstraints.expand(),
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
              Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsUploadScreen(model: widget.model)));
            }, icon: const Icon(Icons.library_add))
          ],
        ),
        body:  CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ListTile(
                title: Text("My "+widget.model!.menuTitle.toString() +" Items ",textAlign: TextAlign.center,style: TextStyle(
                  color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold
                ),),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.
                collection("sellers").doc(sharedPreferences!.getString("uid"))
                    .collection("categories").doc(widget.model!.menuId).collection("items").snapshots(),
                builder: (context,snapshot) {
                  return !snapshot.hasData
                      ? SliverToBoxAdapter(
                    child: Center(
                      child: circularProgress(),
                    ),
                  )
                      :SliverStaggeredGrid.countBuilder(crossAxisCount: 2, staggeredTileBuilder: (c)=>StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      Items model =Items.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String,dynamic>,
                      );
                      return ItemsDesignWidget(
                        model: model,
                        context: context,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                }
            )

          ],
        ),
      ),
    );
  }
}
