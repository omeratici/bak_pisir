class Foods {
  late int foodID ;
  late String recipe ;
  late String foodImage ;
  late String typeId ;
  late String foodName ;
  late int authorId;
  late String authorName ;
  late String rating;



  Foods(this.foodID, this.recipe, this.foodImage, this.typeId,this.foodName,this.authorId,this.authorName,this.rating);

  factory Foods.fromJson(Map<String,dynamic> json){
    return Foods(int.parse(json["foodID"] as String), json["recipe"] as String,json["foodImage"] as String,json["typeId"] as String,json["foodName"] as String,int.parse(json["authorId"] as String),json["userName"] as String, json["rating"] as String);
  }




}