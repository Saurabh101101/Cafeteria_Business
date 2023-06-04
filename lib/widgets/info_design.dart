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

  deleteMenu(String menuId) {
    FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid")).collection("categories").doc(
        menuId).delete();

    Fluttertoast.showToast(
        msg: "The selected Category has been deleted successfully !");
  }

  Future <void> showAlertDialog()async {
    return showDialog<void>(context: context,barrierDismissible: false,builder:
    (BuildContext context)
    {
      return AlertDialog(
        title: Text("Confirmation"),
        content: Text("Do you really want to delete entire category?"),
        actions: <Widget>[
          ElevatedButton(style:ElevatedButton.styleFrom(primary:Colors.teal),onPressed: () {
        Navigator.of(context).pop();
      }, child: Text("Cancel")),
          ElevatedButton(style:ElevatedButton.styleFrom(primary:Colors.teal),onPressed: () {
            deleteMenu(widget.model!.menuId!);
            Navigator.of(context).pop();
          }, child: Text("Yes")),
        ],
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (c) => ItemsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [

            CircleAvatar(
              backgroundImage: NetworkImage(widget.model!.thumbnailUrl!),
              radius: MediaQuery
                  .of(context)
                  .size
                  .width * 0.15,),
            const SizedBox(height: 3,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.model!.menuTitle!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Train",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(onPressed: () {
//delete menu
                  showAlertDialog();
                },
                  icon: const Icon(Icons.delete_sweep, size: 25,),
                  color: Colors.red,)
              ],
            ),

          ],
        ),
      ),
    );
  }
}





