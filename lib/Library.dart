import 'dart:developer';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    final List<Map> map1 = []; // = {'zero': 0, 'one': 1, 'two': 2};
    Map m = {}; //{'zero': 0, 'one': 1, 'two': 2};
    try{
      await getConnection().then((conn) async {
        log("conn...=="+sql);
        await conn.query(sql).then((result) {
          // print({'type':result});
          // print(result);


          for (var r in result) {
            // m = {"MEMBER_NAME": r["MEMBER_NAME"], "PHOTO_FILE": r["PHOTOS"].toString().replaceAll(RegExp(' {1,}'), '').replaceAll("\n", "")};
            m = {"MEMBER_NAME": r["MEMBER_NAME"], "PHOTO_FILE": r["PHOTOS"].toString()};
            map1.add(m);
            // log(r["PHOTOS"].toString().replaceAll(RegExp(' {1,}'), '').replaceAll("\n", ""));
            // log(r["PHOTOS"].length.toString());
          }
        });
      });
    }
    catch(err){
      print(err.runtimeType);
    }
    log(map1.length.toString()+"3333");
    return map1;
  }


  Future runSQL(var sql) async {
    try{
      await getConnection().then((conn) {
        log("conn...=="+sql);
        conn.query(sql).then((result) {

          return result;
        });
      });
    }
    catch(err){
      print(err.runtimeType);
    }
    // return res;
  }



}

// Create a table

class Library {
  var db = new dbCOn();
  var res = 0;
  var result;



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

  void createSnackBar(String message, var context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message.toString()),
      backgroundColor: Colors.red,
    ));
  }
}
