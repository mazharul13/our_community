import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:calculator/includes_file.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';



class IssueEntryScreen extends StatefulWidget {
  @override
  State<IssueEntryScreen> createState() => IssueEntry();
}

class IssueEntry extends State<IssueEntryScreen> {
  var _formKey = GlobalKey<FormState>();

  final tecIssueName = TextEditingController();

  var loadData = 0;
  late SharedPreferences prefs;

  // int imageFileInitialized = 0;
  bool _load = false;
  bool isLoading = false;

  bool addButtonEnable = true;
  var Lib;
  String dataSavingMsg = 'Please Enter All the values and press Add button';

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

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

  Future<String> saveValues() async {
    return await Future.delayed(Duration(seconds: 2), () async {
      var Lib = new Library();
      var db = new dbCOn();

      //Check duplicate mobile number...
      String mobileCheckSQL = "SELECT * FROM issues "
              "WHERE ISSUE_TITLE = '" +
          tecIssueName.text +
          "' AND ISSUE_DATE = '"+
          _selectedDate
          +"'";

      var res = await db.runSQL(mobileCheckSQL);
      print(res.length);

      if (res.length > 0) {
        ///Duplicate mobile number found {
        // log("3333333333");
        setState(() {
          addButtonEnable = true;
          isLoading = false;
          dataSavingMsg =
              "The issue title is already exist in the specific date. Please check information again...";
          addButtonEnable = true;
          Lib.createSnackBar(dataSavingMsg, context);
        });
        return dataSavingMsg;
      } else {
        String sql1 = "INSERT INTO `issues` "
                "(`ISSUE_TITLE`, `ISSUE_DATE`)"
                "VALUES('" +
            tecIssueName.text +
            "', '" +
            _selectedDate +
            "')";

        // log(sql1);

        res = await db.runInsertUpdateSQL(sql1);
        dataSavingMsg = "Data Saved Successfully for - " +
            tecIssueName.text +
            " (" +
            _selectedDate +
            ")";
        if (res == 0) {
          setState(() {
            isLoading = false;
            dataSavingMsg =
                "Data Could Not Saved. Please try again and check internet connection...";
            addButtonEnable = true;
            Lib.createSnackBar(dataSavingMsg, context);
//        loadData = 0;
          });
        } else {
          // Lib.createSnackBar(dataSavingMsg, context);
          Lib.createSnackBar(dataSavingMsg, context);
          setState(() {
            isLoading = false;
            tecIssueName.text = '';
            addButtonEnable = true;
            loadData = 0;
            _load = false;
            dataSavingMsg = 'Enter new Issue information and press Add buttion';
          });
          // var route = ModalRoute.of(context)?.settings.name;
          // Navigator.popAndPushNamed(context, route.toString());
        }

        // log(res);
      }
      return dataSavingMsg;
    });
  }

  @override
  void setValue(var i) {
    setState(() {
      loadData = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    Lib = new Library();

    var customTxtB = new customUI();

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: appBar.crtAppBar("Add New Issue", context),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                customTxtB.customTextBoxCrt(tecIssueName, "Issue Title"),
                SizedBox(height: 10),
                Text("Please select approximate date of Issue from the calendar below:",
                    style: TextStyle(color: Colors.blue)),
                SizedBox(height: 10),
                SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.single,
                  showTodayButton: true,
                ),
                SizedBox(height: 10),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text(dataSavingMsg),
              ],
            ),
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addButtonEnable == true || addButtonEnable == false
            ? () {
                if (tecIssueName.text == '' ||
                    _formKey.currentState?.validate() == false) {
                  Lib.createSnackBar(
                      "Enter values in all the fields...", context);
                } else {
                  setState(() {
                    isLoading = true;
                    loadData = 1;
                    addButtonEnable = false;
                  });
                  saveValues();
                }
              }
            : null,
//          Lib.createSnackBar("Login Success.. Please try again"+result.toString(), context);
        tooltip: 'Add New Issue',
        child: Text("Add"),
        // const Icon(Icons.ten_k_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
