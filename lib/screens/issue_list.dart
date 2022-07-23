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

  late SharedPreferences prefs;
  String UserName = "";

  @override
  void initState() {
    super.initState();
    loadLoginValues();
  }

  void loadLoginValues() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey("UserName")) {
        UserName = prefs.getString("UserName").toString();
      }
    });
  }

  bool isLoading = false;

  Future<List<Map>> IssueListFuture() async {
    var db = new dbCOn();
    String sql =
        "SELECT ISSUE_ID, DATE_FORMAT(ISSUE_DATE, '%d-%M-%Y') ISSUE_DATES, ISSUE_ID, ISSUE_TITLE, if(STATUS=0, 'Closed', 'Active') STATUS FROM issues";
    var res = await db.getIssues(sql);
    res.removeAt(0);
    map1_backup = res;
    setState(() {
      map1 = res;
    });

    return res;
  }

  Future<String> IssueClosing(String issueID) async {
    var Lib = new Library();
    setState(() {
      isLoading = true;
    });
    var db = new dbCOn();
    String sql =
        "UPDATE issues SET STATUS = 0 where ISSUE_ID = '"+issueID+"'";
    var res = await db.runInsertUpdateSQL(sql);
    print(res);

    if(res == 1) {
      List<Map> map2 = [];
      map1.forEach((m) {
        if (!m["ISSUE_ID"].toString().contains(issueID))
          map2.add(m);
      });

      map1_backup = map2;
      setState(() {
        map1 = map2;
        isLoading = false;
      });
      Lib.createSnackBar(
          "Status has been updated for the issue " , context);
    }
    else
    {
      setState(() {
        // map1 = map2;
        isLoading = false;
      });
      Lib.createSnackBar(
          "Problem is there while updating status. Please try again later...", context);

    }
    return "Updated Status";

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
                                                Text(map1[index]["ISSUE_TITLE"],
                                                    textAlign: TextAlign.left),
                                                Text(
                                                    "Date: " +
                                                        map1[index]
                                                                ["ISSUE_DATES"]
                                                            .toString(),
                                                    textAlign: TextAlign.left),
                                                Text(
                                                    "Status: " +
                                                        map1[index]["STATUS"]
                                                            .toString(),
                                                    textAlign: TextAlign.left),
                                                UserName != "" && map1[index]["STATUS"].toString() == 'Active' && map1[index]["ISSUE_ID"] != 1
                                                    ? FlatButton(
                                                        // splashColor: Colors.red,
                                                        color: Colors.green,
                                                        // textColor: Colors.white,
                                                        child: isLoading
                                                            ? CircularProgressIndicator()
                                                            : Text(
                                                                'Close',
                                                              ),
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "Action"),
                                                                content: Text(
                                                                    "Do you want to close the issue : " +
                                                                        map1[index]["ISSUE_TITLE"]
                                                                            .toString() +
                                                                        " (" +
                                                                        map1[index]["ISSUE_DATES"]
                                                                            .toString() +
                                                                        ") ???"
                                                                    // controller: _controller,
                                                                    ),
                                                                actions: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .info_outlined,
                                                                  ),
                                                                  FlatButton(
                                                                    child: Text(
                                                                        "No"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          "");
                                                                      // MemberApproveReject(map1[index]["CONTACT_NO"].toString(), 1);
                                                                    },
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color: Colors
                                                                                .blue,
                                                                            width:
                                                                                1,
                                                                            style: BorderStyle
                                                                                .solid),
                                                                        borderRadius:
                                                                            BorderRadius.circular(50)),
                                                                  ),
                                                                  FlatButton(
                                                                    child: Text(
                                                                        "Yes"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          "");
                                                                      IssueClosing(
                                                                          map1[index]["ISSUE_ID"]
                                                                              .toString());
                                                                    },
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color: Colors
                                                                                .blue,
                                                                            width:
                                                                                1,
                                                                            style: BorderStyle
                                                                                .solid),
                                                                        borderRadius:
                                                                            BorderRadius.circular(50)),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                      )
                                                    : SizedBox(),
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
