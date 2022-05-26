import 'package:bak_pisir/Foodtypes.dart';

class FoodtypesCevap {
  late int success;
  late List<Foodtypes> typesList;

  FoodtypesCevap(this.success, this.typesList);

  factory FoodtypesCevap.fromJson(Map<String,dynamic> json){
    var jsonArray =json["Foodtypes"] as List;
    List<Foodtypes> typesList = jsonArray.map((jaysonArrayNesnesi) => Foodtypes.fromJson(jaysonArrayNesnesi)).toList();
    return FoodtypesCevap(json["success"] as int, typesList);


  }


}