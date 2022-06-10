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

class FoodList extends StatefulWidget{
  
  int  typeId;
  Users aktifKullanici;
  FoodList(this.typeId,this.aktifKullanici);
  @override
  State<FoodList> createState() => _FoodListState();
  }


class _FoodListState extends State<FoodList>{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var baseUrl = BakpisirStrings().baseUrl;
  late List<Foods> foodsList =[];


  Future<List<Foods>> GetFoods(String foodType) async {
    var url = Uri.parse(baseUrl+"getFoods.php");
    print("giden type id;");
    print(widget.typeId.toString());
    var veri ={"typeId": widget.typeId.toString()};
    var cevap = await http.post(url,body:veri);
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
      setState((){

      });
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
            crossAxisCount: 2,
            childAspectRatio: 2 / 1),
        padding: const EdgeInsets.all(8.0),
        itemCount: foodsList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  width:50,
                    height: 50,
                    child: Image.network(baseUrl+"sebze/kabak.jpg")),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => tarifSayfasi(widget.aktifKullanici,foodsList[index])));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(foodsList[index].foodName),
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15)),

                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

  }
  
}