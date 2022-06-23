import 'package:bak_pisir/anaSayfa.dart';
import 'package:bak_pisir/tarifSayfasi.dart';
import 'package:bak_pisir/uyeOl.dart';
import 'package:flutter/material.dart';

import '../Users.dart';
import '../dolabim.dart';
import '../tarifYaz.dart';

class MyDrawer extends StatefulWidget {
  Users aktifKullanici;
  MyDrawer(this.aktifKullanici);
  // const MyDrawer({Key? key}) : super(key: key);

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
            child: Text(
              "BakPişir",
              style: TextStyle(
                  color: Colors.red.shade600,
                  fontFamily: "Hellix",
                  fontSize: 22),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bakpisir2.png"),
                fit: BoxFit.scaleDown,
              ),
              color: Colors.red.shade300,
            ),
          ),
          ListTile(
              title: Text("Ana Sayfa"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            anaSAyfa(aktifKullnaici: widget.aktifKullanici)));
              }),
          Divider(
            height: 1.0,
            color: Colors.blueGrey,
          ),
          ListTile(
            title: Text("Dolabımda Neler Var?"),
            onTap: () {
              if(widget.aktifKullanici.userId==0){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Dolabım bölümünü kullanmak için üye olunuz!")),
                );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => uyeOl()));
                  }else{
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => dolabim(widget.aktifKullanici)));
              }
            },
          ),
          ListTile(
            title: Text("Tarif Yaz"),
            onTap: () {
              if(widget.aktifKullanici.userId==0){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Tarif yazabilmek için için üye olunuz!")),
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => uyeOl()));
              }else{
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => tarifYaz(widget.aktifKullanici)));
              }
            },
          ),


          ListTile(
            title: Text("Çıkış Yap"),
            onTap: () {
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );
  }
}
