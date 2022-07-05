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

  String selectval = "company";
  DropdownButton dropBtn2() {
    // map1.forEach((k,v) => log('${k}: ${v}'));
    List map1 = [
      {'name': 'Individual', 'value': 'individual'},
      {'name': 'Company', 'value': 'company'}
    ];
    return DropdownButton(
      value: selectval, //implement initial value or selected value
      onChanged: (value){
        setState(() { //set state will update UI and State of your App
          selectval = value.toString(); //change selectval to new value
        });
      },
      items: map1.map((map) {
        return DropdownMenuItem(
          child: Text(map['name']),
          value: map['value'],
        );
      }).toList(),
      // onChanged:(value) {log(value.toString());},
    );
  }


  Future<List<String>> getData(var id, var passwd) async {
    List<String> data = [];

    prefs = await SharedPreferences.getInstance();
    prefs.setString("NAME", "Test Name");
    // prefs.clear();

    return await Future.delayed(Duration(seconds: 2), () async {
      // var db = new dbCOn();
      String sql = "select * from community where USER_NAME = '" +
          id +
          "' AND CREDENTIAL = '" +
          passwd +
          "'";
      sql = "select * from community";
      log(sql);

      // SharedPreferences prefs;
      // prefs = await SharedPreferences.getInstance();
      // prefs.clear();

      var settings = ConnectionSettings(
          host: '103.219.147.25',
          port: 3306,
          user: 'mazharul',
          db: 'flutter_test',
          password: 'Mz#20BF!t22');

      var db = MySqlConnection.connect(settings);

      var userName = "";
      userName = await db.then((conn) async {
        log("conn...==" + sql);
        await conn.query(sql).then((result) {
          for (var r in result) {
            prefs.setString("UserName", r["NAME"]);
            userName = r["NAME"];
            data.add(userName);
            // log(r["NAME"].toString());
          }
          // res = 1;
          // return 1;
        });
        // prefs.reload();
        return prefs.getString("UserName").toString();
      });
      // data.add(Text(userName));
      // return userName;
      return data;
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
              customTxtB.customTextBoxCrt(txtEditContr1, "User ID"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(txtEditContr2, "Password"),
              SizedBox(height: 10),
              dropBtn2(),
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
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, int index) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://media-exp2.licdn.com/dms/image/C5603AQF4L_AaIPrOZA/profile-displayphoto-shrink_100_100/0/1615744394235?e=1661385600&v=beta&t=DNCZkN8em8xKyx1m1q5P-6lnpxpcXc3ITBsvK6ZJE0k"),
                                    ),
                                    title: Text(snapshot.data[index]),
                                    subtitle: Text(snapshot.data[index]),
                                    onTap: () {
                                      prefs.setString("NAME", snapshot.data[index].toString());
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                  snapshot.data[index])));
                                    },
                                  );
                                },
                              );
                              // return Center(
                              //   child: Text(
                              //     '$data',
                              //     style: TextStyle(fontSize: 18),
                              //   ),
                              // );
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
                    : Text("Waiting for login..."),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (txtEditContr1.text == '') {
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

//       floatingActionButton: FloatingActionButton(
//         onPressed: LoginCheckfn(),
// //          Lib.createSnackBar("Login Success.. Please try again"+result.toString(), context);
//         tooltip: 'Login',
//         child: Text("Login"),
//         // const Icon(Icons.ten_k_outlined),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
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
