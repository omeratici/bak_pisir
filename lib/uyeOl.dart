import 'dart:convert';

import 'package:bak_pisir/mailOnay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'Users.dart';

class uyeOl extends StatefulWidget {
  const uyeOl({Key? key}) : super(key: key);

  @override
  State<uyeOl> createState() => _uyeOlState();
}

class _uyeOlState extends State<uyeOl> {
  var tfKullaniciAdi = TextEditingController();
  var tfemail = TextEditingController();
  var tfKSifre = TextEditingController();
  var tfKSifreTekrar = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> insertUser (String userName,String password, String email ) async {
    var url = Uri.parse("http://213.14.130.80/bakpisir/insert_user.php");
    var veri = {"userName": userName, "password": password, "email": email,"userRole":"0"};
    var cevap = await http.post(url, body: veri);
    var jsonVeri = json.decode(cevap.body);
    if(jsonVeri["success"] as int==1){
      Navigator.push(context, MaterialPageRoute(builder: (context) => mailOnay()));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt Başarısız Tekrar Deneyin")),
      );
    }
    print(cevap.body.toString());

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:scaffoldKey,
      appBar: AppBar(
        title: Text("Bak Pişir - Üye Ol"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: tfKullaniciAdi,
                decoration: InputDecoration(
                  hintText: "Kullanıcı Adı",
                ),
              ),
              TextField(
                controller: tfemail,
                decoration: InputDecoration(
                  hintText: "e-mail",
                ),
              ),
              TextField(
                obscureText: true,
                controller: tfKSifre,
                decoration: InputDecoration(
                  hintText: "Şifre",
                ),
              ),
              TextField(
                obscureText: true,
                controller: tfKSifreTekrar,
                decoration: InputDecoration(
                  hintText: "Şifre Tekrar",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(onPressed: (){
                  insertUser(tfKullaniciAdi.text, tfKSifre.text, tfemail.text);



                }, child: Text("Üye Ol")),
              ),



            ],
          ),
        ),
      ),

    );
  }
}

