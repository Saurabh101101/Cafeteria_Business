import 'package:cafeteria_business/mainScreens/item_details_screen.dart';
import 'package:cafeteria_business/mainScreens/items_screen.dart';
import 'package:cafeteria_business/model/categories.dart';
import 'package:cafeteria_business/model/items.dart';
import 'package:cafeteria_business/uploadScreens/items_upload_screen.dart';
import 'package:flutter/material.dart';



class ItemsDesignWidget extends StatefulWidget
{
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model, this.context});

  @override
  _ItemsDesignWidgetState createState() => _ItemsDesignWidgetState();
}



class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

        Navigator.push(context, MaterialPageRoute(builder: (c)=>ItemDetailsScreen(model:widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child:Container(
            height: MediaQuery.of(context).size.height*0.35,
            width: MediaQuery.of(context).size.width*0.48,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:Radius.circular(25) ,
                  topRight:Radius.zero ,
                  bottomLeft:Radius.zero,
                  bottomRight: Radius.circular(25),
                )
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(backgroundImage: NetworkImage( widget.model!.thumbnailUrl!),radius: MediaQuery.of(context).size.width*0.17,),
                ),
                const SizedBox(height: 8,),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.model!.title!,style:TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                      )
                      ),
                      SizedBox(width:10 ),
                    ],
                  ),),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 8,right: 8,bottom:4,top: 4),
                  child: Text(widget.model!.shortInfo!,style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,color: Colors.cyan,
                  ),),
                ),
                ],
            )
        ),
      ),
    );
  }
}
