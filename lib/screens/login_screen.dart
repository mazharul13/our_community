import 'package:flutter/material.dart';
import '../ui_elements/customTextBox.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => LoginScreenReal();
}

class LoginScreenReal extends State<LoginScreen> {

  final txtEditContr1 = TextEditingController();
  final txtEditContr2 = TextEditingController();

  void loginCheck()
  {

  }

  @override
  Widget build(BuildContext context) {
    var customTxtB = new customTextBox();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Login please..."),
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
                'Please enter your credentials...',
              ),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(txtEditContr1, "User Name"),
              SizedBox(height: 10),
              customTxtB.customTextBoxCrt(txtEditContr2, "Password"),
              SizedBox(height: 10),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loginCheck,
        tooltip: 'Login',
        child: Text("Login"),
        // const Icon(Icons.ten_k_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}