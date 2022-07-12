import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:calculator/includes_file.dart';
import 'package:mysql1/mysql1.dart';

class HomePageScreen extends StatefulWidget {
  @override
  State<HomePageScreen> createState() => HomeScreenReal();
}

class HomeScreenReal extends State<HomePageScreen> {
  late SharedPreferences prefs;
  String UserName = '';
  String ContactNo = '';
  String Address = '';
  String BloodGroup = '';
  String FathersName = '';


  @override
  void initState() {
    super.initState();
    loadCounter();
  }

  void loadCounter() async {

    prefs = await SharedPreferences.getInstance();
    // log(prefs.getString("UserName").toString());
    // log("ddddddd");
    setState(() {
      UserName = prefs.getString("UserName").toString();
      FathersName = prefs.getString("FathersName").toString();
      ContactNo = prefs.getString("ContactNo").toString();
      Address = prefs.getString("Address").toString();
      // _counter = (prefs.getInt('counter') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {

    var Lib = new Library();

    return Scaffold(
      // resizeToAvoidBottomInset: false,
        appBar: appBar.crtAppBar("Our Community", context),
        body: Container(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Expanded(
                        child: Card(
                            margin: EdgeInsets.all(10),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              //<-- SEE HERE
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                color: Colors.greenAccent,
                              ),
                            ),
                            child: Column(

                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "Name: " +
                                          UserName,
                                      textAlign: TextAlign.left),
                                  Text(
                                      "Fathers' name: " +
                                          FathersName,
                                      textAlign: TextAlign.left),
                                  Text(
                                      "Address: " +
                                          Address,
                                      textAlign: TextAlign.left),
                                  Text(
                                      "Phone: " +
                                          ContactNo,
                                      textAlign: TextAlign.left),
                                  // Text(
                                  //     "Address: " +
                                  //         prefs.getString("Address").toString(),
                                  //     textAlign: TextAlign.left),

                                  // subtitle: Text(snapshot.data[index]),
                                ])))],
                ))));
  }
}
