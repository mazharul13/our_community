import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:calculator/includes_file.dart';
import 'package:mysql1/mysql1.dart';



class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => LoginScreenReal();
}

class LoginScreenReal extends State<LoginScreen> {
  final txtEditContr1 = TextEditingController();
  final txtEditContr2 = TextEditingController();
  final loginResultxt = TextEditingController();
  var loadData = 0;
  late SharedPreferences prefs;
  @override
  void setValue(var i) {
    setState(() {
      loadData = i;
    });
  }

  Future<String> getData(var id, var passwd) async {

    prefs = await SharedPreferences.getInstance();
    // prefs.setString("NAME", "Test Name");
    // prefs.clear();

    // log("dddddd");

    return await Future.delayed(Duration(seconds: 2), () async {
      var db = new dbCOn();
      var Lib = new Library();
      String sql = "select MEMBER_NAME, MEMBER_FNAME, ADDRESS, CONTACT_NO from community_member where CONTACT_NO = '" +
          id +
          "' AND PASS_WORD = '" +
          passwd +
          "'";
      log(sql);
      var res = await db.runSQL(sql);
      if(res.length > 0)
        {
          Lib.createSnackBar("Login successfull...", context);
          for (var r in res) {
                   prefs.setString("UserName", r["MEMBER_NAME"]);
                   prefs.setString("FathersName", r["MEMBER_FNAME"]);
                   prefs.setString("ContactNo", r["CONTACT_NO"]);
                   prefs.setString("Address", r["ADDRESS"]);
                   // log(r["NAME"].toString());
          }

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) => MyProfilePageScreen()
              )
          );
          // setState(() {
          //
          // });
        }
      else
        {
          Lib.createSnackBar("Login Failed. Pls try again...", context);
        }

      setState(() {
        loadData = 0;
      });
      // sql = "select * from community";
      log(sql);


      return "Login tried...";
    });
  }



  @override
  Widget build(BuildContext context) {


    var Lib = new Library();

    var customTxtB = new customUI();

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBar.crtAppBar("Login Please", context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Please enter your credentials...',
              ),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(txtEditContr1, "Contact Number with Country Code"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(txtEditContr2, "Password", passField: 1),
              SizedBox(height: 10),
              Expanded(
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
                                  style: TextStyle(fontSize: 18),
                                ),
                              );

                              // if we got our data
                            } else if (snapshot.hasData) {
                              // log(snapshot.data[0]);
                              // Extracting data from snapshot object
                              // final data = snapshot.data as String;
                              return Center(
                                child: Text(
                                  snapshot.data,
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
                        future: getData(txtEditContr1.text, txtEditContr2.text),
                      )
                    : SizedBox(height: 10),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (txtEditContr1.text == '' || txtEditContr2.text == '') {
            Lib.createSnackBar("Please enter credential", context);
          } else {
            setValue(1);
          }
        },
//          Lib.createSnackBar("Login Success.. Please try again"+result.toString(), context);
        tooltip: 'Login',
        child: Text("Login"),
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

    // if (i == 0) getValue();

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
