class Comments {
  late int commentID;
  late int foodID;
  late String comment;
  late double point;
  late int userID;
  late String userName;

  Comments(this.commentID, this.foodID, this.comment, this.point,this.userID,this.userName);

  factory Comments.fromJson(Map<String,dynamic> json){
    return Comments(int.parse(json["commentID"] as String), int.parse(json["foodID"] as String),json["comment"] as String,double.parse(json["point"] as String),int.parse(json["userID"] as String),json["userName"] as String);
  }
}