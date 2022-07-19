import 'dart:developer';

import 'package:flutter/material.dart';

class customUI
{
  SizedBox customTextBoxCrt(var contr, var txtLabel, {int passField = 0})
  {

    if(passField == 1) {
      return SizedBox(
          child: TextField(
        controller: contr,

        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          // contentPadding: EdgeInsets.symmetric(vertical: 20.0),
          label: Text(txtLabel.toString()),
          border: OutlineInputBorder(),
          hintText: 'Enter ' + txtLabel.toString(),
        ),
      ));
    }
    else
      {
        return SizedBox(
        height: 40,
            child: TextField(
          controller: contr,

          decoration: InputDecoration(
            // contentPadding: EdgeInsets.symmetric(vertical: 20.0),
            label: Text(txtLabel.toString()),
            isDense: true,
            border: OutlineInputBorder(),
            hintText: 'Enter ' + txtLabel.toString(),
          ),
        ));

      }
  }







  DropdownButton dropBtn() {
    return DropdownButton<String>(
      items: <String>['A', 'B', 'C', 'D'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (_) {},
    );
  }
}
