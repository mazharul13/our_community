import 'dart:developer';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'includes_file.dart';



class dbCOn {
  // Open a connection (testdb should already exist)
  Future<MySqlConnection> getConnection() {
    var settings = ConnectionSettings(
        host: '103.219.147.25',
        port: 3306,
        user: 'mazharul',
        db: 'flutter_test',
        password: 'Mz#20BF!t22');
    return MySqlConnection.connect(settings);
  }



  Future getMemberList(var sql) async {

    List<Map> map1 = []; // = {'zero': 0, 'one': 1, 'two': 2};
    Map m = {}; //{'zero': 0, 'one': 1, 'two': 2};
    try{
      await getConnection().then((conn) async {
        log("conn...=="+sql);
        await conn.query(sql).then((result) {
           // print({'type':result});
          // print(json.decode(result));

          for (var r in result) {
            m = {"MEMBER_NAME": r["MEMBER_NAME"], "CONTACT_NO": r["CONTACT_NO"],
              "ADDRESS": r["ADDRESS"], "BLOOD_GROUP": r["BLOOD_GROUP"],
              "MEMBER_FNAME": r["MEMBER_FNAME"], "MEMBER_SINCE": r["MEMBER_SINCE"]
            };
            map1.add(m);
          }
        });
      });
    }
    catch(err){
      print(err.runtimeType);
    }
    // log(map1.length.toString()+"3333");
    return map1;
  }

  Future getMemberList_withDetails(var sql) async {

    List<Map> map1 = []; // = {'zero': 0, 'one': 1, 'two': 2};
    Map m = {}; //{'zero': 0, 'one': 1, 'two': 2};
    try{
      await getConnection().then((conn) async {
        log("conn...=="+sql);
        await conn.query(sql).then((result) {
          // print({'type':result});
          // print(json.decode(result));

          for (var r in result) {
            m = {"MEMBER_NAME": r["MEMBER_NAME"], "CONTACT_NO": r["CONTACT_NO"],
              "ADDRESS": r["ADDRESS"], "BLOOD_GROUP": r["BLOOD_GROUP"],
              "MEMBER_FNAME": r["MEMBER_FNAME"], "MEMBER_SINCE": r["MEMBER_SINCE"],
              "ENTRY_DT1": r["ENTRY_DT1"], "PAY_DATE1": r["PAY_DATE1"],
              "MEMBER_SINCE_FORMATTED": r["MEMBER_SINCE_FORMATTED"], "PAY_DATE1_FORMATTED": r["PAY_DATE1_FORMATTED"],
              "PAY_DATE2": r["PAY_DATE2"], "ISSUE_TITLE": r["ISSUE_TITLE"],
              "ISSUE_DATES": r["ISSUE_DATES"], "AMOUNT": r["AMOUNT"],
            };
            map1.add(m);
          }
        });
      });
    }
    catch(err){
      print(err.runtimeType);
    }
    // log(map1.length.toString()+"3333");
    return map1;
  }


  Future<List<Map>> getIssues(var sql) async {

    List<Map> map1 = []; // = {'zero': 0, 'one': 1, 'two': 2};
    Map m = {}; //{'zero': 0, 'one': 1, 'two': 2};
    try{
      await getConnection().then((conn) async {
        log("conn...=="+sql);
        await conn.query(sql).then((result) {
          // print({'type':result});
          // print(json.decode(result));
          m = {"ISSUE_ID": "", "ISSUE_TITLE": "Select One Issue",
            "ISSUE_DATES": ""};
          map1.add(m);
          for (var r in result) {
            m = {"ISSUE_ID": r["ISSUE_ID"], "ISSUE_TITLE": r["ISSUE_TITLE"],
              "ISSUE_DATES": r["ISSUE_DATES"]};
            map1.add(m);
          }
        });
      });
    }
    catch(err){
      print(err.runtimeType);
    }
    // log(map1.length.toString()+"3333");
    return map1;
  }


  Future<List<Map>> getIssues2(var sql) async {

    List<Map> map1 = []; // = {'zero': 0, 'one': 1, 'two': 2};
    Map m = {}; //{'zero': 0, 'one': 1, 'two': 2};
    try{
      await getConnection().then((conn) async {
        log("conn...=="+sql);
        await conn.query(sql).then((result) {
          // print({'type':result});
          // print(json.decode(result));
          m = {"ISSUE_ID": "", "ISSUE_TITLE": "Select One Issue",
            "ISSUE_DATES": ""};
          map1.add(m);
          for (var r in result) {
            m = {"ISSUE_ID": r["ISSUE_ID"], "ISSUE_TITLE": r["ISSUE_TITLE"],
              "ISSUE_DATES": r["ISSUE_DATES"]};
            map1.add(m);
          }
        });
      });
    }
    catch(err){
      print(err.runtimeType);
    }
    // log(map1.length.toString()+"3333");
    return map1;
  }


  Future getMemberListWithPhoto(var sql) async {

    List<Map> map1 = []; // = {'zero': 0, 'one': 1, 'two': 2};
    Map m = {}; //{'zero': 0, 'one': 1, 'two': 2};
    try{
      await getConnection().then((conn) async {
        log("conn...=="+sql);
        await conn.query(sql).then((result) {
          // print({'type':result});
          // print(json.decode(result));

          for (var r in result) {
            m = {"MEMBER_NAME": r["MEMBER_NAME"], "CONTACT_NO": r["CONTACT_NO"],
              "ADDRESS": r["ADDRESS"], "BLOOD_GROUP": r["BLOOD_GROUP"],
              "MEMBER_FNAME": r["MEMBER_FNAME"], "PHOTO_FILE": r["PHOTO_FILE"]
            };
            map1.add(m);
          }
        });
      });
    }
    catch(err){
      print(err.runtimeType);
    }
    // log(map1.length.toString()+"3333");
    return map1;
  }


  Future runInsertUpdateSQL(var sql) async {
    var res = 0;
    try{
      await getConnection().then((conn) async {
        log("conn...=="+sql);
        await conn.query(sql).then((result) {
          // print(result);
          // return result;
          res = 1;
        });
      });
    }
    // on SocketException {
    //   print("no internet connection...");
    //   print(exception.runtimeType);
    //   return 0;
    //   // throw Failure('No Internet connection 😑');
    // }
    on Exception catch (exception) {
    // only executed if error is of type Exception
      print(exception.runtimeType);
      res = 0;


    } catch (error) {
    // executed for errors of all types other than Exception
    print(error.runtimeType);

    res = 0;
    }
    return res;
  }



  Future runSQL4(var sql) async {

    List<Map> map1 = []; // = {'zero': 0, 'one': 1, 'two': 2};
    Map m = {}; //{'zero': 0, 'one': 1, 'two': 2};
    try{
      await getConnection().then((conn) async {
        log("conn...=="+sql);
        await conn.query(sql).then((result) {
          // print({'type':result});
          // print(json.decode(result));

          for (var r in result) {
            m = {"MEMBER_NAME": r["MEMBER_NAME"], "CONTACT_NO": r["CONTACT_NO"],
              "ADDRESS": r["ADDRESS"], "BLOOD_GROUP": r["BLOOD_GROUP"],
              "MEMBER_FNAME": r["MEMBER_FNAME"]
            };
            map1.add(m);
          }
        });
      });
    }
    catch(err){
      print(err.runtimeType);
    }
    // log(map1.length.toString()+"3333");
    return map1;
  }

  Future runSQL(var sql) async {
    var res = null;
    try{
      await getConnection().then((conn) async{
        log("conn...=="+sql);
        await conn.query(sql).then((result) {

          res = result;
          // return result;
        });
      });
    }
    catch(err){
      print(err.runtimeType);
    }

    return res;
  }



}

// Create a table

class Library {
  var db = new dbCOn();
  var res = 0;
  var result;


  // Future loadValuesFromSession() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if(prefs.getString("UserName").toString() != '')
  //   {
  //
  //     LoginLogOut = "Logout";
  //     LoggedInValuePage = 10;
  //   }
  //
  //   log(prefs.getString("UserName").toString());
  //
  // }

  int loginCheck(var userID, var passwd) {
    var userInfo = List.filled(3, null, growable: false);
    // var userInfo = List(3);

    String sql = "select * from community where USER_NAME = '" + userID + "' AND CREDENTIAL = '" + passwd + "'";
     log(sql);
    var res = db.runSQL(sql);
    log(res.toString());
    if (res == 1) {
      for (var r in result) {
        var userName = r["NAME"];
        log(userName);
      }
    }

    return 1;
  }

  bool isSnackbarActive1 = false;
  void createSnackBar(String message, var context) {
    if(isSnackbarActive1 == false) {
      isSnackbarActive1 = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message.toString()),
        backgroundColor: Colors.red,
      )).closed
          .then((SnackBarClosedReason reason) {
        // snackbar is now closed.
        isSnackbarActive1 = false ;
      });
    }
  }
  void createSnackBar2(String message, var context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message.toString()),
      backgroundColor: Colors.red,
    )).closed
        .then((SnackBarClosedReason reason) {
      // snackbar is now closed.
      isSnackbarActive = false ;
    });
  }
}



showAlertDialog2(BuildContext context){
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.of(context).pop("Cancel");},
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed:  () {
      Navigator.of(context).pop("Continue");},
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Text("Would you like to continue learning how to use Flutter alerts?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context){
      // print(alert);
      return alert;
    },
  );
}


// Future<List<String>> getData_back(var id, var passwd) async {
//   List<String> data = [];
//
//   // prefs = await SharedPreferences.getInstance();
//   // prefs.setString("NAME", "Test Name");
//   // prefs.clear();
//
//   return await Future.delayed(Duration(seconds: 2), () async {
//     // var db = new dbCOn();
//     String sql = "select MEMBER_NAME, MEMBER_FNAME, ADDRESS, CONTACT_NO from community_member where CONTACT_NO = '" +
//         id +
//         "' AND PASS_WORD = '" +
//         passwd +
//         "'";
//     // sql = "select * from community";
//     log(sql);
//
//     // SharedPreferences prefs;
//     // prefs = await SharedPreferences.getInstance();
//     // prefs.clear();
//
//     var settings = ConnectionSettings(
//         host: '103.219.147.25',
//         port: 3306,
//         user: 'mazharul',
//         db: 'flutter_test',
//         password: 'Mz#20BF!t22');
//
//     var db = MySqlConnection.connect(settings);
//
//     var userName = "";
//     userName = await db.then((conn) async {
//       log("conn...==" + sql);
//       await conn.query(sql).then((result) {
//         for (var r in result) {
//           // prefs.setString("UserName", r["NAME"]);
//           userName = r["NAME"];
//           data.add(userName);
//           // log(r["NAME"].toString());
//         }
//         // res = 1;
//         // return 1;
//       });
//       // prefs.reload();
//       return prefs.getString("UserName").toString();
//     });
//     // data.add(Text(userName));
//     // return userName;
//     return data;
//   });
// }