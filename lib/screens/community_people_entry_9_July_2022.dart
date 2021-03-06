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
  final tecEmail = TextEditingController();
  final tecBloodGroup = TextEditingController();
  final tecAddress = TextEditingController();


  var loadData = 0;
  late SharedPreferences prefs;
  // File imageFile2 = File(AssetImage('assets/images/dummy.png').toString());
  late File imageFile;
  // int imageFileInitialized = 0;
  bool _load = false;

  bool addButtonEnable = true;
  var Lib;


  Future<String> saveValues() async {
    return await Future.delayed(Duration(seconds: 2), () async {
      var db = new dbCOn();
      List<int> imageBytes = await imageFile.readAsBytesSync();
      String base64Image = base64Encode(await imageFile.readAsBytes());
      // log("Insert");
      // log(base64Image);
      // log(tecFName.text);

      String sql1 = "INSERT INTO `community_member` "
          "(`MEMBER_NAME`, `MEMBER_FNAME`, `CONTACT_NO`, `PHOTO_FILE`, "
          "`BLOOD_GROUP`, `ADDRESS`, `CREATED_AT`)"
          "VALUES('"+tecName.text+"',"
          "'"+tecFName.text+"',"
          "'"+tecPhone.text+"',"
          "'"+base64Image+"',"
          "'"+selectedValue+"',"
          "'"+tecAddress.text+"',"
          "now())";

      // log(sql1);

      var res = await db.runInsertUpdateSQL(sql1);
      String alertMsg = "Data Saved Successfully for - "+tecFName.text + " (" +tecPhone.text+ ")" ;
      if(res == 0)
      {
      alertMsg = "Data Could Not Saved. Please try again and check internet connection...";
      setState(() {
        addButtonEnable = true;
        loadData = 0;
      });

      }
      else
      {
        Lib.createSnackBar(alertMsg, context);
        setState(() {
          addButtonEnable = true;
          loadData = 0;
        });

        // var route = ModalRoute.of(context)?.settings.name;
        // Navigator.popAndPushNamed(context, route.toString());
      }

      // log(res);

      return alertMsg;
    });

  }

  @override
  void setValue(var i) {
    setState(() {
      loadData = i;
    });
  }

  String selectedValue = '';
  DropdownButton dropBtnKeyVal(var keyValPairs) {
    // List<Map> keyValues = {"A":1, "B":1 };

    List<Map> keyValues = [
      {'Text': 'Select Blood Group', 'Value':''},
      {'Text': 'A', 'Value':'A'},
      {'Text': 'B+', 'Value':'B+'},
      {'Text': 'AB+', 'Value':'AB+'},
      {'Text': 'O+', 'Value':'O+'},
      {'Text': 'A-', 'Value':'A-'},
      {'Text': 'B-', 'Value':'B-'},
      {'Text': 'AB-', 'Value':'AB-'},
      {'Text': 'O-', 'Value':'O-'}, ];
    // Map keyValues = {'A': 'A'}, {'B': 'B'};
    // List<Map> map1 = []; // = {'zero': 0, 'one': 1, 'two': 2};
    return DropdownButton(

      borderRadius:BorderRadius.circular(12),
      underline: Container(), //empty line
      style: TextStyle(fontSize: 18, color: Colors.black),
      dropdownColor: Colors.cyan,
      iconEnabledColor: Colors.red, //Icon color

      isExpanded: true,
      // isDense: true,
      value: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        print(value);
      },

      items: keyValues.map((Map m) {
        return DropdownMenuItem<String>(
          value: m['Value'],
          child: Text(m['Text']),
        );
      }).toList(),

    );
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

      // final bytes = await File(pickedFile.path).readAsBytesSync();
      // String img64 = base64Encode(bytes);

      // log(img64);

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
    Lib = new Library();

    var customTxtB = new customUI();

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBar.crtAppBar("Add New People", context),
      body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10.0),
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
                          // log("sdfsdf");
                          _getFromGallery();
                        }),
                    IconButton(
                        icon: Image.asset('assets/images/camera.jfif'),
                        iconSize: 50,
                        onPressed: () {
                          // log("sdfsdf");
                          _getFromCamera();
                        }),
                  ]),
              customTxtB.customTextBoxCrt(tecName, "Name"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(tecFName, "Father's Name"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(tecPhone, "Cell Phone"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(tecEmail, "Email"),
              SizedBox(height: 10),
              dropBtnKeyVal("BloodGroup"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(tecAddress, "Address"),
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
                    : SizedBox(),
              ),
            ],
          ),
        ),
      )),



      floatingActionButton: FloatingActionButton(
        onPressed: addButtonEnable ? () {
          if (tecName.text == '' || tecFName.text =='' || tecPhone.text == '' ||
              tecAddress.text == '' || _load == false ||
          selectedValue == ''
          ) {
            if (isSnackbarActive == false) {
              isSnackbarActive = true;
              Lib.createSnackBar2("Enter All the values...", context);
            }
          } else {
            setState(() {
              loadData = 1;
              addButtonEnable = false;
            });
          }
        } : null,
//          Lib.createSnackBar("Login Success.. Please try again"+result.toString(), context);
        tooltip: 'Add New People',
        child: Text("Add"),
        // const Icon(Icons.ten_k_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
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


/*
*               Focus(
                child: TextField(
                  controller: tecPhone,

                  decoration: InputDecoration(
                    label: Text("Cell Phone"),
                    border: OutlineInputBorder(),
                    hintText: "Enter Cell Phone Number",
                  ),
                ),
                onFocusChange: (hasFocus) {
                  if(hasFocus) {
                    print("Got  focus");
                    // do stuff
                  }
                  else
                  {
                    if(tecPhone.text != '') {
                      setState(() {
                        validMobileMsg = validateMobile(tecPhone.text);
                      });
                      // validMsg;
                    }
                    // validatePhoneNumber();
                  }
                },
              ),

              validMobileMsg != '' ?
                Text(validMobileMsg)
              : Text(validMobileMsg),
*
* */