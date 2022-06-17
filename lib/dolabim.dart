import 'dart:convert';
//import 'dart:html';
import 'package:bak_pisir/MyIngredients.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BakpisirStrings.dart';
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
  late Set <String> turList = {"sebze"};
  //Checkbox için bir liste tanımlandı
  late List<bool> _isChecked;
  late TextEditingController controller;
  late String dropdownturListDeger =turList.first;
  late Ingredients dropdownDeger;
  late List<Ingredients> dropdownList;
  var baseUrl = BakpisirStrings().baseUrl;

  Future<List<MyIngredients>> MyIngredientsGet(String a) async {

    var url = Uri.parse(baseUrl+"MyIngredientsGet.php");
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

  Future<void> insertMyIngredients(String userID, String ingID) async {
    var baseUrl = BakpisirStrings().baseUrl;
    var url = Uri.parse(baseUrl+"insert_MyIngredients.php");
    var veri = {
      "userID": userID,
      "ingID": ingID,
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

  Future<void> deleteMyIngredients(String myingID) async {
    var url = Uri.parse(baseUrl+"delete_MyIngredients.php");
    var veri = {
      "myingID": myingID,
    };
    var cevap = await http.post(url, body: veri);
    print("/*/*/*");
    print(cevap.body.isEmpty);
    var jsonVeri = json.decode(cevap.body);
    if (jsonVeri["success"] as int == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Seçili Malzemeler Silinidi")),
      );
      MyIngredientsGoster();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("İşlem Başarısız Tekrar Deneyin")),
      );
    }
    print(cevap.body.toString());
  }

  Future<List<Ingredients>> IngredientsGet() async {
    var url = Uri.parse(baseUrl+"IngredientsGet.php");
    var cevap = await http.get(url);
    return parseIngredientsCevap(cevap.body);
  }

  List<Ingredients> parseIngredientsCevap(String cevap) {
    var jsonVeri = json.decode(cevap);

    if (jsonVeri["success"] as int == 1) {
      var ingredientsCevap = IngredientsCevap.fromJson(jsonVeri);
      ingredientsList = ingredientsCevap.IngredientsList;
      dropdownList = ingredientsList;
      dropdownDeger = dropdownList[0];
      turList.clear();
      for (var i in ingredientsList){
        turList.add(i.ingTypeName);
      }
    }
    return ingredientsList;
  }

  Future <String?> openDialog() =>
      showDialog <String>(

          context: context,
          builder: (context) =>
              AlertDialog(
                content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height*0.2,
                    width: MediaQuery.of(context).size.height*0.8,
                    child: Column(
                      children: [
                        Text("Malzeme Türünü Seçiniz"),
                        DropdownButton<String>(
                          value: dropdownturListDeger,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            Iterable<Ingredients> filtrele = ingredientsList.where((element) {
                              print("----- ${element.ingTypeID}");
                              return element.ingTypeID==newValue;
                            });
                            dropdownList = filtrele.toList();
                            dropdownDeger=dropdownList[0];
                            setState(() {
                              dropdownturListDeger = newValue!;

                            });
                          },
                          items: turList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                              onTap: (){

                              },
                            );

                          }).toList(),
                        ),
                        Text("Malzeme Seçiniz"),
                        DropdownButton<Ingredients>(
                          value: dropdownDeger,
                          icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                            ),
                        onChanged: (Ingredients? newValue) {
                          setState(() {
                           dropdownDeger = newValue!;
                            });
                          },
                          items: dropdownList.map<DropdownMenuItem<Ingredients>>((Ingredients value) {
                            return DropdownMenuItem<Ingredients>(
                              value: value,
                              child: Text(value.ingName),
                               onTap: (){
                                setState((){
                                });
                                },
                              );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }),

                title: const Text("Eklenecek Malzeme Girin"),


                actions: [
                TextButton(onPressed: (){
                  insertMyIngredients(widget.aktifKullanici.userId.toString(),dropdownDeger.ingID.toString());
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
                            Image.network(baseUrl+"sebze/${myingredientsList[index].ingImage}"),
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
                              print("silinecek öğe");
                              print(myingredientsList[i].myingID.toString());
                              deleteMyIngredients(myingredientsList[i].myingID.toString());
                              setState(() {
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