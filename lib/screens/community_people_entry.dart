import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:calculator/includes_file.dart';
import 'package:mysql1/mysql1.dart';

import 'dart:io'; // for File

class CommunityEntryScreen extends StatefulWidget {
  @override
  State<CommunityEntryScreen> createState() => CommunityEntry();
}

enum ImageSourceType { gallery, camera }

class CommunityEntry extends State<CommunityEntryScreen> {
  final txtEditContr1 = TextEditingController();
  final txtEditContr2 = TextEditingController();
  final loginResultxt = TextEditingController();

  final tecName = TextEditingController();
  final tecFName = TextEditingController();
  final tecPhone = TextEditingController();
  final tecVillage = TextEditingController();

  var loadData = 0;
  late SharedPreferences prefs;

  @override
  void setValue(var i) {
    setState(() {
      loadData = i;
    });
  }

  // File imageFile = File('assets/images/dummy.png');
  late File imageFile;
  bool _load = false;

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      // File imageFile = File(pickedFile.path);
      log(pickedFile.path);

      setState(() {
        imageFile = File(pickedFile.path);
        _load = true;
      });
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      // File imageFile = File(pickedFile.path);
      setState(() {
        imageFile = File(pickedFile.path);
        _load = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var Lib = new Library();

    var customTxtB = new customUI();

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBar.crtAppBar("Add New People", context),
      body: SingleChildScrollView(
      child: Container(
        // padding: const EdgeInsets.all(8.0),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _load == false
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset('assets/images/dummy.png'),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(imageFile,
                          width: 200, height: 200, fit: BoxFit.fill),
                    ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Image.asset('assets/images/gallery.jfif'),
                        iconSize: 50,
                        onPressed: () {
                          log("sdfsdf");
                          _getFromGallery();
                        }),
                    IconButton(
                        icon: Image.asset('assets/images/camera.jfif'),
                        iconSize: 50,
                        onPressed: () {
                          log("sdfsdf");
                          _getFromCamera();
                        }),
                  ]),
              customTxtB.customTextBoxCrt(txtEditContr1, "Name"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(txtEditContr1, "Father's Name"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(txtEditContr2, "Cell Phone"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(txtEditContr2, "Village"),
              SizedBox(height: 10),
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (txtEditContr1.text == '') {
            Lib.createSnackBar("Enter All the values...", context);
          } else {
            setValue(1);
          }
        },
//          Lib.createSnackBar("Login Success.. Please try again"+result.toString(), context);
        tooltip: 'Add New People',
        child: Text("Add"),
        // const Icon(Icons.ten_k_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DetailPage extends StatefulWidget {
  final userInfo;

  DetailPage(this.userInfo);

  @override
  _MyHomePageState createState() {
    log(userInfo);
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<DetailPage> {
  String s = "ert";
  int i = 0;

  // retrieve() async{
  //   setState(() {
  //
  //   });
  // }
  //
  getValue() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    s = prefs.getString("NAME").toString();
    i = 1;
    // log(s);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var Lib = new Library();

    if (i == 0) getValue();

    log(s);
    var customTxtB = new customUI();
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Detail page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // children: <Widget>[Text(userInfo[0].data.toString()), Text(s.toString())],
            children: <Widget>[Text("Test getter..."), Text(s.toString())],
          ),
        ),
      ),
    );
  }
}
