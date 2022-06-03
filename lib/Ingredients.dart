class Ingredients {
  late int ingID;
  late String ingName;
  late String ingType;
  late String ingImage;


  Ingredients(this.ingID, this.ingName, this.ingType,this.ingImage);

      factory Ingredients.fromJson(Map<String,dynamic> json){
        print("Ingredients.fromJson çalıştı");
        var a = Ingredients(int.parse(json["ingID"] as String), json["ingName"] as String,json["ingType"] as String, json["ingImage"]) ;
        print(a.ingName);
        return a;
          }
}