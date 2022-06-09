import 'dart:convert';

import 'package:bak_pisir/Comments.dart';
import 'package:bak_pisir/CommentsCevap.dart';
import 'package:bak_pisir/Users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'Foods.dart';
import 'Widgets/MyDrawer.dart';
import 'package:http/http.dart' as http;

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
  double evaluationGrade = 2.5;
  var comment = TextEditingController();
  List<Comments> commentsList = [];

  Future<List<Comments>> getComments(String foodID) async {
    var url = Uri.parse("http://213.14.130.80/bakpisir/getComments.php");
    var veri ={"foodID": widget.food.foodID.toString()};
    var cevap = await http.post(url,body:veri);
    return parseCommentsCevap(cevap.body);
  }

  List<Comments> parseCommentsCevap(String cevap) {
    print("gelen cevap parseCommentsCevap 1");
    print(cevap.isEmpty);
    var jsonVeri = json.decode(cevap);
    print("gelen cevap parseCommentsCevap");
    print(cevap.isEmpty);

    if (jsonVeri["success"] as int == 1) {
      var commentsCevap = CommentsCevap.fromJson(jsonVeri);
      commentsList = commentsCevap.commentsList;
      double toplam = 0;
      for(var i in commentsList){
        toplam = i.point+toplam;
      }
      averageScore = toplam/commentsList.length;
      setState((){

      });
    }
    return commentsList;
  }

  Future<int> insertComments(String foodID, String comment,String point, String userID,) async {
    var url = Uri.parse("http://213.14.130.80/bakpisir/insert_Comments.php");
    var veri = {
      "foodID": foodID,
      "comment": comment,
      "point": point,
      "userID": userID,
    };
    var cevap = await http.post(url, body: veri);
    var jsonVeri = json.decode(cevap.body);
    if (jsonVeri["success"] as int == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Yorumunuz Kaydedildi")),
      );
      commentsGoster();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt Başarısız Tekrar Deneyin")),
      );
    }
    print(cevap.body.toString());
    return jsonVeri["success"] as int;
  }

  Future<void> commentsGoster() async {
    commentsList =
    await getComments(widget.food.foodID.toString());
    //Checkbox için tanımlanan listeye malzemeler listesi uzunlugunda false atandı
    setState(() {});
  }

  Future <String?> openDialog()async {
    showDialog <String>(
        context: context,
        builder: (context) =>
            AlertDialog(
                content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height*0.5,
                    width: MediaQuery.of(context).size.height*0.8,
                    child: Column(
                      children: [
                        Text("Yorumunuzu Yazınız"),

                        SizedBox(
                            height: 200,
                            child: TextField(
                              controller: comment,
                              decoration: const InputDecoration(
                                  hintText: "Yorum yazınız"
                              ),
                            )),
                        Text("Yemek tarifi için puan veriniz"),

                        RatingBar.builder(
                          initialRating: evaluationGrade,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            evaluationGrade =rating;
                          },
                        ),
                      ],
                    ),
                  );
                }),

                title: const Text("Yorum Yapınız..."),

                actions: [
                  TextButton(onPressed: (){
                    Future<int> response = insertComments(widget.food.foodID.toString(), comment.text, evaluationGrade.toString(), widget.aktifKullanici.userId.toString());

                    Navigator.of(context).pop();
                  },
                      child: const Text("Ekle"))
                ]
            ));
  }


  @override
  void initState() {
    super.initState();
    commentsGoster();
  }

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
                child: Image.network("http://213.14.130.80/bakpisir/sebzeler/mantar.jpg"),
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

                          // todo yorum yapan kişinin tekrar yorum yapmasını engelle
                          openDialog();
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
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 15.0,
                            direction: Axis.horizontal,
                          ),
                          Text(averageScore.toStringAsFixed(1)),
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

                    itemCount: commentsList.length,
                    itemBuilder: (context,index){
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Yorum Yapan İsim"+commentsList[index].userName),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(commentsList[index].comment),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(commentsList[index].point.toString()),
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