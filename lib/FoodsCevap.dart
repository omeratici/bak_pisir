

import 'Foods.dart';

class FoodsCevap {
  late int success;
  late List<Foods> foodList;

  FoodsCevap(this.success, this.foodList);

  factory FoodsCevap.fromJson(Map<String,dynamic> json){
    var jsonArray =json["Foods"] as List;
    List<Foods> foodList = jsonArray.map((jaysonArrayNesnesi) => Foods.fromJson(jaysonArrayNesnesi)).toList();
    return FoodsCevap(json["success"] as int, foodList);


  }


}