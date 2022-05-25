import 'package:bak_pisir/tarifSayfasi.dart';
import 'package:flutter/material.dart';

import 'Widgets/MyDrawer.dart';

class dolabim extends StatefulWidget {
  const dolabim({Key? key}) : super(key: key);

  @override
  State<dolabim> createState() => _dolabimState();
}

class _dolabimState extends State<dolabim> {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  //malzemeleri birimleri ile birlikte listelemek istersek böyle yapalım (1)
  var malzemeler = ["Malzeme 1" , "Malzeme 2", "Malzeme 3","Malzeme 4"];
  var secilimalzemeler =[];

  //Checkbox için bir liste tanımlandı
  late List<bool> _isChecked;

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    //Checkbox için tanımlanan listeye malzemeler listesi uzunlugunda false atandı
    _isChecked = List<bool>.filled(malzemeler.length, false);
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
      drawer: MyDrawer(),
      key:scaffoldKey,

      body: Column(
        children: [
          Center(
            child: SizedBox(
              height: ekranYuksekligi*0.8,
              width: ekranGenisligi*0.8,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2/1),
                  itemCount: malzemeler.length,
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
                          Text("-------${malzemeler[index]}"),
                           ///Text(malzemeler[index])
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
                    for(var i=0; i<malzemeler.length;i++){
                      if(_isChecked[i])
                        {
                          malzemeler.remove(i);
                          setState(() {
                            print(malzemeler);
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
        ekle();

      }, child: Text("Ekle"))
    ],
  ));
  void ekle(){
    Navigator.of(context).pop(controller.text);

  }
}