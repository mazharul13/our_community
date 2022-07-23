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
  String selectedValue = "";

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

  final amountTxtContr = TextEditingController();
  List<TextEditingController> _controller = [];
  List<TextEditingController> _controller_member_id = [];
  List<TextEditingController> _controller_mob = [];
  List<TextEditingController> _controller_member_since = [];
  List<TextEditingController> _controller_payment_clear = [];
  TextEditingController dateinput = TextEditingController();

  Future<String> saveValues() async {
    var Lib = new Library();
    var db = new dbCOn();
    var sql = "";
    log(map1.length.toString());
    log(selectedValue);
    log(dateinput.text);

    var totalTxtBox = map1.length;
    // var sql = "INSERT INTO payment_collection (MEMBER_ID, ISSUE_ID, AMOUNT, PAY_DATE)";



    sql =
        "INSERT INTO payment_collection (MEMBER_ID, ISSUE_ID, AMOUNT, PAY_DATE) VALUES ";

    if (int.parse(selectedValue) == 1) {
      //Monthly Collection issues
      for (var i = 0; i < totalTxtBox; i++) {
        log(i.toString());

        if (_controller[i].text == '' || int.parse(_controller[i].text) < 0)
          continue;

        /// No appropriate payment values given.

        var amount = int.parse(_controller[i].text);
        var member_since = _controller_member_since[i].text;
        var member_id = _controller_member_id[i].text;
        log("Member Since" + member_since);
        var mobile_number = _controller_mob[i].text;
        var monthly_pmt_clear_upto = _controller_payment_clear[i].text;
        log("monthly_pmt_clear_upto " + monthly_pmt_clear_upto);
        if (amount % 100 != 0) {
          Lib.createSnackBar(
              "Monthly collection values should be multiple of 100. Otherwise it will be ignored...",
              context);
          //  continue; /// Monthly collection should be multiple of 100 otherwise it will be ignored.
        }
        // log(i.toString());
        /// set the payment entry date from last payment or from starting of membership.
        var payDate = member_since;
        // _contact?.email ?? ""
        var date = DateTime.parse(payDate);

        if (monthly_pmt_clear_upto.toString() != 'null') {
          // if (monthly_pmt_clear_upto.compareTo(member_since) > 0)
          payDate = monthly_pmt_clear_upto;
          date = DateTime.parse(payDate);
          date = new DateTime(date.year, date.month + 1, date.day);
        }

        for (int v = 100; v <= amount; v += 100) {
          sql += " (" +
              member_id +
              ", 1, 100, '" +
              date.toString().substring(0, 10) +
              "'), ";
          date = new DateTime(date.year, date.month + 1, date.day);
        }
      }

      sql = sql.substring(0, sql.length - 2);

    }
    else
      {

        for (var i = 0; i < totalTxtBox; i++) {
          log(i.toString());

          if (_controller[i].text == '' || int.parse(_controller[i].text) < 0)
            continue;

          /// No appropriate payment values given.

          var amount = int.parse(_controller[i].text.toString());

          var member_id = _controller_member_id[i].text;


          var paymentDate = dateinput.text;

          sql += " ($member_id, $selectedValue,'$amount','${paymentDate.toString().substring(0, 10)}'), ";

        }

        sql = sql.substring(0, sql.length - 2);

      }

    var res = db.runSQL(sql);
    log(sql);
    print(res);
    setState(() {
      addButtonEnable = true;
      isLoading = false;
      dataLoaded2 = false;
      // map1.clear();
      map1 = [];
      _controller_payment_clear = [];
    });

    Lib.createSnackBar("Payment successfully updated...", context);
    return "Success...";
  }



  List<Map> issueLists1 = [];

  Future<List<Map>> dropBtnIssues() async {
    // List<Map> keyValues = {"A":1, "B":1 };

    String sql =
        "SELECT DATE_FORMAT(ISSUE_DATE, '%d-%M-%Y') ISSUE_DATES, ISSUE_ID, ISSUE_TITLE FROM issues WHERE STATUS = 1";
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
        "select cm.ID MEMBER_ID, MEMBER_NAME, ADDRESS, CONTACT_NO, IFNULL(BLOOD_GROUP, 'N/A') BLOOD_GROUP, "

        "IFNULL((select DATE_FORMAT(SUBSTRING(pc5.ENTRY_DT, 1, 10), '%d-%M-%Y')  from payment_collection pc5 where pc5.MEMBER_ID = pc1.MEMBER_ID"
        " AND pc5.ISSUE_ID = 1 AND pc5.PAY_DATE = pc1.PAY_DATE1  limit 1), '   No payment yet.') ENTRY_DT1_FORMATTED ,"

        "(select ENTRY_DT from payment_collection pc5 "
        "where pc5.MEMBER_ID = pc1.MEMBER_ID AND pc5.ISSUE_ID = 1 AND pc5.PAY_DATE = pc1.PAY_DATE1  limit 1) ENTRY_DT1 ,"

        "DATE_FORMAT(SUBSTRING(MEMBER_SINCE, 1, 10), '%d-%M-%Y') MEMBER_SINCE_FORMATTED, MEMBER_SINCE, "

        " pc1.PAY_DATE1, IFNULL(DATE_FORMAT(SUBSTRING(pc1.PAY_DATE1, 1, 10), '%d-%M-%Y'), '   No Payment') PAY_DATE1_FORMATTED, pc2.PAY_DATE2, issues.ISSUE_ID, issues.ISSUE_TITLE,"
        "DATE_FORMAT(SUBSTRING(issues.ISSUE_DATE, 1, 10), '%d-%M-%Y') ISSUE_DATES, pc2.AMOUNT  "
        "from community_member cm LEFT JOIN  "
        "(SELECT MEMBER_ID, ISSUE_ID, MAX(PAY_DATE) PAY_DATE1 "
        "FROM payment_collection WHERE ISSUE_ID = 1 GROUP BY MEMBER_ID, ISSUE_ID)  pc1  ON cm.ID = pc1.MEMBER_ID "
        "LEFT JOIN "
        "(SELECT DISTINCT pc3.MEMBER_ID, pc3.ISSUE_ID, pc3.AMOUNT, PAY_DATE2 FROM "
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





  setNewDate(String dt) {
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
      body: Container(
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
                              if (m['ISSUE_DATES'] != '') {
                                str += " (" + m['ISSUE_DATES'] + ")";
                              }
                              return DropdownMenuItem<String>(
                                  value: m['ISSUE_ID'].toString(),
                                  child: Text(str));
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
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: map1.length,
                                itemBuilder: (context, int index) {
                                  _controller.add(TextEditingController());
                                  _controller[index].text = "";
                                  _controller_member_id.add(
                                      TextEditingController(
                                          text: map1[index]["MEMBER_ID"]
                                              .toString()));
                                  _controller_mob.add(TextEditingController(
                                      text: map1[index]["CONTACT_NO"]
                                          .toString()));
                                  _controller_member_since.add(
                                      TextEditingController(
                                          text: map1[index]["MEMBER_SINCE"]
                                              .toString()));
                                  // print(map1[index]["PAY_DATE1"]
                                  //     .toString()+"3333333");
                                  _controller_payment_clear.add(
                                      TextEditingController(
                                          text: map1[index]["PAY_DATE1"]
                                              .toString()));

                                  // log(data[index]["PHOTO_FILE"].toString());
                                  // log("dddddddddd");

                                  return InkWell(
                                      child: Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            //<-- SEE HERE
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: BorderSide(
                                              color: Colors.greenAccent,
                                            ),
                                          ),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      map1[index]
                                                              ["MEMBER_NAME"] +
                                                          "(" +
                                                          map1[index]
                                                              ["CONTACT_NO"] +
                                                          "), \nMember Since:" +
                                                          map1[index][
                                                                  "MEMBER_SINCE_FORMATTED"]
                                                              .toString(),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                        "Monthly Pmt: Clear Upto (" +
                                                            map1[index][
                                                                    "PAY_DATE1_FORMATTED"]
                                                                .toString().substring(3) +
                                                            ")",
                                                        textAlign:
                                                            TextAlign.left),
                                                    Text(
                                                        "Last pmt at - "+
                                                    map1[index][
                                                    "ENTRY_DT1_FORMATTED"]
                                                        .toString(),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                        "Contributed in Special Issue : " +
                                                            map1[index][
                                                                    "ISSUE_TITLE"]
                                                                .toString() +
                                                            "(" +
                                                            map1[index][
                                                                    "ISSUE_DATES"]
                                                                .toString() +
                                                            ") \n" +
                                                            "Paid " +
                                                            map1[index]
                                                                    ["AMOUNT"]
                                                                .toString() +
                                                            " tk. at - " +
                                                            map1[index][
                                                                    "PAY_DATE2"]
                                                                .toString(),
                                                        textAlign:
                                                            TextAlign.left),
                                                    SizedBox(height: 10),
                                                    Visibility(
                                                        visible: false,
                                                        child: Column(
                                                          children: [
                                                            customTxtB
                                                                .customTextBoxCrt2(
                                                                    _controller_member_id[
                                                                        index],
                                                                    "Member_ID"),
                                                            customTxtB
                                                                .customTextBoxCrt2(
                                                                    _controller_mob[
                                                                        index],
                                                                    "Mobile"),
                                                            customTxtB.customTextBoxCrt2(
                                                                _controller_member_since[
                                                                    index],
                                                                "Member Since"),
                                                            customTxtB.customTextBoxCrt2(
                                                                _controller_payment_clear[
                                                                    index],
                                                                "Payment Clear to"),
                                                          ],
                                                        )),
                                                    customTxtB.customTextBoxCrtNumber(
                                                        _controller[index],
                                                        "Enter Amount"),
                                                  ]))));
                                  _controller_payment_clear[index].text = map1[index]["PAY_DATE1"].toString();
                                },
                              )
                            : FutureBuilder(
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
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
                              ),
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ]))),
      floatingActionButton: FloatingActionButton(
        onPressed: addButtonEnable == true
            ? () {
                if (selectedValue == '' || dateinput.text == '') {
                  Lib.createSnackBar("Select any issue and specify date...", context);
                  return;
                } else {
                  var collectionProceed = 0;
                  for (var i = 0; i <= map1.length; i++) {
                    if (_controller[i].text != '' &&
                        int.parse(_controller[i].text.toString()) > 0) {
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
                  } else {
                    Lib.createSnackBar(
                        "Select any issue and enter right amount for at least one people...",
                        context);
                    return;
                  }
                }
              }
            : null,
//          Lib.createSnackBar("Login Success.. Please try again"+result.toString(), context);
        tooltip: 'Add Payment',
        child: Text("Add"),
        // const Icon(Icons.ten_k_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
