import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:calculator/includes_file.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

  bool addButtonEnable = true;
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  bool isLoading = false;
  bool dataLoaded = false;
  bool dataLoaded2 = false;
  List<Map> map1 = [];
  List<Map> map1_backup = [];



  Future<String> saveValues() async {
    var Lib = new Library();
    var db = new dbCOn();

    log(map1.length.toString());
    log(selectedValue);
    log(dateinput.text);

    var totalTxtBox =map1.length;
    var sql = "INSERT INTO payment_collection (MEMBER_ID, ISSUE_ID, AMOUNT, PAY_DATE)";

    setState(() {
      addButtonEnable = true;
    });

    for(var i=0;i<totalTxtBox;i++)
    {
      log(i.toString());

      var amount = _controller[i].text;
      var member_since = _controller_member_since[i].text;
      log("Member Since" + member_since);
      var mobile_number = _controller_mob[i].text;
      var monthly_pmt_clear_upto = _controller_payment_clear[i].text;
      log("monthly_pmt_clear_upto " + monthly_pmt_clear_upto);

      if(int.parse(selectedValue) == 1) //Monthly Collection issues
      {
        // log(i.toString());
        var starting_from = member_since;
        // _contact?.email ?? ""
        if (monthly_pmt_clear_upto ?? "" && monthly_pmt_clear_upto.compareTo(member_since) > 0)
          starting_from = monthly_pmt_clear_upto;

        log("Starting" + starting_from);

      }
      // var
    }



    // if(selectedValue == 1) //For monthly Collection issues
    //   {
    //     String
    // }

//       //Check duplicate mobile number...
//       String mobileCheckSQL = "SELECT * FROM issues "
//           "WHERE ISSUE_TITLE = '" +
//           tecIssueName.text +
//           "' AND ISSUE_DATE = '"+
//           _selectedDate
//           +"'";
//
//       var res = await db.runSQL(mobileCheckSQL);
//       print(res.length);
//
//       if (res.length > 0) {
//         ///Duplicate mobile number found {
//         // log("3333333333");
//         setState(() {
//           addButtonEnable = true;
//           isLoading = false;
//           dataSavingMsg =
//           "The issue title is already exist in the specific date. Please check information again...";
//           addButtonEnable = true;
//           Lib.createSnackBar(dataSavingMsg, context);
//         });
//         return dataSavingMsg;
//       } else {
//         String sql1 = "INSERT INTO `issues` "
//             "(`ISSUE_TITLE`, `ISSUE_DATE`)"
//             "VALUES('" +
//             tecIssueName.text +
//             "', '" +
//             _selectedDate +
//             "')";
//
//         // log(sql1);
//
//         res = await db.runInsertUpdateSQL(sql1);
//         dataSavingMsg = "Data Saved Successfully for - " +
//             tecIssueName.text +
//             " (" +
//             _selectedDate +
//             ")";
//         if (res == 0) {
//           setState(() {
//             isLoading = false;
//             dataSavingMsg =
//             "Data Could Not Saved. Please try again and check internet connection...";
//             addButtonEnable = true;
//             Lib.createSnackBar(dataSavingMsg, context);
// //        loadData = 0;
//           });
//         } else {
//           // Lib.createSnackBar(dataSavingMsg, context);
//           Lib.createSnackBar(dataSavingMsg, context);
//           setState(() {
//             isLoading = false;
//             tecIssueName.text = '';
//             addButtonEnable = true;
//             loadData = 0;
//             _load = false;
//             dataSavingMsg = 'Enter new Issue information and press Add buttion';
//           });
//           // var route = ModalRoute.of(context)?.settings.name;
//           // Navigator.popAndPushNamed(context, route.toString());
//         }
//
//         // log(res);
//       }
//       return dataSavingMsg;
//     });

    setState(() {
      addButtonEnable = true;
      isLoading = false;
    });
    return "Success...";
  }


  String selectedValue = "";

  List<Map> issueLists1 = [];
  Future<List<Map>> dropBtnIssues() async {
    // List<Map> keyValues = {"A":1, "B":1 };

    String sql =
        "SELECT DATE_FORMAT(ISSUE_DATE, '%d-%M-%Y') ISSUE_DATES, ISSUE_ID, ISSUE_TITLE FROM issues";
    var db = new dbCOn();
    var issueLists = await db.getIssues2(sql);
    setState(() {
      dataLoaded2 = true;
      issueLists1 = issueLists;
    });
    return issueLists1;
  }


  Future<List<Map>> MemberListFuture() async {
    var db = new dbCOn();
    // String sql =
    //     "select MEMBER_NAME, ADDRESS, CONTACT_NO, BLOOD_GROUP "
    //     "from community_member WHERE STATUS = 0";

    String sql =
        "select MEMBER_NAME, ADDRESS, CONTACT_NO, BLOOD_GROUP, "
        "DATE_FORMAT(SUBSTRING(MEMBER_SINCE, 1, 10), '%d-%M-%Y') MEMBER_SINCE_FORMATTED, "
        " MEMBER_SINCE, "
        "pc1.ENTRY_DT1, pc1.PAY_DATE1, DATE_FORMAT(SUBSTRING(pc1.PAY_DATE1, 1, 10), '%d-%M-%Y') PAY_DATE1_FORMATTED, pc2.PAY_DATE2, issues.ISSUE_ID, issues.ISSUE_TITLE,"
        "DATE_FORMAT(SUBSTRING(issues.ISSUE_DATE, 1, 10), '%d-%M-%Y') ISSUE_DATES, pc2.AMOUNT  "
            "from community_member cm LEFT JOIN  "
        "(SELECT MEMBER_ID, ISSUE_ID, MAX(PAY_DATE) PAY_DATE1, DATE_FORMAT(SUBSTRING(ENTRY_DT, 1, 10), '%d-%M-%Y') ENTRY_DT1 "
        "FROM payment_collection WHERE ISSUE_ID = 1 GROUP BY MEMBER_ID, ISSUE_ID, ENTRY_DT1)  pc1  ON cm.ID = pc1.MEMBER_ID "
            "LEFT JOIN "
            "(SELECT pc3.MEMBER_ID, pc3.ISSUE_ID, pc3.AMOUNT, PAY_DATE2 FROM "
        "(SELECT MEMBER_ID, DATE_FORMAT(SUBSTRING(MAX(PAY_DATE), 1, 10), '%d-%M-%Y') PAY_DATE2 "
        "FROM payment_collection WHERE ISSUE_ID != 1  GROUP BY MEMBER_ID) colc "
        "LEFT JOIN payment_collection pc3 ON colc.MEMBER_ID = pc3.MEMBER_ID and "
        "colc.PAY_DATE2 = DATE_FORMAT(SUBSTRING(pc3.PAY_DATE, 1, 10), '%d-%M-%Y')  and ISSUE_ID != 1 "
        ")  pc2 "
        "ON cm.ID = pc2.MEMBER_ID "
        "LEFT JOIN issues on pc2.ISSUE_ID = issues.ISSUE_ID";

    log(sql);
    var res = await db.getMemberList_withDetails(sql);
    map1_backup = res;
    setState(() {
      dataLoaded = true;
      map1 = res;
    });

    return res;
  }

  final amountTxtContr = TextEditingController();
  List<TextEditingController> _controller = [];
  List<TextEditingController> _controller_mob = [];
  List<TextEditingController> _controller_member_since = [];
  List<TextEditingController> _controller_payment_clear = [];







  TextEditingController dateinput = TextEditingController();

  setNewDate(String dt)
  {
    setState(() {
      dateinput.text = dt;
    });
  }


  @override
  Widget build(BuildContext context) {
    var Lib = new Library();

    var customTxtB = new customUI();

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBar.crtAppBar("Add Payment...", context),
      body:
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10),

                      dataLoaded2 == true
                          ? InputDecorator(
                        decoration:
                        const InputDecoration(border: OutlineInputBorder()),
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
                            // itemHeight: null,
                            items: issueLists1.map((Map m) {
                              // log(m['ISSUE_ID'].toString());
                              String str = m['ISSUE_TITLE'].toString();
                              if (m['ISSUE_DATES'] != '')
                                {
                                  str += " ("+m['ISSUE_DATES']+")";
                                }
                              return DropdownMenuItem<String>(
                                  value: m['ISSUE_ID'].toString(),

                                  child: Text(str)
                              );
                            }).toList(),
                          ),
                        ),
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

                      customTxtB.customTextDatePicker(dateinput, context, setNewDate),


                  Expanded(
                  child: SingleChildScrollView(
    child: Column(
      children: [

                      map1.length != 0
                          ?
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: map1.length,
                        itemBuilder: (context, int index) {
                          _controller.add(
                              TextEditingController());
                          _controller_mob.add(
                              TextEditingController(text:map1[index]["CONTACT_NO"].toString()));
                          _controller_member_since.add(
                              TextEditingController(text:map1[index]["MEMBER_SINCE"].toString()));
                          _controller_payment_clear.add(
                              TextEditingController(text:map1[index]["PAY_DATE1"].toString()));


                          // log(data[index]["PHOTO_FILE"].toString());
                          // log("dddddddddd");

                          return InkWell(
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
                                                    "), \nMember Since:" + map1[index]["MEMBER_SINCE_FORMATTED"].toString(),
                                                textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),

                                            SizedBox(height:10),

                                            Text(
                                                "Monthly Pmt: Clear Upto (" +
                                                    map1[index]["PAY_DATE1_FORMATTED"].toString() + "), \nLast pmt at (" + map1[index]["ENTRY_DT1"].toString() + ")",
                                                textAlign: TextAlign.left),
                                            SizedBox(height:10),

                                            Text(
                                                "Last Pmt Special Issue : "+ map1[index]["ISSUE_TITLE"].toString() + "("+map1[index]["ISSUE_DATES"].toString()+") \n"+
                                                    "Paid "+map1[index]["AMOUNT"].toString()+" tk. at - " + map1[index]["PAY_DATE2"].toString(),
                                                textAlign: TextAlign.left),
                                            SizedBox(height:10),

                                      Visibility(
                                          visible: false,
                                        child: Column(
                                          children: [
                                            customTxtB.customTextBoxCrt2(_controller_mob[index], "Mobile"),
                                            customTxtB.customTextBoxCrt2(_controller_member_since[index], "Member Since"),
                                            customTxtB.customTextBoxCrt2(_controller_payment_clear[index], "Payment Clear to"),

                                          ],
                                        )
                                      ),


                                            customTxtB.customTextBoxCrt(
                                                _controller[index],
                                                "Enter Amount"),
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
                      )

                      ,


                      isLoading
                          ? Center(
                        child: CircularProgressIndicator(),
                      )
                          : SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
               ]
                  )
              ) ),
                  floatingActionButton: FloatingActionButton(
        onPressed: addButtonEnable == true
            ? ()
        {
          if(selectedValue == '')
          {
            Lib.createSnackBar("Select any issue...", context);
            return;
          }
          else {
            var collectionProceed = 0;
            for (var i = 0; i <= map1.length; i++) {
              if (_controller[i].text != '' && int.parse(_controller[i].text.toString()) > 0)
              {
                collectionProceed = 1;
                break;
              }
            }

            if (collectionProceed == 1) {
              setState(() {
                isLoading = true;
                // loadData = 1;
                addButtonEnable = false;
              });
              saveValues();
            }

            else
            {
              Lib.createSnackBar("Select any issue and enter right amount for at least one people...", context);
              return;
            }
          }

        }: null,
//          Lib.createSnackBar("Login Success.. Please try again"+result.toString(), context);
        tooltip: 'Add Payment',
        child: Text("Add"),
        // const Icon(Icons.ten_k_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
