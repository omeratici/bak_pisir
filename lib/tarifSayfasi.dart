import 'dart:convert';

import 'package:bak_pisir/Comments.dart';
import 'package:bak_pisir/CommentsCevap.dart';
import 'package:bak_pisir/Users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'BakpisirStrings.dart';
import 'Foods.dart';
import 'Ingredients.dart';
import 'IngredientsCevap.dart';
import 'Widgets/MyDrawer.dart';
import 'package:http/http.dart' as http;

class tarifSayfasi extends StatefulWidget {
  Foods food;
  Users aktifKullanici;
  tarifSayfasi(this.aktifKullanici, this.food);

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
  List<Ingredients> food_ingredientsList = [];
  var baseUrl = BakpisirStrings().baseUrl;

  Future<List<Comments>> getComments(String foodID) async {
    var url = Uri.parse(baseUrl + "getComments.php");
    var veri = {"foodID": widget.food.foodID.toString()};
    var cevap = await http.post(url, body: veri);
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
      for (var i in commentsList) {
        toplam = i.point + toplam;
      }
      averageScore = toplam / commentsList.length;
      setState(() {});
    }
    return commentsList;
  }

  Future<int> insertComments(
    String foodID,
    String comment,
    String point,
    String userID,
  ) async {
    var url = Uri.parse(baseUrl + "insert_Comments.php");
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
    commentsList = await getComments(widget.food.foodID.toString());
    //Checkbox için tanımlanan listeye malzemeler listesi uzunlugunda false atandı
    setState(() {});
  }

  Future<String?> openDialog() async {
    showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: 300,
                  height: 300,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Oylama   ",
                            style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Hellix',
                                color: Colors.pink),
                          ),
                          RatingBar.builder(
                            itemSize: 25,
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
                              evaluationGrade = rating;
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        color: Colors.black,
                        height: 7.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: TextField(
                          maxLines: 8,
                          controller: comment,
                          decoration: const InputDecoration(
                            hintText: "Yorum yazınız",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      InkWell(
                        onTap: () {
                          Future<int> response = insertComments(
                              widget.food.foodID.toString(),
                              comment.text,
                              evaluationGrade.toString(),
                              widget.aktifKullanici.userId.toString());

                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 15.0, bottom: 15.0, right: 25, left: 25),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade300,
                            borderRadius: BorderRadius.all(
                              Radius.circular(26.0),
                            ),
                          ),
                          child: Text(
                            "Yorum Ekle",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ));
  }

  Future<List<Ingredients>> GetFood_ingredients(String foodID) async {
    var url = Uri.parse(baseUrl + "getFood_ingredients.php");
    var veri = {"foodID": widget.food.foodID.toString()};
    var cevap = await http.post(url, body: veri);
    return parseFood_ingredientsCevap(cevap.body);
  }

  List<Ingredients> parseFood_ingredientsCevap(String cevap) {
    print("gelen cevap parseFood_ingredientsCevap 1");
    print(cevap.isEmpty);
    var jsonVeri2 = utf8.decode(cevap.codeUnits).toString();
    var jsonVeri = json.decode(jsonVeri2);
    print("gelen cevap parseFood_ingredientsCevap");
    print(cevap.isEmpty);

    if (jsonVeri["success"] as int == 1) {
      var ingredientsCevap = IngredientsCevap.fromJson(jsonVeri);
      food_ingredientsList = ingredientsCevap.IngredientsList;
      for (var i in food_ingredientsList) {
        print("************");
        print(i.ingName);
      }
    } else {
      print(jsonVeri["succsess"].toString());
    }
    return food_ingredientsList;
  }

  Future<void> Food_ingredients_Goster() async {
    food_ingredientsList =
        await GetFood_ingredients(widget.food.foodID.toString());
    //Checkbox için tanımlanan listeye malzemeler listesi uzunlugunda false atandı
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    commentsGoster();
    Food_ingredients_Goster();
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade300,
        title: Text("Bak Pişir - Tarif"),
      ),
      drawer: MyDrawer(widget.aktifKullanici),
      key: scaffoldKey,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ekranGenisligi / 1.5,
          ),
          Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Row(
                  children: [
                    Text(
                      widget.food.foodName,
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          fontFamily: "Hellix"),
                    ),
                    
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.app_registration,
                      color: Colors.red.shade300,
                      size: 36,
                    ),
                    Text(
                      " : " + widget.food.authorName,
                      style: TextStyle(
                          color: Colors.red.shade300,
                          fontSize: 36,
                          fontFamily: "Hellix"),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.9,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kalori",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                                fontFamily: "Hellix",
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text("120 Kalori",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: "Hellix",
                                )),
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                              "Süre",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                                fontFamily: "Hellix",
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text("1 Saat",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: "Hellix",
                                )),
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                              "Kişi",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                                fontFamily: "Hellix",
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text("4 Kişilik",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: "Hellix",
                                )),
                            SizedBox(
                              height: 4,
                            ),
                          ]),
                    ),
                    Image.network(
                      baseUrl + widget.food.foodImage,
                      height: 150.0,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Malzemeler",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Hellix",
                      fontSize: 28.0,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 70,
                    child: ListView.builder(
                        itemCount: food_ingredientsList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Text(
                                food_ingredientsList[index].ingName,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Hellix",
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Tarif",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Hellix",
                      fontSize: 28.0,
                    ),
                  ),
                ],
              ),

              /*
                Row(
                  children: [
                    SizedBox(
                      height: 150,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Malzemeler;"),
                      ),
                    ),
                    GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 1),
                        itemCount: food_ingredientsList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Image.network(baseUrl+"${food_ingredientsList[index].ingType}/${food_ingredientsList[index].ingImage}"),
                                Text("-${food_ingredientsList[index].ingName}"),

                              ],
                            ),
                          );
                        }

                    ),
                  ],
                ),

                */
            ],
          ),
          Padding(
              padding: EdgeInsets.all(ekranYuksekligi / 100),
              child: Text(
                widget.food.recipe,
                style: TextStyle(
                    fontFamily: "Hellix", fontSize: 16, color: Colors.grey),
              )),
          SizedBox(
            height: 24,
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Yorumlar",
                  style: TextStyle(
                    fontFamily: "Hellix",
                    fontSize: 28.0,
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                      itemCount: commentsList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                                width: 2, color: Colors.red.shade300),
                          )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Colors.red.shade300,
                                  ),
                                  Text(
                                    commentsList[index].userName,
                                    style: TextStyle(
                                        fontFamily: "Hellix",
                                        fontSize: 21,
                                        color: Colors.red.shade500),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  RatingBarIndicator(
                                    rating: commentsList[index].point,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 15.0,
                                    direction: Axis.horizontal,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                commentsList[index].comment,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Hellix",
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: ekranGenisligi / 8,
                    child: TextButton(
                      child: Yazi("Yorum Yap", ekranGenisligi / 25),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        primary: Colors.white,
                      ),
                      onPressed: () {
                        bool check = false;
                        for (var i in commentsList) {
                          if (i.userID == widget.aktifKullanici.userId) {
                            check = true;
                          }
                        }
                        if (check) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Daha önce yorum yapmışsınız.")),
                          );
                        } else {
                          openDialog();
                        }
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: ekranGenisligi / 8,
                    child: Column(
                      children: [
                        Text(
                          "Ortalama Puan",
                          style: TextStyle(fontSize: 16, fontFamily: "Hellix"),
                        ),
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}

class Yazi extends StatelessWidget {
  String icerik;
  double yaziBoyut;

  Yazi(this.icerik, this.yaziBoyut);

  @override
  Widget build(BuildContext context) {
    return Text(
      icerik,
      style: TextStyle(fontSize: yaziBoyut),
    );
  }
}
