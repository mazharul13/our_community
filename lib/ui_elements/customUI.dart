import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class customUI
{

  SizedBox customTextBoxCrt2(var contr, var txtLabel)
  {
      return SizedBox(
          child: TextField(
            controller: contr,

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



  TextField customTextDatePicker(var contr, var context, Function setNewDate) {
    return TextField(
        controller: contr, //editing controller of this TextField
        decoration: InputDecoration(
            icon: Icon(Icons.calendar_today), //icon of text field
            labelText: "Enter Date" //label text of field
        ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2101)
          );

          if (pickedDate != null) {
            print(
                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            print(
                formattedDate); //formatted date output using intl package =>  2021-03-16
            //you can implement different kind of Date Format here according to your requirement
            setNewDate(formattedDate);

            // setState(() {
            //   contr.text =
            //       formattedDate; //set output date to TextField value.
            // });
          } else {
            print("Date is not selected");
          }
        });


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
