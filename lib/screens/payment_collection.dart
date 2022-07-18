import 'dart:developer';

import 'package:calculator/includes_file.dart';
import 'package:mysql1/mysql1.dart';

class PaymentCollectionScreen extends StatefulWidget {
  @override
  State<PaymentCollectionScreen> createState() => PaymentCollection();
}

class PaymentCollection extends State<PaymentCollectionScreen> {

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
  bool dataLoaded = false;
  bool dataLoaded2 = false;
  List<Map> map1 = [];
  List<Map> map1_backup = [];

  String selectedValue = "1";

  List<Map> issueLists1 = [];
  Future<List<Map>> dropBtnIssues() async {
    // List<Map> keyValues = {"A":1, "B":1 };


    String sql =
        "SELECT DATE_FORMAT(ISSUE_DATE, '%d-%M-%Y') ISSUE_DATES, ISSUE_ID, ISSUE_TITLE FROM issues";
    var db = new dbCOn();
    var issueLists = await db.getIssues(sql);
      setState(() {
        dataLoaded2 = true;
        issueLists1 = issueLists;
      });
    return issueLists1;
  }




  Future<String> MemberApproveReject(String mobileNumber, int action) async {
    var Lib = new Library();
    setState(() {
      isLoading = true;
    });
    var db = new dbCOn();
    String sql =
        "UPDATE community_member SET STATUS = "+action.toString()+" WHERE CONTACT_NO = '"+mobileNumber+"'";
    var res = await db.runInsertUpdateSQL(sql);
    print(res);

    if(res == 1) {
      List<Map> map2 = [];
      map1.forEach((m) {
        if (!m["CONTACT_NO"].toLowerCase().contains(mobileNumber))
          map2.add(m);
      });

      map1_backup = map2;
      setState(() {
        map1 = map2;
        isLoading = false;
      });
      Lib.createSnackBar(
          "Status has been updated for the member...", context);
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

  Future<List<Map>> MemberListFuture() async {
    var db = new dbCOn();
    String sql =
        "select MEMBER_NAME, ADDRESS, CONTACT_NO, BLOOD_GROUP from community_member WHERE STATUS = 0";
    var res = await db.getMemberList(sql);
    map1_backup = res;
    setState(() {
      dataLoaded = true;
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
        appBar: appBar.crtAppBar("Add Payment...", context),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),

              dataLoaded2 == true ?
              InputDecorator(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    borderRadius: BorderRadius.circular(8),

                    underline: Container(),
                    //empty line
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    dropdownColor: Colors.cyan,
                    iconEnabledColor: Colors.red,
                    //Icon color

                    isExpanded: true,
                    // isDense: true,
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value.toString();
                      });
                      // print(value);
                    },
                    itemHeight: null,
                    items: issueLists1.map((Map m) {
                      // log(m['ISSUE_ID'].toString());
                      return DropdownMenuItem<String>(
                        value: m['ISSUE_ID'].toString(),
                        child: Text(m['ISSUE_TITLE'].toString()),
                      );
                    }).toList(),
                  ),
                ),
              ):

              FutureBuilder(
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
                future: dropBtnIssues(),
              ),

                // await dropBtnIssues(),
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
                                          title: Text("Show Details"),
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
                                                    map1[index]["MEMBER_NAME"] +
                                                        "(" +
                                                        map1[index]
                                                            ["CONTACT_NO"] +
                                                        ")",
                                                    textAlign: TextAlign.left),
                                                Text(
                                                    "Blood Group: " +
                                                        map1[index]
                                                                ["BLOOD_GROUP"]
                                                            .toString(),
                                                    textAlign: TextAlign.left),

                                                Text(
                                                    "Address : " +
                                                        map1[index]["ADDRESS"],
                                                    textAlign: TextAlign.left),

                                                UserName != "" ?
                                                FlatButton(
                                                  // splashColor: Colors.red,
                                                  color: Colors.green,
                                                  // textColor: Colors.white,
                                                  child:   isLoading
                                                      ?  CircularProgressIndicator()
                                                      :
                                                  Text('Take Action',),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("Approve/Reject Member"),
                                                          content: Text(
                                                              "What do you want to do for : "+
                                                                  map1[index]["MEMBER_NAME"].toString() +" ("+
                                                                  map1[index]["CONTACT_NO"].toString()+") ???"
                                                            // controller: _controller,
                                                          ),
                                                          actions: <Widget>[
                                                            Icon(
                                                              Icons.info_outlined,
                                                            ),

                                                            FlatButton(
                                                              child: Text("Not Decided yet"),
                                                              onPressed: () {
                                                                Navigator.pop(context, "");
                                                                // MemberApproveReject(map1[index]["CONTACT_NO"].toString(), 1);
                                                              },
                                                              shape: RoundedRectangleBorder(side: BorderSide(
                                                                  color: Colors.blue,
                                                                  width: 1,
                                                                  style: BorderStyle.solid
                                                              ), borderRadius: BorderRadius.circular(50)),
                                                            ),
                                                            FlatButton(
                                                              child: Text("Approve"),
                                                              onPressed: () {
                                                                Navigator.pop(context, "");
                                                                MemberApproveReject(map1[index]["CONTACT_NO"].toString(), 1);
                                                              },
                                                              shape: RoundedRectangleBorder(side: BorderSide(
                                                                  color: Colors.blue,
                                                                  width: 1,
                                                                  style: BorderStyle.solid
                                                              ), borderRadius: BorderRadius.circular(50)),
                                                            ),
                                                            FlatButton(
                                                              child: Text("Reject"),
                                                              onPressed: () {
                                                                Navigator.pop(context, "");
                                                                MemberApproveReject(map1[index]["CONTACT_NO"].toString(), 2);
                                                              },
                                                              shape: RoundedRectangleBorder(side: BorderSide(
                                                                  color: Colors.blue,
                                                                  width: 1,
                                                                  style: BorderStyle.solid
                                                              ), borderRadius: BorderRadius.circular(50)),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    );

                                                  },
                                                ):
                                                Text("Please login to Approve/Reject",
                                                    style: TextStyle(color: Colors.blue)),
                                                // subtitle: Text(snapshot.data[index]),
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
                            future: MemberListFuture(),
                          )),
                Text("Test Text..."),

              ],
            ),
          ),
        ));
  }
}
