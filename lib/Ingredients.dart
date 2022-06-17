class Ingredients {
  late int ingID;
  late String ingName;
  late String ingTypeID;
  late String ingImage;
  late String ingTypeName;


  Ingredients(this.ingID, this.ingName, this.ingTypeID,this.ingImage,this.ingTypeName);

      factory Ingredients.fromJson(Map<String,dynamic> json){
        print("Ingredients.fromJson çalıştı");
        var a = Ingredients(int.parse(json["ingID"] as String), json["ingName"] as String,json["ingTypeID"] as String, json["ingImage"] as String,json["ingTypeName"] as String) ;
        print(a.ingName);
        return a;
          }
}