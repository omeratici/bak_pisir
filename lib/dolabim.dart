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
  late Set<String> turList = {"sebze"};
  //Checkbox için bir liste tanımlandı
  late List<bool> _isChecked;
  late TextEditingController controller;
  late String dropdownturListDeger = turList.first;
  late Ingredients dropdownDeger;
  late List<Ingredients> dropdownList;
  var baseUrl = BakpisirStrings().baseUrl;

  Future<List<MyIngredients>> MyIngredientsGet(String a) async {
    var url = Uri.parse(baseUrl + "MyIngredientsGet.php");
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
    var url = Uri.parse(baseUrl + "insert_MyIngredients.php");
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
    var url = Uri.parse(baseUrl + "delete_MyIngredients.php");
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
    var url = Uri.parse(baseUrl + "IngredientsGet.php");
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
      for (var i in ingredientsList) {
        turList.add(i.ingTypeName);
      }
    }
    return ingredientsList;
  }

  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 5.0),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 300,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Malzeme Türünü Seçiniz",
                      style: TextStyle(
                        fontFamily: "Hellix",
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 55, vertical: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.pink, width: 2),
                      ),
                      child: DropdownButton<String>(
                        alignment: Alignment.center,
                        value: dropdownturListDeger,
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: Colors.pink,
                        ),
                        elevation: 6,
                        style: TextStyle(color: Colors.pink.shade500),
                        underline: Container(
                          width: 20,
                          height: 2,
                          color: Colors.pink.shade500,
                        ),
                        onChanged: (String? newValue) {
                          Iterable<Ingredients> filtrele =
                              ingredientsList.where((element) {
                            print("----- ${element.ingTypeName}");
                            return element.ingTypeName == newValue;
                          });
                          dropdownList = filtrele.toList();
                          dropdownDeger = dropdownList[0];
                          setState(() {
                            dropdownturListDeger = newValue!;
                          });
                        },
                        items: turList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {},
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Malzeme Seçiniz",
                      style: TextStyle(
                        fontFamily: "Hellix",
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.pink, width: 2),
                      ),
                      child: DropdownButton<Ingredients>(
                        value: dropdownDeger,
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: Colors.pink,
                        ),
                        elevation: 6,
                        style: TextStyle(color: Colors.pink.shade500),
                        underline: Container(
                          width: 20,
                          height: 2,
                          color: Colors.pink.shade500,
                        ),
                        onChanged: (Ingredients? newValue) {
                          setState(() {
                            dropdownDeger = newValue!;
                          });
                        },
                        items: dropdownList.map<DropdownMenuItem<Ingredients>>(
                            (Ingredients value) {
                          return DropdownMenuItem<Ingredients>(
                            value: value,
                            child: Text(value.ingName),
                            onTap: () {
                              setState(() {});
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        insertMyIngredients(
                            widget.aktifKullanici.userId.toString(),
                            dropdownDeger.ingID.toString());
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          width: 100,
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade300,
                            borderRadius: BorderRadius.all(
                              Radius.circular(32.0),
                            ),
                          ),
                          child: Text(
                            "Ekle",
                            style: TextStyle(
                              fontFamily: 'Hellix',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ],
                ),
              );
            }),
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
        backgroundColor: Colors.red.shade300,
        title: Text("Bak Pişir - Dolabım"),
      ),
      drawer: MyDrawer(widget.aktifKullanici),
      key: scaffoldKey,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: ekranYuksekligi * 0.8,
                width: ekranGenisligi * 0.9,
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 1 / 1.6),
                    itemCount: myingredientsList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2.0,
                                color: const Color.fromRGBO(219, 112, 147, 1)),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        width: 100,
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  color: Colors.red.shade800,
                                  alignment: Alignment.topCenter,
                                  iconSize: 20,
                                  icon: Icon(
                                    Icons.backspace,
                                  ),
                                  onPressed: () {
                                    deleteMyIngredients(myingredientsList[index]
                                        .myingID
                                        .toString());
                                    setState(() {});
                                    for (var i = 0;
                                        i < myingredientsList.length;
                                        i++) {
                                      if (_isChecked[i]) {
                                        print("silinecek öğe");
                                        print(myingredientsList[i]
                                            .myingID
                                            .toString());
                                        deleteMyIngredients(myingredientsList[i]
                                            .myingID
                                            .toString());
                                        setState(() {});
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/load.gif',
                                image: baseUrl +
                                    "${myingredientsList[index].ingTypeName}/${myingredientsList[index].ingImage}",
                                width: 100,
                                height: 45,
                              ),
                            ),
                            Text(
                              "${myingredientsList[index].ingName}",
                              style: TextStyle(
                                  fontFamily: "Hellix",
                                  fontSize: 13,
                                  color: Colors.pink.shade700),
                            ),
                            Checkbox(
                              activeColor: Colors.pink.shade100,
                              checkColor: Colors.pink.shade700,
                              value: _isChecked[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked[index] = value!;
                                  print(_isChecked);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 17),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(
                    alignment: Alignment.center,
                    icon: Icon(
                      Icons.add_circle,
                      size: 49,
                      color: Colors.pink.shade900,
                    ),
                    onPressed: () async {
                      var a = await openDialog();
                      //Todo gelen stringi hash map e ekle
                      // malzemeler[a.toString()]=1;
                      // print(malzemeler);
                    }),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
