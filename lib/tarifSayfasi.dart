import 'package:bak_pisir/Users.dart';
import 'package:flutter/material.dart';

import 'Widgets/MyDrawer.dart';

class tarifSayfasi extends StatefulWidget {
  Users aktifKullanici;
  tarifSayfasi(this.aktifKullanici);

 // const tarifSayfasi({Key? key}) : super(key: key);

  @override
  State<tarifSayfasi> createState() => _tarifSayfasiState();
}

class _tarifSayfasiState extends State<tarifSayfasi> {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Bak Pişir - Tafir"),
      ),
      drawer: MyDrawer(widget.aktifKullanici),
      key:scaffoldKey,

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                width: ekranGenisligi,
                child: Image.asset("resimler/yemekresim.jpeg")
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: ekranGenisligi/8,
                    child: TextButton(
                      style:TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                        primary: Colors.black,
                      ),
                      child: Yazi("Beğen", ekranGenisligi/25),
                      onPressed: (){
                        print("Beğenildi");
                      },

                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: ekranGenisligi/8,
                    child: TextButton(
                      child: Yazi("Yorum Yap", ekranGenisligi/25),
                      style:TextButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                        primary: Colors.black,

                      ),
                      onPressed: (){
                        print("Yorum yapıldı");
                      },

                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding:  EdgeInsets.all(ekranYuksekligi/100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Köfte",
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: ekranGenisligi/20,
                  ),
                ),
                Row(
                  children: [
                    Yazi("Izgara Üzerinde Pişirime Uygun", ekranGenisligi/25),
                    Spacer(),
                    Yazi("8 Ağustos", ekranGenisligi/25),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(ekranYuksekligi/100),
            child: Yazi("Köfte harcını hazırlamak için, soğanları rendeleyin ve maydanozları ince ince kıyın. İsterseniz, bir diş sarımsak da ekleyebilirsiniz."
              "Soğan, maydanoz, kıyma, yumurta, zeytinyağı ve tuzu bir kaba alıp iyice yoğurun. Bu sırada istediğiniz baharatları da ekleyerek yoğurmaya devam edin."
              "Hazırladığınız harcın üzerini streç filmle kapatarak yarım saat buzdolabında dinlendirin."
              "Ardından harçtan ceviz büyüklüğünde parçalar koparıp yuvarlayın. 1 cm olacak şekilde üzerine bastırarak yassılaştırın.", ekranGenisligi/25),
         ),
        ],
      ),
     ),
    );
  }
}

class Yazi extends StatelessWidget {
  String icerik;
  double yaziBoyut;

 Yazi(this.icerik, this.yaziBoyut);

  @override
  Widget build(BuildContext context) {
    return Text(icerik,style: TextStyle(fontSize: yaziBoyut),);
  }
}