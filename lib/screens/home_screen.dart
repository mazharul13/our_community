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
  String UserName = "";
  String MobileNumber = "";

  @override
  void initState() {
    super.initState();
    loadCounter();
  }

  void loadCounter() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey("UserName")) {
        UserName = prefs.getString("UserName").toString();
        MobileNumber = prefs.getString("ContactNo").toString();
        userLoggedIn = 1;
      }
    });

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
      var Lib = new Library();
      Lib.createSnackBar("Please confirm internet connection...", context);
    }

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
                                "বিসমিল্লাহির রাহমানির রাহিম ",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                              // Text(
                              //   "আমাদের কমিউনিটি",
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(fontSize: 35),
                              // ),
                              Text(
                                "কল্যাণমূলক সামাজিক পরিবর্তনের অঙ্গীকার",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              Image.asset('assets/images/community_logo.jpg'),
                              UserName.toString() != ""
                                  ? Text(
                                "Welcome : \n" + UserName + "("+MobileNumber+")",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              )
                                  : SizedBox(height: 10),


                              // subtitle: Text(snapshot.data[index]),
                            ])))
              ],
            ))));
  }
}
