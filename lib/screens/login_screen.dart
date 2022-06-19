import 'dart:developer';

import 'package:calculator/includes_file.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => LoginScreenReal();
}

class LoginScreenReal extends State<LoginScreen> {
  final txtEditContr1 = TextEditingController();
  final txtEditContr2 = TextEditingController();
  final loginResultxt = TextEditingController();
  var loadData = 0;

  @override
  void setValue(var i) {
    setState((){
      loadData = i;
    });

  }

  Future<String> getData(var id, var passwd) {
    return Future.delayed(Duration(seconds: 2), () {
      var db = new dbCOn();
      String sql = "select * from community where USER_NAME = '" + id + "' AND CREDENTIAL = '" + passwd + "'";

      var loginOK = db.runSQL(sql);
      if(loginOK == 1)
      {

      }
      return "I am data";
      // throw Exception("Custom Error");
    });
  }


  @override
  Widget build(BuildContext context) {
    var Lib = new Library();

    var customTxtB = new customTextBox();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Login please..."),
      ),
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
loadData == 1 ?
          FutureBuilder(
            builder: (ctx, snapshot) {
              // Checking if future is resolved or not
              if (snapshot.connectionState == ConnectionState.done) {
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
            future: getData(txtEditContr1.text, txtEditContr2.text),
          ) : Text("Nothing..."),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {setValue(1);},
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


  LoginCheckfn()
  {
    FutureBuilder(
      builder: (ctx, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
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
      future: getData(txtEditContr1.text, txtEditContr2.text),
    );
  }

}








class LoginCheckPage extends StatelessWidget {

  var id, passwd;


  LoginCheckPage(var t1, var t2) {
    id = t1;
    passwd = t2;
  }
  /// Function that will return a
  /// "string" after some time
  /// To demonstrate network call
  /// delay of [2 seconds] is used
  ///
  /// This function will behave as an
  /// asynchronous function
  Future<String> getData() {
    return Future.delayed(Duration(seconds: 2), () {
      var db = new dbCOn();
      String sql = "select * from community where USER_NAME = '" + id + "' AND CREDENTIAL = '" + passwd + "'";

      var loginOK = db.runSQL(sql);
      if(loginOK == 1)
        {

        }
      return "I am data";
      // throw Exception("Custom Error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Future Demo Page'),
        ),
        body: FutureBuilder(
          builder: (ctx, snapshot) {
            // Checking if future is resolved or not
            if (snapshot.connectionState == ConnectionState.done) {
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
          future: getData(),
        ),
      ),
    );
  }
}
