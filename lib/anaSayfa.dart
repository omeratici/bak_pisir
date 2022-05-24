import 'package:bak_pisir/Widgets/MyDrawer.dart';
import 'package:bak_pisir/urunListe.dart';
import 'package:flutter/material.dart';

class anaSAyfa extends StatefulWidget {
  const anaSAyfa({Key? key}) : super(key: key);

  @override
  State<anaSAyfa> createState() => _anaSAyfaState();
}

class _anaSAyfaState extends State<anaSAyfa> {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var yemekler = ["ÇORBALAR","SALATALAR", "ET YEMEKLERİ","SEBZE YEMEKLERİ"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bak Pişir - Ana Sayfa"),
      ),
      drawer: MyDrawer(),
      key:scaffoldKey,

      body:  GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2/1),
          itemCount: yemekler.length,
          itemBuilder: (context,index){
            return Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(yemekler[index])
                ],
              ),
            );
          }

      ),

    );
  }
}
