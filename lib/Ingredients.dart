class Ingredients {
  late int ingID;
  late String ingName;
  late String unitID;
  late String quantity;
  late int userID;

  Ingredients(this.ingID, this.ingName, this.unitID,this.quantity,this.userID);

      factory Ingredients.fromJson(Map<String,dynamic> json){
        print("Ingredients.fromJson çalıştı");
        var a = Ingredients(int.parse(json["ingID"] as String), json["ingName"] as String,json["unitID"] as String, json["quantity"] as String, int.parse(json["userID"] as String)) ;
        print(a.ingName);
        return a;
          }
}