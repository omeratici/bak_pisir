import 'dart:convert';

import 'package:bak_pisir/BakpisirStrings.dart';
import 'package:bak_pisir/FoodList.dart';
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
  var baseUrl = BakpisirStrings().baseUrl;

  List<Foodtypes> parsetypesCevap(String cevap) {
    var jsonVeri = json.decode(cevap);
    if (jsonVeri["success"] as int == 1) {
      var typesCevap = FoodtypesCevap.fromJson(jsonVeri);
      typesList = typesCevap.typesList;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Yemek Türleri Yüklenemedi Tekrar Deneyin")),
      );
    }
    return typesList;
  }

  Future<List<Foodtypes>> typesGet() async {
    var url = Uri.parse(baseUrl + "FoodtypesGet.php");
    var cevap = await http.get(url);
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
          ),
          drawer: MyDrawer(widget.aktifKullnaici),
          key: scaffoldKey,
          body: GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: typesList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FoodList(
                              typesList[index].typeId, widget.aktifKullnaici)));
                },
                child: Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/load.gif',
                    image: baseUrl + "food_type/" + typesList[index].typeImage,
                    fit: BoxFit.cover,
                    width: 200,
                  ),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(25)),
                ),
              );
            },
          ),
        ),
      );
}
