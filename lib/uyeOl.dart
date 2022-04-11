import 'package:bak_pisir/mailOnay.dart';
import 'package:flutter/material.dart';

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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => mailOnay()));


                }, child: Text("Üye Ol")),
              ),



            ],
          ),
        ),
      ),

    );
  }
}

