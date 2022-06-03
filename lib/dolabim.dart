import 'dart:convert';
import 'package:bak_pisir/MyIngredients.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  late List<MyIngredients> ingredientsList = [];



  //Checkbox için bir liste tanımlandı
  late List<bool> _isChecked;
  late TextEditingController controller;


  // Initial Selected Value
  String dropdownvalue = 'Sebzeler';

  // List of items in our dropdown menu
  var turler = [
    'Sebzeler',
    'Etler',
    'Baharatlar',
    'Meyveler',
    'Çeşitli',
  ];
  var ikinci = [
    'kabak',
    'patlıcan',
    'lahana',
    'Çeşitli',
  ];


  Future<List<MyIngredients>> MyIngredientsGet(String a) async {
    var url = Uri.parse("http://213.14.130.80/bakpisir/MyIngredientsGet.php");
    var veri = {"userID": a};
    var cevap = await http.post(url, body: veri);
    return parseMyIngredientsCevap(cevap.body);
  }

  Future<void> MyIngredientsGoster() async {
    ingredientsList =
    await MyIngredientsGet(widget.aktifKullanici.userId.toString());
    //Checkbox için tanımlanan listeye malzemeler listesi uzunlugunda false atandı
    _isChecked = List<bool>.filled(ingredientsList.length, false);
    setState(() {});
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

  Future <String?> openDialog() =>
      showDialog <String>(

          context: context,
          builder: (context) =>
              AlertDialog(

                title: Text("Eklenecek Malzeme Girin"),


                /*
                DropdownButton(


                  // Initial Value
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: turler.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {


                    setState(() {
                      dropdownvalue = newValue!;
                    });

                  },
                ),

*/
                content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: "Dolapta ne var?",),
          controller: controller,
    ),
    actions: [
      TextButton(onPressed: (){
        insertMyIngredients(widget.aktifKullanici.userId.toString(),controller.text);
        Navigator.of(context).pop();

      }, child: Text("Ekle"))
    ]
              ));

  @override
  void initState() {
    super.initState();
    MyIngredientsGoster();


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
                width: ekranGenisligi * 0.8,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 1),
                    itemCount: ingredientsList.length,
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
                  children: [
                    ElevatedButton(
                        child: Text("Malzeme Sil"),
                        onPressed: () {
                          for (var i = 0; i < ingredientsList.length; i++) {
                            if (_isChecked[i]) {
                              var ingID = ingredientsList[i].ingID;


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