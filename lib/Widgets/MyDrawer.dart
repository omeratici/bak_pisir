
import 'package:bak_pisir/anaSayfa.dart';
import 'package:bak_pisir/tarifSayfasi.dart';
import 'package:flutter/material.dart';

import '../dolabim.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text("BakPişir"),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text("Ana Sayfa"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => anaSAyfa()));
            }

          ),
          Divider(
            height: 1.0,
            color:Colors.blueGrey,
          ),
          ListTile(
            title: Text("Dolabımda Neler Var?"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => dolabim()));
            },
          ),
          ListTile(
            title: Text("Tarif Yaz"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => tarifSayfasi()));
            },
          ),
          ListTile(
            title: Text("Favori Tariflerim"),
            onTap: (){
              Navigator.pop(context);

            },
          ),
          ListTile(
            title: Text("Dolabımdakilerle hangi yemekleri yapabilirim"),
            onTap: (){

              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Alışveriş Listem"),
            onTap: (){
              Navigator.pop(context);
            },
          ),

        ],
      ),
    );
  }
}
