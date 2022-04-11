import 'package:flutter/material.dart';

class mailOnay extends StatefulWidget {
  const mailOnay({Key? key}) : super(key: key);

  @override
  State<mailOnay> createState() => _mailOnayState();
}

class _mailOnayState extends State<mailOnay> {
  var tfonayKodu = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:scaffoldKey,
      appBar: AppBar(
        title: Text("Bak Pişir - Mail Onay"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              TextFormField(
                controller: tfonayKodu,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Onay Kodu'),
                onChanged: (val){

                },
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(onPressed: (){


                }, child: Text("Gönder")),
              ),

            ],
          ),
        ),
      ),

    );
  }
}
