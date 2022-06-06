import 'package:flutter/material.dart';

import 'Foods.dart';
import 'Users.dart';
import 'Widgets/MyDrawer.dart';
import 'assets/db_icons.dart';

class FoodList extends StatefulWidget{
  
  String foodtypeName;
  Users aktifKullanici;
  FoodList(this.foodtypeName,this.aktifKullanici);
  @override
  State<FoodList> createState() => _FoodListState();
  }


class _FoodListState extends State<FoodList>{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var a = Foods(1, "ecipe", "foodImage", "1", "Mercimek", 1);
  var b = Foods(1, "ecipe", "foodImage", "1", "Şehriye", 1);
  var c = Foods(1, "ecipe", "foodImage", "1", "Ayran Çorbası", 1);
  late List<Foods> foodsList =[a,b,c];






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
                    child: Image.network("http://213.14.130.80/bakpisir/sebzeler/kabak.jpg")),
                GestureDetector(
                  onTap: (){

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