import 'package:cafeteria_business/global/global.dart';
import 'package:cafeteria_business/mainScreens/items_screen.dart';
import 'package:cafeteria_business/model/categories.dart';
import 'package:cafeteria_business/uploadScreens/items_upload_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class InfoDesignWidget extends StatefulWidget
{
  Categories? model;
  BuildContext? context;

  InfoDesignWidget({this.model, this.context});

  @override
  _InfoDesignWidgetState createState() => _InfoDesignWidgetState();
}



class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  
  deleteMenu(String menuId)
  {
    FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid")).collection("categories").doc(menuId).delete();

    Fluttertoast.showToast(msg: "The selected Category has been deleted successfully !");
  }
  
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (c)=>ItemsScreen(model:widget.model)));
      },
      splashColor: Colors.teal[900],
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          color: Colors.grey[400],
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [

              Image.network(
                  widget.model!.thumbnailUrl!,
                  height: 200.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.model!.menuTitle!,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontSize: 20,
                      fontFamily: "Train",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(onPressed: (){
                    //delete menu
                    deleteMenu(widget.model!.menuId!);
                  }, icon: const Icon(Icons.delete_sweep),color: Colors.teal[900])
                ],
              ),
              Divider(
                height: 8,
                thickness: 3,
                color: Colors.teal[900],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
