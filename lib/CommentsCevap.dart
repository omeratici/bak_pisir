import 'package:bak_pisir/Comments.dart';

class CommentsCevap {
  late int success;
  late List<Comments> commentsList;

  CommentsCevap(this.success, this.commentsList);

  factory CommentsCevap.fromJson(Map<String,dynamic> json){
    var jsonArray =json["Comments"] as List;
    List<Comments> commentsList = jsonArray.map((jaysonArrayNesnesi) => Comments.fromJson(jaysonArrayNesnesi)).toList();
    return CommentsCevap(json["success"] as int, commentsList);


  }


}