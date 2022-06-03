class MyIngredients {
  late int myingID;
  late int ingID;
  late String ingName;
  late String unitID;
  late String quantity;
  late int userID;

  MyIngredients(this.myingID,this.ingID, this.ingName, this.unitID,this.quantity,this.userID);

      factory MyIngredients.fromJson(Map<String,dynamic> json){
        print("MyIngredients.fromJson çalıştı");
        var a = MyIngredients(int.parse(json["myingID"] as String),int.parse(json["ingID"] as String), json["ingName"] as String,json["unitID"] as String, json["quantity"] as String, int.parse(json["userID"] as String)) ;
        print(a.ingName);
        return a;
          }
}