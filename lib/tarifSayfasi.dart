import 'package:bak_pisir/Users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'Foods.dart';
import 'Widgets/MyDrawer.dart';

class tarifSayfasi extends StatefulWidget {
  Foods food;
  Users aktifKullanici;
  tarifSayfasi(this.aktifKullanici,this.food);

 // const tarifSayfasi({Key? key}) : super(key: key);

  @override
  State<tarifSayfasi> createState() => _tarifSayfasiState();
}

class _tarifSayfasiState extends State<tarifSayfasi> {
  double averageScore = 2.5;
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
                width: ekranGenisligi/1.5,
                child: Image.network("http://213.14.130.80/bakpisir/sebzeler/kabak.jpg"),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: ekranGenisligi/8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Ortalama Puan"),
                          RatingBarIndicator(
                            rating: averageScore,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 15.0,
                            direction: Axis.horizontal,
                          ),
                          Text(averageScore.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding:  EdgeInsets.all(ekranYuksekligi/100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.food.foodName,
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: ekranGenisligi/20,
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    Yazi("Tarif Yazarı : "+widget.food.authorName, ekranGenisligi/25),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(ekranYuksekligi/100),
            child: Yazi(widget.food.recipe, ekranGenisligi/25),
         ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 400 ,
                  child: ListView.builder(

                    itemCount: 50,
                    itemBuilder: (context,index){
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Yorum Yapan İsim"+index.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Yapılan Yorum "),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Not"),
                          ),
                        ],
                      );
                    }
                  ),
                ),


              ],
            ),
        ],
      )
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