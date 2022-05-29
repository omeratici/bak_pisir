import 'package:bak_pisir/Ingredients.dart';

class IngredientsCevap {
  late int success;
  late List<Ingredients> ingredientsList;

  IngredientsCevap(this.success, this.ingredientsList);

  factory IngredientsCevap.fromJson(Map<String, dynamic> json){
    var jsonArray =json["Ingredients"] as List;
    List<Ingredients> ingredientsList = jsonArray.map((jaysonArrayNesnesi) => Ingredients.fromJson(jaysonArrayNesnesi)).toList();
    return IngredientsCevap(json["success"] as int, ingredientsList);

  }
}
