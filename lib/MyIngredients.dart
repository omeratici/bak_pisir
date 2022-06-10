class MyIngredients {
  late int myingID;
  late int ingID;
  late String ingName;
  late String unitID;
  late String quantity;
  late int userID;
  late String ingImage;
  late String ingType;

  MyIngredients(this.myingID,this.ingID, this.ingName, this.unitID,this.quantity,this.userID,this.ingImage,this.ingType);

      factory MyIngredients.fromJson(Map<String,dynamic> json){
        print("MyIngredients.fromJson çalıştı");
        var a = MyIngredients(int.parse(json["myingID"] as String),int.parse(json["ingID"] as String), json["ingName"] as String,json["unitID"] as String, json["quantity"] as String, int.parse(json["userID"] as String), json["ingImage"] as String,json["ingType"] as String) ;
        print(a.ingName);
        return a;
          }
}