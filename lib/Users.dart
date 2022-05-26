import 'dart:convert';
import 'package:bak_pisir/UsersCevap.dart';
import 'package:http/http.dart' as http;
class Users {
  late int userId;
  late String userName;
  late String userRole;
  late String pinCode;
  late String email;


  Users(this.userId, this.userName, this.userRole, this.pinCode,this.email);

  factory Users.fromJson(Map<String,dynamic> json){
    return Users(int.parse(json["userId"] as String), json["userName"] as String,json["userRole"] as String,json["pinCode"] as String,json["email"] as String);
  }




}