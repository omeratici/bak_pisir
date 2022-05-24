import 'package:bak_pisir/tarifSayfasi.dart';
import 'package:flutter/material.dart';

import 'Widgets/MyDrawer.dart';

class urunListe extends StatefulWidget {
  const urunListe({Key? key}) : super(key: key);

  @override
  State<urunListe> createState() => _urunListeState();
}

class _urunListeState extends State<urunListe> {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var urunler = ["Ürün 1","Ürün 2", "Ürün 3","Ürün 4"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bak Pişir - Ürün Liste"),
      ),
      drawer: MyDrawer(),
      key:scaffoldKey,

      body:  ListView.builder(
          itemCount: urunler.length,
          itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => tarifSayfasi()));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Text(urunler[index]),
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