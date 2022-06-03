import 'Ingredients.dart';

class IngredientsCevap {
  late int success;
  late List<Ingredients> IngredientsList;

  IngredientsCevap(this.success, this.IngredientsList);

  factory IngredientsCevap.fromJson(Map<String, dynamic> json){
    var jsonArray =json["Ingredients"] as List;
    List<Ingredients> IngredientsList = jsonArray.map((jaysonArrayNesnesi) => Ingredients.fromJson(jaysonArrayNesnesi)).toList();
    return IngredientsCevap(json["success"] as int, IngredientsList);

  }
}
