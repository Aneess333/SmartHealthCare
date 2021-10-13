import 'package:flutter/material.dart';

const kTextStyle = TextStyle(
  color: Color(0xFFE7E0C9),
);

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
  );
}