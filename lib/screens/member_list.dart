import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:calculator/includes_file.dart';
import 'package:mysql1/mysql1.dart';

class MemberListScreen extends StatefulWidget {
  @override
  State<MemberListScreen> createState() => MemberList();
}

enum ImageSourceType { gallery, camera }

class MemberList extends State<MemberListScreen> {

  Future<String> saveValues() async {
    // var db = new dbCOn();
    // String sql = "select * from community where USER_NAME = '" + userID + "' AND CREDENTIAL = '" + passwd + "'";

    String sql = "33333";

    // log(sql1);
    // var res = await db.runSQL(sql1);
    // log(res.toString());
    // return 0;

    return await Future.delayed(Duration(seconds: 2), () async {
      return "sdsdf";
      var db = new dbCOn();

      // log(sql1);
      var res = await db.runSQL(sql);
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
    return "sdsdf";
  }



  @override
  Widget build(BuildContext context) {
    var Lib = new Library();

    var customTxtB = new customUI();

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBar.crtAppBar("Member List", context),
      body: SingleChildScrollView(
          child: Container(
            // padding: const EdgeInsets.all(8.0),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    child: FutureBuilder(
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
                  ),
                ],
              ),
            ),
          )),



    );
  }

}