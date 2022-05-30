import 'dart:convert';

import 'package:bak_pisir/Foodtypes.dart';
import 'package:bak_pisir/Widgets/MyDrawer.dart';
import 'package:bak_pisir/assets/db_icons.dart';
import 'package:bak_pisir/urunListe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'FoodtypesCevap.dart';
import 'Users.dart';

class anaSAyfa extends StatefulWidget {
  Users aktifKullnaici;
  anaSAyfa({required this.aktifKullnaici});
  //const anaSAyfa({Key? key}) : super(key: key);

  @override
  State<anaSAyfa> createState() => _anaSAyfaState();
}

class _anaSAyfaState extends State<anaSAyfa> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Foodtypes> typesList = [];

  List<Foodtypes> parsetypesCevap(String cevap) {
    var jsonVeri = json.decode(cevap);

    if (jsonVeri["success"] as int == 1) {
      var typesCevap = FoodtypesCevap.fromJson(jsonVeri);
      typesList = typesCevap.typesList;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Yemek Türleri Yüklenemedi Tekrar Deneyin")),
      );
    }
    return typesList;
  }

  Future<List<Foodtypes>> typesGet() async {
    print("typeGet çalıştı");
    var url = Uri.parse("http://213.14.130.80/bakpisir/FoodtypesGet.php");
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
  Widget build(BuildContext context) => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Ana Sayfa"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              )
            ],
            backgroundColor: Colors.red.shade300,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.purple.shade500, Colors.red.shade500],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              )),
            ),
            bottom:
                TabBar(indicatorColor: Colors.white, indicatorWeight: 3, tabs: [
              Tab(icon: Icon(Icons.home), text: 'Anasayfa'),
              Tab(icon: Icon(DBIcons.fridge), text: 'Dolabım'),
              Tab(icon: Icon(Icons.book_sharp), text: 'Tariflerim'),
              Tab(icon: Icon(Icons.settings), text: 'Ayarlar'),
            ]),
          ),
          drawer: MyDrawer(widget.aktifKullnaici),
          key: scaffoldKey,
          body: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: typesList.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                child: Text(typesList[index].typeName),
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(15)),
              );
            },
          ),
        ),
      );
}
