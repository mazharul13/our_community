import 'dart:developer';

import 'package:flutter/material.dart';

class customUI
{
  TextField customTextBoxCrt(var contr, var txtLabel)
  {
    return TextField(
      controller: contr,
      decoration: InputDecoration(
        label: Text(txtLabel.toString()),
        border: OutlineInputBorder(),
        hintText: 'Enter '+txtLabel.toString(),
      ),
    );
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
