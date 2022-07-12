import 'dart:developer';

import 'package:calculator/includes_file.dart';
import 'package:mysql1/mysql1.dart';

class MyProfilePageScreen extends StatefulWidget {
  // ProfilePageScreen(String MobileNo) {
  //   MobileNumber = MobileNo;
  // }

  @override
  State<MyProfilePageScreen> createState() => MyProfilePage();
}

class MyProfilePage extends State<MyProfilePageScreen> {
  late SharedPreferences prefs;



  @override
  void initState() {
    super.initState();
    loadCounter();
  }

  void loadCounter() async {
    prefs = await SharedPreferences.getInstance();
    log(prefs.getString("UserName").toString());
    log("ddddddd");
    setState(() {
      // _counter = (prefs.getInt('counter') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {

    var Lib = new Library();

    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: appBar.crtAppBar("My Profile Page", context),
        body: Container(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
                  child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        //<-- SEE HERE
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          color: Colors.greenAccent,
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "Name: " +
                                        prefs.getString("UserName").toString(),
                                    textAlign: TextAlign.left),
                                Text(
                                    "Name: " +
                                        "333333",
                                    textAlign: TextAlign.left),
                                // Text(
                                //     "Address: " +
                                //         prefs.getString("Address").toString(),
                                //     textAlign: TextAlign.left),

                                // subtitle: Text(snapshot.data[index]),
                              ])))),
            ));
  }
}
