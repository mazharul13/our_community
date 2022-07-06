import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:calculator/includes_file.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:convert';



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
  final tecAddress = TextEditingController();

  var loadData = 0;
  late SharedPreferences prefs;
  // File imageFile2 = File(AssetImage('assets/images/dummy.png').toString());
  late File imageFile;
  bool _load = false;

  Future<String> saveValues() async {
    // var db = new dbCOn();
    // String sql = "select * from community where USER_NAME = '" + userID + "' AND CREDENTIAL = '" + passwd + "'";
    // String sql1 = "INSERT INTO `community_member` "
    //     "(`MEMBER_NAME`, `MEMBER_FNAME`, `CONTACT_NO`, `ADDRESS`, `CREATED_AT`)"
    //     "VALUES('"+tecName.text+"',"
    //     "'"+tecFName.text+"',"
    //     "'"+tecPhone.text+"',"
    //     "'"+tecAddress.text+"',";
    //     "now())";

    // log(sql1);
    // var res = await db.runSQL(sql1);
    // log(res.toString());
    // return 0;

    return await Future.delayed(Duration(seconds: 2), () async {
      var db = new dbCOn();
      List<int> imageBytes = await imageFile.readAsBytesSync();
      String base64Image = base64Encode(await imageFile.readAsBytes());
      // print(base64Image);

      String sql1 = "INSERT INTO `community_member` "
          "(`MEMBER_NAME`, `MEMBER_FNAME`, `CONTACT_NO`, `PHOTO_FILE`, `ADDRESS`, `CREATED_AT`)"
          "VALUES('"+tecName.text+"',"
          "'"+tecFName.text+"',"
          "'"+tecPhone.text+"',"
          "'"+base64Image+"',"
          "'"+tecAddress.text+"',"
          "now())";

      // log(sql1);
      var res = await db.runSQL(sql1);
      log(res);
      // SharedPreferences prefs;
      // prefs = await SharedPreferences.getInstance();
      // prefs.clear();

      // var settings = ConnectionSettings(
      //     host: '103.219.147.25',
      //     port: 3306,
      //     user: 'mazharul',
      //     db: 'flutter_test',
      //     password: 'Mz#20BF!t22');
      //
      // var db = MySqlConnection.connect(settings);
      //
      // var userName = "";
      // userName = await db.then((conn) async {
      //   log("conn...==" + sql1);
      //   await conn.query(sql1).then((result) {
      //     for (var r in result) {
      //       // prefs.setString("UserName", r["NAME"]);
      //       // userName = r["NAME"];
      //       // data.add(userName);
      //       // log(r["NAME"].toString());
      //     }
      //     // res = 1;
      //     // return 1;
      //   });
      //   // prefs.reload();
      //   return "tttttt";
      // });
      // data.add(Text(userName));
      // return userName;
      return res;
    });

  }

  @override
  void setValue(var i) {
    setState(() {
      loadData = i;
    });
  }

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

      final bytes = await File(pickedFile.path).readAsBytesSync();
      String img64 = base64Encode(bytes);

      print(img64);

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
              customTxtB.customTextBoxCrt(tecName, "Name"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(tecFName, "Father's Name"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(tecPhone, "Cell Phone"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(tecAddress, "Village"),
              SizedBox(height: 10),
              Container(
                child: loadData == 1
                    ? FutureBuilder(
                  builder:
                      (BuildContext context, AsyncSnapshot snapshot) {
                    // Checking if future is resolved or not
                    if (snapshot.connectionState ==
                        ConnectionState.done) {
                      // If we got an error
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: TextStyle(fontSize: 10),
                          ),
                        );

                        // if we got our data
                      } else if (snapshot.hasData) {
                        // log(snapshot.data[0]);
                        // Extracting data from snapshot object
                        final data = snapshot.data as String;
                        return Center(
                          child: Text(
                            '$data',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }
                    }

                    // Displaying LoadingSpinner to indicate waiting state
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },

                  // Future that needs to be resolved
                  // inorder to display something on the Canvas
                  future: saveValues(),
                )
                    : Text("Waiting for login..."),
              ),
            ],
          ),
        ),
      )),



      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (tecName.text == '' || tecFName.text =='' || tecPhone.text == '' || tecAddress.text == '') {
            Lib.createSnackBar("Enter All the values...", context);
          } else {
            setState(() {
              loadData = 1;
            });
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
