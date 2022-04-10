import 'package:bak_pisir/sifremiUnuttum.dart';
import 'package:bak_pisir/uyeOl.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

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


                    }, child: Text("Giriş Yap")),
                    ElevatedButton(onPressed: (){
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
