import 'dart:developer';

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
    log(_selectedDate);

    var totalTxtBox =map1.length;
    for(var i=0;i<totalTxtBox;i++)
    {
      log(_controller[i].text);
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

  final amountTxtContr = TextEditingController();
  List<TextEditingController> _controller = [];




  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    ///
    ///
    ///

    log("3333333333");
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString().substring(0, 10);
        log(_selectedDate);
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var Lib = new Library();

    var customTxtB = new customUI();

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBar.crtAppBar("Add Payment...", context),
      body: Form(
          child: SingleChildScrollView(
              child: Container(
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
                              return DropdownMenuItem<String>(
                                  value: m['ISSUE_ID'].toString(),

                                  child: Text(m['ISSUE_TITLE'].toString() +
                                      " ("+m['ISSUE_DATES']+")")
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


                      SfDateRangePicker(
                        view: DateRangePickerView.month,
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.single,
                        allowViewNavigation: true,
                      ),
                      SizedBox(height: 10),

                      map1.length != 0
                          ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: map1.length,
                        itemBuilder: (context, int index) {
                          _controller.add(
                              TextEditingController());
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
                                            SizedBox(height:10),
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
              ))),
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
              if (_controller[i].text != '' && int.parse(_controller[i].text.toString()) > 0) {
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
