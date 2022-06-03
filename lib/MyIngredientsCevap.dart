import 'package:bak_pisir/MyIngredients.dart';

class MyIngredientsCevap {
  late int success;
  late List<MyIngredients> MyingredientsList;

  MyIngredientsCevap(this.success, this.MyingredientsList);

  factory MyIngredientsCevap.fromJson(Map<String, dynamic> json){
    var jsonArray =json["MyIngredients"] as List;
    List<MyIngredients> MyIngredientsList = jsonArray.map((jaysonArrayNesnesi) => MyIngredients.fromJson(jaysonArrayNesnesi)).toList();
    return MyIngredientsCevap(json["success"] as int, MyIngredientsList);

  }
}
