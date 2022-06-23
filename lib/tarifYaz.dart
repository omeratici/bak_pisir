import 'dart:convert';

import 'package:bak_pisir/BakpisirStrings.dart';
import 'package:bak_pisir/Foodtypes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'FoodtypesCevap.dart';
import 'Ingredients.dart';
import 'IngredientsCevap.dart';
import 'Users.dart';
import 'dart:io';
import 'dart:math';
import 'package:random_string/random_string.dart';

class tarifYaz extends StatefulWidget {
  Users aktifKullanici;
  tarifYaz(this.aktifKullanici);
  //const tarifYaz({Key? key}) : super(key: key);

  @override
  State<tarifYaz> createState() => _tarifYazState();
}

class _tarifYazState extends State<tarifYaz> {
  var baseUrl = BakpisirStrings().baseUrl;
  Foodtypes ddturdeger = Foodtypes(0, "Türler Yükleniyor", "typeImage");
  List<Foodtypes> foodTypeList = [];
  var foodNameController = TextEditingController();
  var foodTypeSelectController = TextEditingController();
  var foodRecipeController = TextEditingController();
  late List<Ingredients> foodIngredientsList = [];
  PickedFile? secilendosya;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  late var secilenTur;
  late Set<String> turList = {"sebze"};
  late String dropdownturListDeger = turList.first;
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
  void malzemeEkle() async {
    var a = await openDialog();
    setState(() {});
  }

  dosyagonder() async {
    var request = http.MultipartRequest("POST", Uri.parse(baseUrl));
    request.fields['dosyaadi'] = 'resim1';
    request.fields['tur'] = 'resim';

    Map<String, String> headers = {"yetki": "omer", "id": "1"};
    request.headers.addAll(headers);
    //'assets/load.gif'
    var image = http.MultipartFile.fromBytes('resim',
        (await rootBundle.load(secilendosya!.path)).buffer.asUint8List(),
        filename: "omer");
    request.files.add(image);

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = await String.fromCharCodes(responseData);
    print(result);
  }


  Future<void> uploadImage(foodImage) async {
    var uploadurl = Uri.parse(baseUrl+'uploadImage.php');
    try{
      List<int> imageBytes = File(secilendosya!.path).readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      var response = await http.post(
          uploadurl,
          body: {
            'image': baseimage,
            'fileName': foodImage,
          }
      );
      if(response.statusCode == 200){
        var jsondata = json.decode(response.body);
        if(jsondata["error"]){
          print(jsondata["msg"]);
        }else{
          print("Fotograf Upload successful");
        }
      }else{
        print(" Fotograf Error during connection to server");
      }
    }catch(e){
      print("Fotograf Error during converting to Base64");
    }
  }
  // doyagonderdio (){
  //   FormData formData = new FormData.from({
  //     "name": "wendux",
  //     "file1": new UploadFileInfo(new File("./upload.jpg"), "upload1.jpg")
  //   });
  //   response = await dio.post("/info", data: formData)
  //
  // }

  Future<void> insertFood(
      String userID, String recipe, String typeId, String foodName) async {
    var rng = Random();
    var a = randomAlphaNumeric(10);
    var foodImage = rng.nextInt(999999999).toString()+".jpg";
    uploadImage(a);
    var url = Uri.parse(baseUrl + "insert_Food.php");
    var ingList =[];


    for (var i in foodIngredientsList){
      ingList.add ({
        "foodingID": "",
        "ingID": i.ingID.toString(),
        "foodImage": foodImage,
        "unitID": "1",
        "quantity": "1",
        "foodID":"",
      });
    }
    var veri = {
      "authorId": userID,
      "recipe": recipe,
      "foodImage": "yemekfoto/"+a,
      "typeId": typeId,
      "foodName": foodName,
      "foodIngredientsList":ingList.toString(),

    };
    print("**********");
    print(veri.toString());


    var cevap = await http.post(url, body: veri);
    var jsonVeri = json.decode(cevap.body);
    if (jsonVeri["success"] as int == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt Başarılı")),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt Başarısız Tekrar Deneyin")),
      );
    }
    print(cevap.body.toString());
  }
  Future<void> insertFoodIngredients(
      String userID, String recipe, String typeId, String foodName) async {
    var url = Uri.parse(baseUrl + "insert_Food.php");
    for (var i in foodIngredientsList){
      var veri = {
        "foodingID": "",
        "ingID": recipe,
        "foodImage": "kabak.jpg",
        "typeId": typeId,
        "foodName": foodName,
      };
    }
    var veri = {
      "authorId": userID,
      "recipe": recipe,
      "foodImage": "kabak.jpg",
      "typeId": typeId,
      "foodName": foodName,
    };
    var cevap = await http.post(url, body: veri);
    var jsonVeri = json.decode(cevap.body);
    if (jsonVeri["success"] as int == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt Başarılı")),
      );
      setState(() {});
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
                        height: 57,
                        width: 130,
                        child: TextFormField(
                          maxLines: 8,
                          controller: foodNameController,
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
                            ddturdeger = newValue;
                            setState(() {});

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
                                  crossAxisCount: 3, childAspectRatio: 1 / 1.6),
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
                                        iconSize: 20,
                                        icon: Icon(
                                          Icons.backspace,
                                        ),
                                        onPressed: () {
                                          //todo silemei,şlemi yap
                                          foodIngredientsList.removeAt(index);
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/load.gif',
                                      image: baseUrl +
                                          "${foodIngredientsList[index].ingTypeName}/${foodIngredientsList[index].ingImage}",
                                      width: 100,
                                      height: 45,
                                    ),
                                  ),
                                  Text(
                                    "${foodIngredientsList[index].ingName}",
                                    style: TextStyle(
                                        fontFamily: "Hellix",
                                        fontSize: 13,
                                        color: Colors.pink.shade700),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),

                  //Malzeme Seçimi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '     Malzeme Seçiniz:',
                        style: TextStyle(fontFamily: 'Hellix', fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          malzemeEkle();
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
                  //Resim Yükleme
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
                  SizedBox(height: 18),
                  if (secilendosya != null)
                    Image.file(
                      File(secilendosya!.path),
                      width: 300,
                      height: 200,
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

                  SizedBox(height: 40),

                  InkWell(
                    onTap: () {

                      if(secilendosya == null){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Bir Resim Ekleyin")),
                        );
                      }else if (foodRecipeController.text.length < 10){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Tarifinizi Yazınız")),
                        );
                      }else if(foodNameController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Yemeğinizin adını yazınız")),
                        );
                      }else if (foodIngredientsList.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Yemeğinizin mlzemelerini ekleyin")),
                        );
                      }else{
                        insertFood(widget.aktifKullanici.userName, foodRecipeController.text, ddturdeger.typeId.toString(), foodNameController.text);
                        }
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
                          "Tarifi Ekle",
                          style: TextStyle(
                            fontFamily: 'Hellix',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  SizedBox(
                    height: 18,
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
