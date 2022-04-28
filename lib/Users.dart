import 'dart:convert';
import 'package:bak_pisir/UsersCevap.dart';
import 'package:http/http.dart' as http;
class Users {
  late int userId;
  late String userName;
  late String userRole;
  late String pinCode;


  Users(this.userId, this.userName, this.userRole, this.pinCode);

  factory Users.fromJson(Map<String,dynamic> json){
    print("Users factory içi");
    return Users(int.parse(json["userId"] as String), json["userName"] as String,json["userRole"] as String,json["pinCode"] as String );
  }




}