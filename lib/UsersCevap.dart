import 'dart:convert';

import 'package:bak_pisir/Users.dart';

class UsersCevap {
  late int success;
  late List<Users> userList;

  UsersCevap(this.success, this.userList);
  factory UsersCevap.fromJson(Map<String,dynamic> json){
    print("UsersCevap factory içi");
    var jsonArray =json["Users"] as List;
    List<Users> userList = jsonArray.map((jaysonArrayNesnesi) => Users.fromJson(jaysonArrayNesnesi)).toList();
        return UsersCevap(json["success"] as int, userList);


  }


}