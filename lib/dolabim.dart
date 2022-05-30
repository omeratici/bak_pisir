import 'dart:convert';
import 'package:bak_pisir/Ingredients.dart';
import 'package:bak_pisir/tarifSayfasi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'IngredientsCevap.dart';
import 'Users.dart';
import 'Widgets/MyDrawer.dart';

class dolabim extends StatefulWidget {
  Users aktifKullanici;
  dolabim(this.aktifKullanici);
 // const dolabim({Key? key}) : super(key: key);

  @override
  State<dolabim> createState() => _dolabimState();
}

class _dolabimState extends State<dolabim> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  late List<Ingredients> ingredientsList = [];

  var secilimalzemeler =[];
  //Checkbox için bir liste tanımlandı
  late List<bool> _isChecked;
  late TextEditingController controller;

  Future<List<Ingredients>> ingredientsGet (String a) async {
    var url =Uri.parse("http://213.14.130.80/bakpisir/IngredientsGet.php");
    var veri = {"userID":a};
    var cevap = await http.post(url,body: veri);
    return parseIngredientsCevap(cevap.body);
  }

  Future<void> IngredientsGoster() async {
    ingredientsList = await ingredientsGet(widget.aktifKullanici.userId.toString());
    //Checkbox için tanımlanan listeye malzemeler listesi uzunlugunda false atandı
    _isChecked = List<bool>.filled(ingredientsList.length, false);
    setState(() {
    });
  }

  List<Ingredients> parseIngredientsCevap(String cevap) {
    var jsonVeri = json.decode(cevap);
    List<Ingredients> ingredientsList =[];
    if (jsonVeri["success"] as int == 1) {
      var ingredientsCevap = IngredientsCevap.fromJson(jsonVeri);
      ingredientsList = ingredientsCevap.ingredientsList;
    }
    return ingredientsList ;
  }

  Future<void> insertIngredients(
      String userID, String ingName) async {
    var url = Uri.parse("http://213.14.130.80/bakpisir/insert_ingredients.php");
    var veri = {
      "userID": userID,
      "ingName": ingName,
    };
    var cevap = await http.post(url, body: veri);
    var jsonVeri = json.decode(cevap.body);
    if (jsonVeri["success"] as int == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt Başarılı")),
      );
      IngredientsGoster();
      setState(() {
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt Başarısız Tekrar Deneyin")),
      );
    }
    print(cevap.body.toString());
  }


  @override
  void initState() {
    super.initState();
    IngredientsGoster();


    controller= TextEditingController();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Bak Pişir - Dolabım"),
      ),
      drawer: MyDrawer(widget.aktifKullanici),
      key:scaffoldKey,

      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: ekranYuksekligi*0.8,
                width: ekranGenisligi*0.8,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2/1),
                    itemCount: ingredientsList.length,
                    itemBuilder: (context,index){
                      return Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _isChecked[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked[index]  = value!;
                                });
                              },
                            ),
                            Text("-------${ingredientsList[index].ingName}"),

                          ],
                        ),
                      );
                    }

                ),


              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:[
                    ElevatedButton(
                        child: Text("Malzeme Sil"),
                        onPressed: (){
                      for(var i=0; i<ingredientsList.length;i++){
                        if(_isChecked[i])
                          {
                            //todo bu indexi db den sil ve malzeme görteri tekrar çalıştır
                            ingredientsList.remove(i);
                            setState(() {
                              print(ingredientsList);
                            });
                          }
                      }
                    }),

                    ElevatedButton(
                        child: Text("Malzeme Ekle"),
                        onPressed: () async {
                          var a =await openDialog();


                          //Todo gelen stringi hash map e ekle
                          // malzemeler[a.toString()]=1;
                          // print(malzemeler);
                        }),
                  ]
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future <String?> openDialog() =>showDialog <String> (
      context: context,
      builder: (context)=>AlertDialog(
        title: Text("Eklenecek Malzeme Girin"),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: "Dolapta ne var?",),
          controller: controller,
    ),
    actions: [
      TextButton(onPressed: (){
        insertIngredients(widget.aktifKullanici.userId.toString(),controller.text);
        Navigator.of(context).pop();

      }, child: Text("Ekle"))
    ],
  ));
 /* void ekle(){
    Navigator.of(context).pop(controller.text);

  } */
}