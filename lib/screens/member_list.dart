import 'dart:developer';

import 'package:calculator/includes_file.dart';
import 'package:mysql1/mysql1.dart';

class MemberListScreen extends StatefulWidget {
  @override
  State<MemberListScreen> createState() => MemberList();
}

class MemberList extends State<MemberListScreen> {
  List<Map> map1 = [];
  List<Map> map1_backup = [];

  Future<List<Map>> MemberListFuture() async {
    var db = new dbCOn();
    String sql =
        "select MEMBER_NAME, ADDRESS, CONTACT_NO, BLOOD_GROUP from community_member";
    var res = await db.getMemberList(sql);
    map1_backup = res;
    setState(() {
      map1 = res;
    });

    return res;
  }

  final SearchResultxt = TextEditingController();
  final SearchResultxt1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var Lib = new Library();

    var customTxtB = new customUI();

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBar.crtAppBar("Member List", context),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Center(

          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              TextField(
                controller: SearchResultxt,
                decoration: InputDecoration(
                  label: Text("Enter value to search..."),
                  border: OutlineInputBorder(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                iconSize: 50,
                onPressed: () {
                  String text = SearchResultxt.text;
                  if (text.length == 0) {
                    if (isSnackbarActive == false) {
                      isSnackbarActive = true;
                      Lib.createSnackBar2(
                          "Please enter any search value", context);
                    }
                    if (map1.length != map1_backup.length) {
                      setState(() {
                        map1 = map1_backup;
                      });
                    }
                  } else if (text.length >= 1) {
                    // log(text);
                    List<Map> map2 = [];

                    map1.forEach((m) {
                      if (m["MEMBER_NAME"] == text) map2.add(m);
                    });

                    if (map2.length == 0) {
                      if (isSnackbarActive == false) {
                        isSnackbarActive = true;
                        Lib.createSnackBar2(
                            "No People found, please try another search",
                            context);
                      }
                    } else {
                      setState(() {
                        map1 = map2;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 10),

              Container(
                  // padding: EdgeInsets.all(1), //You can use EdgeInsets like above
                  // margin: EdgeInsets.all(2),
                  child: map1.length != 0
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: map1.length,
                          itemBuilder: (context, int index) {
                            // log(data[index]["PHOTO_FILE"].toString());
                            // log("dddddddddd");

                            return Card(
                                elevation: 8,
                                color: Colors.lightGreen,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                    Text(map1[index]["MEMBER_NAME"] + "("+map1[index]["CONTACT_NO"]+")",
                                        textAlign: TextAlign.left
                                    ),
                                  Text(map1[index]["ADDRESS"].toString() + "("+map1[index]["BLOOD_GROUP"].toString()+")", textAlign: TextAlign.left
                                  ),

                                  // subtitle: Text(snapshot.data[index]),
                                ]));
                          },
                        )
                      : FutureBuilder(
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
                                final data = snapshot.data;
                                // print(data[0]["MEMBER_NAME"]);

                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, int index) {
                                    // log(data[index]["PHOTO_FILE"].toString());
                                    // log("dddddddddd");

                                    return new Card(
                                        child: Column(children: <Widget>[
                                      Text(map1[index]["MEMBER_NAME"] + "("+map1[index]["CONTACT_NO"]+")"
                                      ),
                                          Text(map1[index]["MEMBER_FNAME"] + "("+map1[index]["MEMBER_FNAME"]+")"
                                          ),

                                      // subtitle: Text(snapshot.data[index]),
                                    ]));
                                  },
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
                          future: MemberListFuture(),
                        )),
            ],
          ),
        ),
      )),
    );
  }
}
