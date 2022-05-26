import 'dart:convert';
import 'package:http/http.dart' as http;
import 'FoodtypesCevap.dart';

class Foodtypes {
  late int typeId;
  late String typeName;
  late String typeImage;

  Foodtypes(this.typeId, this.typeName, this.typeImage);

  factory Foodtypes.fromJson(Map<String,dynamic> json){
    return Foodtypes(int.parse(json["typeId"] as String), json["typeName"] as String,json["typeImage"] as String);
  }

}