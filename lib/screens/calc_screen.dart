import 'package:flutter/material.dart';
import '../ui_elements/customTextBox.dart';

class CalculatorScreen extends StatefulWidget {

  @override
  State<CalculatorScreen> createState() => CalculatorScreenReal();
}

class CalculatorScreenReal extends State<CalculatorScreen> {
  int _counter = 0;
  double k = 0;

  final txtEditContr1 = TextEditingController();
  final txtEditContr2 = TextEditingController();
  final txtEditContResult = TextEditingController();


  void _incrementCounter() {
    setState(() {
      var i = double.parse(txtEditContr1.text);
      var j = double.parse(txtEditContr2.text);

      k = i + j;
      txtEditContResult.text = k.toString();
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    var customTxtB = new customTextBox();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Calculator Demo..."),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Enter First and Second value and calculate',
              ),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(txtEditContr1, "First Element"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(txtEditContr2, "Second Element"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(txtEditContResult, "Result Element"),
              SizedBox(height: 10),
              Text(
                '$k',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Calculate',
        child: Text("Cal"),
        // const Icon(Icons.ten_k_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}