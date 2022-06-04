import 'dart:convert';
//import 'dart:html';
import 'package:bak_pisir/MyIngredients.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Ingredients.dart';
import 'IngredientsCevap.dart';
import 'MyIngredientsCevap.dart';
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
  late List<MyIngredients> myingredientsList = [];
  late List<Ingredients> ingredientsList = [];

  //Checkbox için bir liste tanımlandı
  late List<bool> _isChecked;
  late TextEditingController controller;

  Future<List<MyIngredients>> MyIngredientsGet(String a) async {
    var url = Uri.parse("http://213.14.130.80/bakpisir/MyIngredientsGet.php");
    var veri = {"userID": a};
    var cevap = await http.post(url, body: veri);
    return parseMyIngredientsCevap(cevap.body);
  }

  List<MyIngredients> parseMyIngredientsCevap(String cevap) {
    var jsonVeri = json.decode(cevap);
    List<MyIngredients> myingredientsList = [];
    if (jsonVeri["success"] as int == 1) {
      var myingredientsCevap = MyIngredientsCevap.fromJson(jsonVeri);
      myingredientsList = myingredientsCevap.MyingredientsList;
    }
    return myingredientsList;
  }

  Future<void> MyIngredientsGoster() async {
    myingredientsList =
    await MyIngredientsGet(widget.aktifKullanici.userId.toString());
    //Checkbox için tanımlanan listeye malzemeler listesi uzunlugunda false atandı
    _isChecked = List<bool>.filled(myingredientsList.length, false);
    setState(() {});
  }

  Future<void> insertMyIngredients(String userID, String ingName) async {
    var url = Uri.parse("http://213.14.130.80/bakpisir/insert_MyIngredients.php");
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
      MyIngredientsGoster();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt Başarısız Tekrar Deneyin")),
      );
    }
    print(cevap.body.toString());
  }

  Future<List<Ingredients>> IngredientsGet() async {
    var url = Uri.parse("http://213.14.130.80/bakpisir/IngredientsGet.php");
    var cevap = await http.get(url);
    return parseIngredientsCevap(cevap.body);
  }

  List<Ingredients> parseIngredientsCevap(String cevap) {
    var jsonVeri = json.decode(cevap);

    if (jsonVeri["success"] as int == 1) {
      var ingredientsCevap = IngredientsCevap.fromJson(jsonVeri);
      ingredientsList = ingredientsCevap.IngredientsList;
    }
    return ingredientsList;
  }

  Future <String?> openDialog() =>
      showDialog <String>(

          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text("Eklenecek Malzeme Girin"),
                content:
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(hintText: "Dolapta ne var?",),
                  controller: controller,
                  ),

                actions: [
                TextButton(onPressed: (){
                  insertMyIngredients(widget.aktifKullanici.userId.toString(),controller.text);
                  Navigator.of(context).pop();
                  },
                    child: const Text("Ekle"))
    ]
              ));

  @override
  void initState() {
    super.initState();
    MyIngredientsGoster();
    IngredientsGet();

    controller = TextEditingController();
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
      key: scaffoldKey,

      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: ekranYuksekligi * 0.8,
                width: ekranGenisligi * 0.9,
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 1),
                    itemCount: myingredientsList.length,
                    itemBuilder: (context, index) {
                      return Card(

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _isChecked[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked[index] = value!;
                                  print(_isChecked);
                                });
                              },
                            ),
                            Image.network("http://213.14.130.80/bakpisir/sebzeler/${myingredientsList[index].ingImage}"),
                            Text("-${myingredientsList[index].ingName}"),

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
                  children: [
                    ElevatedButton(
                        child: Text("Malzeme Sil"),
                        onPressed: () {
                          for (var i = 0; i < myingredientsList.length; i++) {
                            if (_isChecked[i]) {
                              var ingID = myingredientsList[i].ingID;
                              myingredientsList.remove(i);
                              setState(() {
                                print(myingredientsList);
                              });
                            }
                          }
                        }),

                    ElevatedButton(
                        child: Text("Malzeme Ekle"),
                        onPressed: () async {
                          var a = await openDialog();
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
}