//import 'dart:ffi';
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
      home: GirisEkrani(),
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

  Users parseUsersCevap(String cevap) {
    var jsonVeri = json.decode(cevap);
    var user = Users(0, "xx", "0", "0", "xx");
    if (jsonVeri["success"] as int == 1) {
      var userCevap = UsersCevap.fromJson(jsonVeri);
      List<Users> userList = userCevap.userList;
      user = userList[0];
    }
    return user;
  }

  Future<Users> userGet(String a, String b) async {
    var url = Uri.parse("http://213.14.130.80/bakpisir/Usersget3.php");
    var veri = {"userName": a, "password": b};
    var cevap = await http.post(url, body: veri);

    return parseUsersCevap(cevap.body);
  }

  Future<void> login(String a, String b) async {
    var aktifKullanici = await userGet(a, b);
    if (aktifKullanici.userId != 0) {
      print(aktifKullanici.userId);
      print(aktifKullanici.userName);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => anaSAyfa(aktifKullnaici:aktifKullanici)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kullanıcı Adi veya Şifre Hatalı")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/giris.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            padding: EdgeInsets.only(left: 35, top: 130),
            child: Text(
              "Hoşgeldiniz",
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                  right: 35,
                  left: 35),
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: Colors.grey.shade100,
                        filled: true),
                    controller: tfKullaniciAdi,
                    onChanged: (val) {
                      validateEmail(val);
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        hintText: 'Şifre',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: Colors.grey.shade100,
                        filled: true),
                    obscureText: true,
                    controller: tfKSifre,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Giriş Yap",
                        style: TextStyle(
                          color: Color.fromRGBO(175, 68, 72, 1),
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color.fromRGBO(175, 68, 72, 1),
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            login(tfKullaniciAdi.text, tfKSifre.text);
                          },
                          icon: Icon(Icons.arrow_forward),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => uyeOl()));
                          },
                          child: Text(
                            "Kayıt Ol",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              color: Color.fromRGBO(175, 68, 72, 1),
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => sifremiUnuttum()));
                          },
                          child: Text(
                            "Şifremi Unuttum",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              color: Color.fromRGBO(175, 68, 72, 1),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email adresini boş geçemezsiniz !";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Geçersiz Email Adresi";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }
}
