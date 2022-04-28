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
      key:scaffoldKey,
      appBar: AppBar(
        title: Text("Bak Pişir - Ana Sayfa"),
      ),
      body:  ListView.builder(
        itemCount: yemekler.length,
        itemBuilder: (context,index){
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => urunListe()));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Text(yemekler[index]),
                    ],
                  ),
                ),
              ),
            ),
          );

        }
      ),

    );
  }
}
