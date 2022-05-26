import 'dart:convert';

import 'package:bak_pisir/Foodtypes.dart';
import 'package:bak_pisir/Widgets/MyDrawer.dart';
import 'package:bak_pisir/urunListe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'FoodtypesCevap.dart';

class anaSAyfa extends StatefulWidget {
  const anaSAyfa({Key? key}) : super(key: key);

  @override
  State<anaSAyfa> createState() => _anaSAyfaState();
}

class _anaSAyfaState extends State<anaSAyfa> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Foodtypes>typesList=[];

  List<Foodtypes> parsetypesCevap(String cevap){
    var jsonVeri = json.decode(cevap);

    if(jsonVeri["success"] as int==1){
      var typesCevap = FoodtypesCevap.fromJson(jsonVeri);
      typesList =typesCevap.typesList;
      setState(() {

      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Yemek Türleri Yüklenemedi Tekrar Deneyin")),
      );
    }
    return typesList;
  }

  Future<List<Foodtypes>> typesGet () async {
    print("typeGet çalıştı");
    var url =Uri.parse("http://213.14.130.80/bakpisir/FoodtypesGet.php");
    var cevap = await http.get(url);
    print(cevap.body);
    return parsetypesCevap(cevap.body);
  }

@override
  void initState() {
    super.initState();
    typesGet();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bak Pişir - Ana Sayfa"),
      ),
      drawer: MyDrawer(),
      key:scaffoldKey,

      body:  GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: typesList.length,
          itemBuilder: (context,index){
            return Container(
                alignment: Alignment.center,

                child: Text(typesList[index].typeName),
            decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(15)),
            );
          },

      ),

    );
  }
}
