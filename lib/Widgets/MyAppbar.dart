import 'package:flutter/material.dart';

import '../Users.dart';
import '../assets/db_icons.dart';

class MyAppbar extends StatefulWidget {
  Users aktifKullanici;
  MyAppbar(this.aktifKullanici);
  // const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyAppbar> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyAppbar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
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

    );
  }
}