import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget dropDown({
  String value,
  List<String> valueList,
  Color textColor,
  FontWeight fontWeight,
  Function changeValue,
}) {
  return DropdownButton(
    value: valueList[0],
    items: valueList.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Align(
          child: Text(value),
          alignment: Alignment.centerLeft,
        ),
      );
    }).toList(),
    onChanged: (String newValue) {
      changeValue(newValue: newValue, value: value);
    },
    underline: Container(height: 0),
    style: TextStyle(color: textColor, fontWeight: fontWeight, fontSize: 16),
  );
}
