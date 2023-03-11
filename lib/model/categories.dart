import 'package:cloud_firestore/cloud_firestore.dart';

class Categories
{
  String? menuId;
  String? sellerUID;
  String? menuTitle;
  String? menuInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;


  Categories({
    this.menuId,
    this.sellerUID,
    this.menuTitle,
    this.menuInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,
});

  Categories.fromJson(Map<String,dynamic> json)
  {
    menuId=json["menuID"];

    sellerUID=json["sellerUID"];
    menuTitle=json["menuTitle"];
    menuInfo=json["menuInfo"];
    publishedDate=json["publishedDate"];
    thumbnailUrl=json["thumbnailUrl"];
    status=json["status"];
  }


Map<String,dynamic> toJson()
{
  final Map<String,dynamic>data = Map<String,dynamic>();
  data["menuID"]=menuId;
  data["sellerUID"]=sellerUID;
  data["menuTitle"]=menuTitle;
  data["menuInfo"]=menuInfo;
  data["publishedDate"]=publishedDate;
  data["thumbnailUrl"]=thumbnailUrl;
  data["status"]=status;

  return data;
}


}
