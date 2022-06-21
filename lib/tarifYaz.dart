import 'dart:convert';

import 'package:bak_pisir/BakpisirStrings.dart';
import 'package:bak_pisir/Foodtypes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'FoodtypesCevap.dart';
import 'Ingredients.dart';
import 'IngredientsCevap.dart';
import 'Users.dart';
import 'dart:io';

class tarifYaz extends StatefulWidget {
  Users aktifKullanici;
  tarifYaz({required this.aktifKullanici});
  //const tarifYaz({Key? key}) : super(key: key);

  @override
  State<tarifYaz> createState() => _tarifYazState();
}

class _tarifYazState extends State<tarifYaz> {
  var baseUrl = BakpisirStrings().baseUrl;
  Foodtypes ddturdeger = Foodtypes(0, "Türler Yükleniyor", "typeImage");
  List<Foodtypes> foodTypeList = [];
  var foodTypeSelectController = TextEditingController();
  var foodRecipeController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  PickedFile? secilendosya;
  late var secilenTur;
  late Set<String> turList = {"sebze"};
  late String dropdownturListDeger = turList.first;
  late List<Ingredients> foodIngredientsList = [];
  late List<Ingredients> ingredientsList = [];
  late Ingredients dropdownDeger;
  late List<Ingredients> dropdownList;
  late List<bool> _isChecked;

  void ResimAl() async {
    final picker = ImagePicker();
    final secilen = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (secilen != null) {
        secilendosya = PickedFile(secilen.path);
      }
    });
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

  List<Foodtypes> parsetypesCevap(String cevap) {
    var typesCevap;
    var jsonVeri = json.decode(cevap);
    if (jsonVeri["success"] as int == 1) {
      typesCevap = FoodtypesCevap.fromJson(jsonVeri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Yemek Türleri Yüklenemedi Tekrar Deneyin")),
      );
    }
    return typesCevap.typesList;
  }

  Future<List<Foodtypes>> typesGet() async {
    var url = Uri.parse(baseUrl + "FoodtypesGet.php");
    var cevap = await http.get(url);
    return parsetypesCevap(cevap.body);
  }

  Future<void> FoodTypeGoster() async {
    foodTypeList = await typesGet();
    ddturdeger = await foodTypeList[0];
    setState(() {});
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
                        foodIngredientsList.add(dropdownDeger);
                        setState(() {});
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
    IngredientsGet();
    FoodTypeGoster();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade300,
          title: Text("Bak Pişir - Tarif Ekle"),
        ),
        body: Stack(children: [
          Container(
            padding: EdgeInsets.only(left: 35, top: 50),
            child: Text(
              "Tarif",
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  right: 35,
                  left: 35),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '       Yemeğinizin adı :',
                        style: TextStyle(fontFamily: 'Hellix', fontSize: 16),
                      ),
                      Container(
                        height: 50,
                        width: 130,
                        child: TextFormField(
                          maxLines: 8,
                          controller: foodTypeSelectController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Yemek Adı',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Yemek Türünü Giriniz:",
                        style: TextStyle(fontFamily: 'Hellix', fontSize: 16),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.pink, width: 2),
                        ),
                        child: DropdownButton<Foodtypes>(
                          value: ddturdeger,
                          icon: const Icon(
                            Icons.arrow_downward,
                            color: (Colors.pink),
                          ),
                          elevation: 16,
                          style: const TextStyle(color: Colors.pink),
                          underline: Container(
                            height: 2,
                            color: Colors.pink,
                          ),
                          onChanged: (Foodtypes? newValue) {
                            secilenTur = newValue!.typeId;
                            /*
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

                         */
                          },
                          items: foodTypeList.map<DropdownMenuItem<Foodtypes>>(
                              (Foodtypes value) {
                            return DropdownMenuItem<Foodtypes>(
                              value: value,
                              child: Text(value.typeName),
                              onTap: () {},
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  if (foodIngredientsList.length > 0)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 1 / 1.5),
                          itemCount: foodIngredientsList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2.0,
                                      color: const Color.fromRGBO(
                                          219, 112, 147, 1)),
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
                                        iconSize: 25,
                                        icon: Icon(
                                          Icons.backspace,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      baseUrl +
                                          "${foodIngredientsList[index].ingTypeName}/${foodIngredientsList[index].ingImage}",
                                      width: 100,
                                      height: 45,
                                    ),
                                  ),
                                  Text(
                                    "-${foodIngredientsList[index].ingName}",
                                    style: TextStyle(
                                        fontFamily: "Hellix",
                                        fontSize: 16,
                                        color: Colors.pink.shade700),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '     Malzeme Seçiniz:',
                        style: TextStyle(fontFamily: 'Hellix', fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          openDialog();
                        },
                        child: ClipRRect(
                          child: Image.asset(
                            'assets/bag.png',
                            width: 100,
                            height: 55,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 44,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "     Resminizi yükleyin:",
                        style: TextStyle(fontFamily: 'Hellix', fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          ResimAl();
                        },
                        child: ClipRRect(
                          child: Image.asset(
                            'assets/image.png',
                            width: 100,
                            height: 55,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Tarif',
                    style: TextStyle(fontFamily: 'Hellix', fontSize: 16),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 7.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextFormField(
                      controller: foodRecipeController,
                      maxLines: null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Tarif Yazınız.",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (secilendosya != null)
                    Image.file(
                      File(secilendosya!.path),
                      width: 300,
                      height: 200,
                    ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
