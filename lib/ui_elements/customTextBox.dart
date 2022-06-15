import 'package:flutter/material.dart';

class customTextBox
{
  TextField customTextBoxCrt(var contr, var txtLabel)
  {
    return TextField(
      controller: contr,


      decoration: InputDecoration(

        label: Text(txtLabel.toString()),
        border: OutlineInputBorder(),
        hintText: 'Enter a search term',
      ),
    );
  }
}
