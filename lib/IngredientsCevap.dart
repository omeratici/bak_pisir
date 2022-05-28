import 'package:bak_pisir/Ingredients.dart';

class IngredientsCevap {
  late int success;
  late List<Ingredients> typesList;

  IngredientsCevap(this.success, this.typesList);

  factory IngredientsCevap.fromJson(Map<String, dynamic> json){
    var jsonArray = json["Ingredients"] as List;
    List<Ingredients> typesList = jsonArray.map((jaysonArrayNesnesi) =>
        Ingredients.fromJson(jaysonArrayNesnesi)).toList();
    return IngredientsCevap(json["success"] as int, typesList);
  }
}
