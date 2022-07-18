import 'dart:developer';

import 'package:calculator/includes_file.dart';
import 'package:mysql1/mysql1.dart';

class IssueListScreen extends StatefulWidget {
  @override
  State<IssueListScreen> createState() => IssueList();
}

class IssueList extends State<IssueListScreen> {
  List<Map> map1 = [];
  List<Map> map1_backup = [];

  Future<List<Map>> IssueListFuture() async {
    var db = new dbCOn();
    String sql =
        "SELECT DATE_FORMAT(ISSUE_DATE, '%d-%M-%Y') ISSUE_DATES, ISSUE_ID, ISSUE_TITLE FROM issues";
    var res = await db.getIssues(sql);
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
        appBar: appBar.crtAppBar("Issue List", context),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: SearchResultxt,
                      decoration: InputDecoration(
                        label: Text("Enter Part of Issue Title"),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        if (text == '') {
                          setState(() {
                            map1 = map1_backup;
                          });
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    iconSize: 30,
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
                        text = text.toLowerCase();
                        map1.forEach((m) {
                          if (m["ISSUE_TITLE"].toLowerCase().contains(text))
                            map2.add(m);
                        });

                        if (map2.length == 0) {
                          if (isSnackbarActive == false) {
                            isSnackbarActive = true;
                            Lib.createSnackBar2(
                                "No issue found, please try another search",
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
                ]),
                SizedBox(height: 10),
                // new SingleChildScrollView(
                //   scrollDirection: Axis.vertical,
                //   child:
                Expanded(
                    // padding: EdgeInsets.all(1), //You can use EdgeInsets like above
                    // margin: EdgeInsets.all(2),
                    child: map1.length != 0
                        ? ListView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: map1.length,
                            itemBuilder: (context, int index) {
                              // log(data[index]["PHOTO_FILE"].toString());
                              // log("dddddddddd");

                              return InkWell(
                                  // child: Card(......),
                                  onTap: () {
                                    // int returnValueCOnfirmation = 0;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Setting String"),
                                          content: Text(
                                              "You have choosen to View details of "+
                                                  map1[index]["MEMBER_NAME"].toString() +" ("+
                                                  map1[index]["CONTACT_NO"].toString()+"). This may take some time to wait..."
                                              // controller: _controller,
                                              ),
                                          actions: <Widget>[
                                            Icon(
                                              Icons.info_outlined,
                                            ),
                                            FlatButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.pop(context, "");
                                              },
                                            ),
                                            FlatButton(
                                              child: Text("Continue"),
                                              onPressed: () {
                                                Navigator.pop(context, "");
                                                Navigator.pushReplacement(context,
                                                    MaterialPageRoute(builder:
                                                        (context) => ProfilePageScreen(map1[index]["CONTACT_NO"].toString())
                                                    )
                                                );
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    );


                                    // print("Click event on Container" + map1[index]["CONTACT_NO"]);
                                  },
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    map1[index]["ISSUE_TITLE"],
                                                    textAlign: TextAlign.left),
                                                Text(
                                                    "Date: " +
                                                        map1[index]
                                                                ["ISSUE_DATES"]
                                                            .toString(),
                                                    textAlign: TextAlign.left),
                                              ]))));
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

                                  return Text("Data Loaded...");
                                }
                              }

                              // Displaying LoadingSpinner to indicate waiting state
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },

                            // Future that needs to be resolved
                            // inorder to display something on the Canvas
                            future: IssueListFuture(),
                          ))

              ],
            ),
          ),
        ));
  }
}
