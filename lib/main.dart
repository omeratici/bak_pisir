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
  var aktifKullanici;
  String _errorMessage = '';

  Users parseUsersCevap(String cevap){
    var jsonVeri = json.decode(cevap);
    var user =Users(0, "xxx", "0", "0");
    if(jsonVeri["success"] as int==1){
      var userCevap = UsersCevap.fromJson(jsonVeri);
      List<Users> userList =userCevap.userList;
      user = userList[0];
    }
    return user;
  }

  Future<Users> userGet (String a,String b) async {
    var url =Uri.parse("http://213.14.130.80/bakpisir/Usersget3.php");
    var veri = {"userName":a, "password":b};
    var cevap = await http.post(url,body: veri);

    return parseUsersCevap(cevap.body);
  }
  Future<void> kullan(String a,String b) async {
    var aktifKullanici = await userGet(a,b);
    if(aktifKullanici.userId != 0){
      print(aktifKullanici.userId);
      print(aktifKullanici.userName);
      Navigator.push(context, MaterialPageRoute(builder: (context) => anaSAyfa()));
    }else {
      //Todo Snackbar yap
    }

  }
@override
  void initState() {

    super.initState();


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
                controller: tfKullaniciAdi,
                onChanged: (val){
                  validateEmail(val);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                controller: tfKSifre,
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
                      kullan(tfKullaniciAdi.text,tfKSifre.text);



                    }, child: Text("Giriş Yap")),
                    ElevatedButton(onPressed: (){

                      //dolabim.dart ı görebilmek için geçiçi olarak değiştirildi.
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => uyeOl()));
                      Navigator.push(context, MaterialPageRoute(builder: (context) => uyeOl()));
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
