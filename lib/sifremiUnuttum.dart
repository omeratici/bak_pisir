import 'package:flutter/material.dart';

class sifremiUnuttum extends StatefulWidget {
  const sifremiUnuttum({Key? key}) : super(key: key);

  @override
  State<sifremiUnuttum> createState() => _sifremiUnuttumState();
}

class _sifremiUnuttumState extends State<sifremiUnuttum> {
  var tfemail = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:scaffoldKey,
      appBar: AppBar(
        title: Text("Bak Pişir - Şifremi Unuttum"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              TextField(
                controller: tfemail,
                decoration: InputDecoration(
                  hintText: "e-mail Adresinizi Giriniz",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(onPressed: (){


                }, child: Text("Yeni Şifre Gönder")),
              ),

            ],
          ),
        ),
      ),

    );
  }
}
