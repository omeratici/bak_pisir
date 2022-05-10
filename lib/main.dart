import 'dart:ffi';

import 'package:bak_pisir/anaSayfa.dart';
import 'package:bak_pisir/sifremiUnuttum.dart';
import 'package:bak_pisir/uyeOl.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Users.dart';
import 'UsersCevap.dart';
import 'dolabim.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  GirisEkrani(),
    );
  }
}

class GirisEkrani extends StatefulWidget {


  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  var tfKullaniciAdi = TextEditingController();
  var tfKSifre = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String _errorMessage = '';

  List<Users> parseUsersCevap(String cevap){
    var jsonVeri = json.decode(cevap);
    var userCevap = UsersCevap.fromJson(jsonVeri);
    List<Users> userList =userCevap.userList;
    return userList;
  }

  Future<List<Users>> allUsers () async {
    var url =Uri.parse("http://213.14.130.80/bakpisir/Usersget.php");
    var cevap = await http.get(url);

    return parseUsersCevap(cevap.body);
  }
  Future<void> kullan() async {
    var liste = await allUsers();
    for(var k in liste){
      print(k.userId);
      print(k.userName);
    }


  }
@override
  void initState() {

    super.initState();
    kullan();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key:scaffoldKey,
      appBar: AppBar(
        title: Text("Bak Pişir - Giriş"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (val){
                  validateEmail(val);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(labelText: 'Şifre'),
                obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_errorMessage, style: TextStyle(color: Colors.red),),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => anaSAyfa()));

                    }, child: Text("Giriş Yap")),
                    ElevatedButton(onPressed: (){

                      //dolabim.dart ı görebilmek için geçiçi olarak değiştirildi.
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => uyeOl()));
                      Navigator.push(context, MaterialPageRoute(builder: (context) => dolabim()));
                    }, child: Text("Üye Ol")),
                  ]
                ),
              ),

              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => sifremiUnuttum()));
              }, child: Text("Şifremi Unuttum"))

            ],
          ),
        ),
      ),

    );
  }
  void validateEmail(String val) {
    if(val.isEmpty){
      setState(() {
        _errorMessage = "Email adresini boş geçemezsiniz !";
      });
    }else if(!EmailValidator.validate(val, true)){
      setState(() {
        _errorMessage = "Geçersiz Email Adresi";
      });
    }else{
      setState(() {

        _errorMessage = "";
      });
    }
  }
}
