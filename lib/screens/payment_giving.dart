import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:calculator/includes_file.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PaymentGivingScreen extends StatefulWidget {
  @override
  State<PaymentGivingScreen> createState() => PaymentGiving();
}

class PaymentGiving extends State<PaymentGivingScreen> {
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


  bool isLoading = false;
  bool dataLoaded = false;
  bool dataLoaded2 = false;
  List<Map> map1 = [];
  List<Map> map1_backup = [];

  final amountTxtContr = TextEditingController();

  TextEditingController dateinput = TextEditingController();

  Future<String> saveValues() async {
    var Lib = new Library();
    var db = new dbCOn();
    var sql = "";
    log(map1.length.toString());
    log(selectedValue);
    log(dateinput.text);

    sql =
        "INSERT INTO payment_collection (MEMBER_ID, ISSUE_ID, AMOUNT, PAY_DATE) VALUES ";



    var res = db.runSQL(sql);
    log(sql);
    print(res);
    setState(() {
      addButtonEnable = true;
      isLoading = false;
      dataLoaded2 = false;
      // map1.clear();
      map1 = [];

    });

    Lib.createSnackBar("Payment successfully updated...", context);
    return "Success...";
  }



  List<Map> issueLists1 = [];

  Future<List<Map>> dropBtnIssues() async {
    // List<Map> keyValues = {"A":1, "B":1 };

    String sql =
        "SELECT DATE_FORMAT(ISSUE_DATE, '%d-%M-%Y') ISSUE_DATES, issues.ISSUE_ID, ISSUE_TITLE, IFNULL(AMOUNT, 0) AMOUNT "
        "FROM issues "
        "left join (select sum(amount) AMOUNT, ISSUE_ID FROM payment_collection GROUP BY ISSUE_ID) pc "
        "on issues.ISSUE_ID = pc.ISSUE_ID "
        " WHERE issues.STATUS = 1 AND issues.ISSUE_ID != 1";
    var db = new dbCOn();
    var issueLists = await db.getIssues_payment_info(sql);
    print(issueLists);
    setState(() {
      dataLoaded2 = true;
      issueLists1 = issueLists;
    });
    return issueLists1;
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
      appBar: appBar.crtAppBar("Payment giving...", context),
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
                            itemHeight: 50,


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
                                str += " (" + m['ISSUE_DATES'] + ")\nCollected Amount : " + m['AMOUNT_COLLECTED'].toString();
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


              ]))),
      floatingActionButton: FloatingActionButton(
        onPressed: addButtonEnable == true
            ? () {
                if (selectedValue == '' || dateinput.text == '') {
                  Lib.createSnackBar("Select any issue, specify date and give amount...", context);
                  return;
                } else {



                    setState(() {
                      isLoading = true;
                      // loadData = 1;
                      addButtonEnable = false;
                    });
                    saveValues();
                  }
                }

            : null,
//          Lib.createSnackBar("Login Success.. Please try again"+result.toString(), context);
        tooltip: 'Payment Giving',
        child: Text("Pay"),
        // const Icon(Icons.ten_k_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
