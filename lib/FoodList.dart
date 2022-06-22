import 'dart:convert';

import 'package:bak_pisir/FoodsCevap.dart';
import 'package:bak_pisir/tarifSayfasi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BakpisirStrings.dart';
import 'Foods.dart';
import 'Users.dart';
import 'Widgets/MyDrawer.dart';
import 'assets/db_icons.dart';

class FoodList extends StatefulWidget {
  int typeId;
  Users aktifKullanici;
  FoodList(this.typeId, this.aktifKullanici);
  @override
  State<FoodList> createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var baseUrl = BakpisirStrings().baseUrl;
  late List<Foods> foodsList = [];

  Future<List<Foods>> GetFoods(String foodType) async {
    var url = Uri.parse(baseUrl + "getFoodsv2.php");
    print("giden type id;");
    print(widget.typeId.toString());
    var veri = {"typeId": widget.typeId.toString()};
    var cevap = await http.post(url, body: veri);
    print("gelen cevap");
    print(cevap.toString());
    return parseFoodsCevap(cevap.body);
  }

  List<Foods> parseFoodsCevap(String cevap) {
    var jsonVeri = json.decode(cevap);
    print("gelen cevap");
    print(cevap.toString());

    if (jsonVeri["success"] as int == 1) {
      var foodsCevap = FoodsCevap.fromJson(jsonVeri);
      foodsList = foodsCevap.foodList;
      setState(() {});
    }
    return foodsList;
  }

  @override
  void initState() {
    super.initState();
    GetFoods(widget.typeId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.purple.shade500, Colors.red.shade500],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          )),
        ),
      ),
      drawer: MyDrawer(widget.aktifKullanici),
      key: scaffoldKey,
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2 / 1.9),
        padding: const EdgeInsets.all(8.0),
        itemCount: foodsList.length,
        itemBuilder: (context, index) {
          return InkWell(
              child: Container(
                width: 300,
                height: 150,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2.0,
                        color: const Color.fromRGBO(219, 112, 147, 1)),
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              baseUrl + "sebze/kabak.jpg",
                              width: 80,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => tarifSayfasi(
                                      widget.aktifKullanici,
                                      foodsList[index])));
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            foodsList[index].foodName,
                            style: TextStyle(
                                fontFamily: "Hellix",
                                fontSize: 16,
                                color: Colors.pink.shade700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(foodsList[index].rating.toString()),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "120 Kalori",
                        style: TextStyle(
                            fontFamily: "Hellix",
                            fontSize: 13,
                            color: Colors.pink.shade400),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Text("20 Dakika",
                                  style: TextStyle(
                                      fontFamily: "Hellix",
                                      fontSize: 13,
                                      color: Colors.red.shade300)),
                              Icon(
                                Icons.timer,
                                size: 13,
                                color: Colors.red.shade300,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Row(
                            children: [
                              Text("4 Kişilik",
                                  style: TextStyle(
                                      fontFamily: "Hellix",
                                      fontSize: 13,
                                      color: Colors.red.shade300)),
                              Icon(
                                Icons.person,
                                size: 13,
                                color: Colors.red.shade300,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => tarifSayfasi(
                          widget.aktifKullanici, foodsList[index])),
                );
              });
        },
      ),
    );
  }
}
