import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:calculator/includes_file.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:convert';

class CommunityEntryScreen extends StatefulWidget {
  @override
  State<CommunityEntryScreen> createState() => CommunityEntry();
}

enum ImageSourceType { gallery, camera }

class CommunityEntry extends State<CommunityEntryScreen> {
  var _formKey = GlobalKey<FormState>();
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
  bool isLoading = false;

  bool addButtonEnable = true;
  var Lib;
  String dataSavingMsg = 'Please Enter All the values and press Add button';

  Future<String> saveValues() async {
    return await Future.delayed(Duration(seconds: 2), () async {
      var Lib = new Library();
      var db = new dbCOn();
      List<int> imageBytes = await imageFile.readAsBytesSync();
      String base64Image = base64Encode(await imageFile.readAsBytes());
      // log("Insert");
      // log(base64Image);
      // log(tecFName.text);

      //Check duplicate mobile number...
      String mobileCheckSQL = "SELECT CONTACT_NO FROM community_member "
              "WHERE CONTACT_NO = '" +
          mobileNumberInputString +
          "'";

      var res = await db.runSQL(mobileCheckSQL);
      print(res.length);

      if (res.length > 0) {
        ///Duplicate mobile number found {
        // log("3333333333");
        setState(() {
          addButtonEnable = true;
          isLoading = false;
          dataSavingMsg =
          "Phone/Mobile number has already been given by someone else. Please enter another...";
          addButtonEnable = true;
          Lib.createSnackBar(dataSavingMsg, context);
        });
        return dataSavingMsg;
      }else {
        String sql1 = "INSERT INTO `community_member` "
            "(`MEMBER_NAME`, `MEMBER_FNAME`, `CONTACT_NO`, `PHOTO_FILE`, "
            "`BLOOD_GROUP`, `ADDRESS`, `CREATED_AT`)"
            "VALUES('" +
            tecName.text +
            "',"
                "'" +
            tecFName.text +
            "',"
                "'" +
            mobileNumberInputString +
            "',"
                "'" +
            base64Image +
            "',"
                "'" +
            selectedValue +
            "',"
                "'" +
            tecAddress.text +
            "',"
                "now())";

        // log(sql1);

        res = await db.runInsertUpdateSQL(sql1);
        dataSavingMsg = "Data Saved Successfully for - " +
            tecFName.text +
            " (" +
            mobileNumberInputString +
            ")";
        if (res == 0) {
          setState(() {
            isLoading = false;
            dataSavingMsg =
            "Data Could Not Saved. Please try again and check internet connection...";
            addButtonEnable = true;
            Lib.createSnackBar(dataSavingMsg, context);
//        loadData = 0;
          });
        } else {
          // Lib.createSnackBar(dataSavingMsg, context);
          Lib.createSnackBar(dataSavingMsg, context);
          setState(() {
            isLoading = false;
            tecName.text = '';
            tecFName.text = '';
            tecPhone.text = '';
            tecAddress.text = '';
            tecEmail.text = '';
            selectedValue = '';
            addButtonEnable = true;
            loadData = 0;
            _load = false;
            dataSavingMsg =
            'Enter new people information and press Add buttion';
          });
          // var route = ModalRoute.of(context)?.settings.name;
          // Navigator.popAndPushNamed(context, route.toString());
        }

        // log(res);
      }
      return dataSavingMsg;
    });
  }

  @override
  void setValue(var i) {
    setState(() {
      loadData = i;
    });
  }

  String selectedValue = '';
  String mobileNumberInputString = '';

  InputDecorator dropBtnKeyVal(var keyValPairs) {
    // List<Map> keyValues = {"A":1, "B":1 };
    List<Map> keyValues = [
      {'Text': 'Select Blood Group', 'Value': ''},
      {'Text': 'A', 'Value': 'A'},
      {'Text': 'B+', 'Value': 'B+'},
      {'Text': 'AB+', 'Value': 'AB+'},
      {'Text': 'O+', 'Value': 'O+'},
      {'Text': 'A-', 'Value': 'A-'},
      {'Text': 'B-', 'Value': 'B-'},
      {'Text': 'AB-', 'Value': 'AB-'},
      {'Text': 'O-', 'Value': 'O-'},
    ];
    // Map keyValues = {'A': 'A'}, {'B': 'B'};
    // List<Map> map1 = []; // = {'zero': 0, 'one': 1, 'two': 2};
    return InputDecorator(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          borderRadius: BorderRadius.circular(8),

          underline: Container(),
          //empty line
          style: TextStyle(fontSize: 15, color: Colors.black),
          dropdownColor: Colors.cyan,
          iconEnabledColor: Colors.red,
          //Icon color

          isExpanded: true,
          // isDense: true,
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value.toString();
            });
            print(value);
          },

          items: keyValues.map((Map m) {
            return DropdownMenuItem<String>(
              value: m['Value'],
              child: Text(m['Text']),
            );
          }).toList(),
        ),
      ),
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
      body: Form(
      key: _formKey,
      child: SingleChildScrollView(
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

              IntlPhoneField(
                controller: tecPhone,
                validator: (phone) {
                  // print(validatorMessage);

                },
                // keyboardType: TextInputType.emailAddress,
                initialCountryCode: 'BD',
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                onChanged: (phone) {

                  print(phone.completeNumber);
                  // print(IntlPhoneField().invalidNumberMessage);
                  mobileNumberInputString = phone.completeNumber.toString();

                  // tecPhone.text = phone.completeNumber;
                  // print(tecPhone.);
                },
                onCountryChanged: (country) {
                  print('Country changed to: ' + country.name);
                },
              ),

              SizedBox(height: 10),
              // customTxtB.customTextBoxCrt(tecPhone, "Cell Phone"),

              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(tecEmail, "Email"),
              SizedBox(height: 10),
              dropBtnKeyVal("BloodGroup"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(tecAddress, "Address"),
              SizedBox(height: 10),

              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(dataSavingMsg),
            ],
          ),
        ),
      )
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addButtonEnable == true
            ? () {
                if (tecName.text == '' ||
                    tecFName.text == '' ||
                    tecPhone.text == '' ||
                    tecAddress.text == '' ||
                    _load == false ||
                    selectedValue == '' ||
                    _formKey.currentState?.validate() == false) {
                  if (isSnackbarActive == false) {
                    isSnackbarActive = true;
                    Lib.createSnackBar2("Enter right values in all the fields...", context);
                  }
                } else {



                  setState(() {
                    isLoading = true;
                    loadData = 1;
                    addButtonEnable = false;
                  });
                  saveValues();
                }
              }
            : null,
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
