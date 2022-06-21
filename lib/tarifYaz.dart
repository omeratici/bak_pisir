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
  Foodtypes ddturdeger = Foodtypes(0, "Türler Yükleniyor", "typeImage") ;
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

  void ResimAl () async{
    final picker = ImagePicker();
    final secilen = await picker.pickImage(source: ImageSource.gallery);

    setState((){
    if(secilen != null){
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
    foodTypeList =
    await typesGet();
    ddturdeger = await foodTypeList[0];
    setState(() {});
  }

  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.height * 0.8,
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
                            child: Text(value),
                            onTap: () {},
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
                    ],
                  ),
                );
              }),
          title: const Text("Eklenecek Malzeme Girin"),
          actions: [
            TextButton(
                onPressed: () {
                  foodIngredientsList.add(dropdownDeger);
                  setState((){

                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Ekle"))
          ]));

 @override
 void initState() {
   super.initState();
   IngredientsGet();
   FoodTypeGoster();
 }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/kayit.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [

          Container(
            padding: EdgeInsets.only(left: 35, top: 130),
            child: Text(
              "Tarif",
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5,
                  right: 35,
                  left: 35),
              child: Column(
                children: [
                  Text("Yemek Türünü Giriniz"),
                  DropdownButton<Foodtypes>(
                    value: ddturdeger,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
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
                    items: foodTypeList
                        .map<DropdownMenuItem<Foodtypes>>((Foodtypes value) {
                      return DropdownMenuItem<Foodtypes>(
                        value: value,
                        child: Text(value.typeName),
                        onTap: () {},
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 40),
                  if(foodIngredientsList.length>0)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width:  MediaQuery.of(context).size.width * 0.9,
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
                                        iconSize: 25,
                                        icon: Icon(
                                          Icons.backspace,
                                        ),
                                        onPressed: () {


                                        },
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

                  ElevatedButton(
                    onPressed: () {
                      openDialog();
                    },
                    child: const Text('Malzeme Ekle'),
                    style: ElevatedButton.styleFrom(
                        primary: (Color.fromRGBO(229, 57, 53, 1)),
                        fixedSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                  TextFormField(
                    controller: foodTypeSelectController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Yemek Adını Giriniz',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: Colors.grey.shade100,
                        filled: true),
                  ),
                  TextFormField(
                    controller: foodRecipeController,
                    maxLines: null,

                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Tarifi Yazınız',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: Colors.grey.shade100,
                        filled: true),
                  ),

                  if (secilendosya != null)
                    Image.file(
                      File(secilendosya!.path),
                      width: 300,
                      height: 200,

                    ),

                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      ResimAl();
                    },
                    child: const Text('Resim Al'),
                    style: ElevatedButton.styleFrom(
                        primary: (Color.fromRGBO(229, 57, 53, 1)),
                        fixedSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),





                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
