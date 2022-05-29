import 'dart:convert';

import 'package:bak_pisir/mailOnay.dart';
import 'package:bak_pisir/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'UsersCevap.dart';
import 'Users.dart';

class uyeOl extends StatefulWidget {
  const uyeOl({Key? key}) : super(key: key);

  @override
  State<uyeOl> createState() => _uyeOlState();
}

class _uyeOlState extends State<uyeOl> {
  bool _isPasswordValidate = false;
  bool _isMailValidate = false;
  bool _isUserNameValidate = false;
  bool _isVisible = false;
  var tfKullaniciAdi = TextEditingController();
  var tfemail = TextEditingController();
  var tfKSifre = TextEditingController();
  var tfKSifreTekrar = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String _errorMessage = '';

  Future<void> insertUser(
      String userName, String password, String email) async {
    var url = Uri.parse("http://213.14.130.80/bakpisir/insert_user.php");
    var veri = {
      "userName": userName,
      "password": password,
      "email": email,
      "userRole": "0"
    };
    var cevap = await http.post(url, body: veri);
    var jsonVeri = json.decode(cevap.body);
    if (jsonVeri["success"] as int == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => mailOnay()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt Başarısız Tekrar Deneyin")),
      );
    }
    print(cevap.body.toString());
  }

  @override
  Widget build(BuildContext context) {
    {
      return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/kayit.png'), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 100),
              child: Text(
                "Hesap\nOluştur",
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Kullanıcı Adı',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                      controller: tfKullaniciAdi,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlutterPwValidator(
                        controller: tfKullaniciAdi,
                        minLength: 6,
                        width: 400,
                        height: 40,
                        onSuccess: () {
                          print("oldu");
                          _isUserNameValidate = true;
                        },
                        onFail: () {
                          print("olmadı");
                          _isUserNameValidate = false;
                        },
                      ),
                    ),
                    TextFormField(
                      controller: tfemail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                      onChanged: (val) {
                        validateEmail(val);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _errorMessage,
                        style: _isMailValidate
                            ? TextStyle(color: Colors.green)
                            : TextStyle(color: Colors.red),
                      ),
                    ),
                    TextFormField(
                      obscureText: !_isVisible,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isVisible = !_isVisible;
                              });
                            },
                            icon: _isVisible
                                ? Icon(Icons.visibility, color: Colors.white)
                                : Icon(Icons.visibility_off,
                                    color: Colors.grey)),
                        hintText: 'Şifre',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                      controller: tfKSifre,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: FlutterPwValidator(
                        controller: tfKSifre,
                        minLength: 6,
                        uppercaseCharCount: 2,
                        numericCharCount: 3,
                        specialCharCount: 1,
                        width: 400,
                        height: 120,
                        onSuccess: () {
                          print("oldu");
                          _isPasswordValidate = true;
                        },
                        onFail: () {
                          print("olmadı");
                          _isPasswordValidate = false;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kayıt Ol",
                          style: TextStyle(
                            color: Colors.white,
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
                              insertUser(tfKullaniciAdi.text, tfKSifre.text,
                                  tfemail.text);
                            },
                            icon: Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      );
    }

    /*  return Scaffold(
      key:scaffoldKey,
      appBar: AppBar(
        title: Text("Bak Pişir - Üye Ol"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: tfKullaniciAdi,
                    decoration: InputDecoration(
                      hintText: "Kullanıcı Adı",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlutterPwValidator(
                    controller: tfKullaniciAdi,
                    minLength: 6,
                    width: 400,
                    height: 40,
                    onSuccess: (){print("oldu");
                    _isUserNameValidate = true;},
                    onFail: (){print("olmadı");
                    _isUserNameValidate = false;},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: tfemail,
                    decoration: InputDecoration(
                      hintText: "e-mail",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: (val){
                      validateEmail(val);

                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_errorMessage,
                    style:_isMailValidate ? TextStyle(color:Colors.green): TextStyle(color:Colors.red),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: !_isVisible,
                    controller: tfKSifre,
                    decoration: InputDecoration(
                      hintText: "Şifre",
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState((){_isVisible= !_isVisible;});
                        }
                          ,
                          icon: _isVisible ? Icon(Icons.visibility, color: Colors.black): Icon(Icons.visibility_off, color: Colors.grey)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlutterPwValidator(
                    controller: tfKSifre,
                    minLength: 6,
                    uppercaseCharCount: 2,
                    numericCharCount: 3,
                    specialCharCount: 1,
                    width: 400,
                    height: 150,
                    onSuccess: (){print("oldu");
                    _isPasswordValidate = true;},
                    onFail: (){print("olmadı");
                    _isPasswordValidate = false;},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(onPressed: (){
                    if(_isMailValidate && _isPasswordValidate &&_isUserNameValidate){
                      insertUser(tfKullaniciAdi.text, tfKSifre.text, tfemail.text);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Kullanıcı adı, Şifre mail adresi kriterleri karşılamalıdır.")),
                      );
                    }
                  }, child: Text("Üye Ol")),
                ),

              ],
            ),
          ),
        ),
      ),

    );
  }

  
*/
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      _isMailValidate = false;
      setState(() {
        _errorMessage = "Email adresini boş geçemezsiniz !";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Geçersiz Email Adresi";
      });
    } else if (EmailValidator.validate(val, true)) {
      _isMailValidate = true;
      setState(() {
        _errorMessage = "Geçerli Mail Adresi";
      });
    } else {
      _isMailValidate = false;
      setState(() {
        _errorMessage = "";
      });
    }
  }
}
