

import 'package:flutter/material.dart';

class TextFieldShow extends StatelessWidget {
  TextEditingController controller;
  String labeltext;
  Icon fieldIC;
  final String? Function(String?)? validator;
  Icon suffixIc;
  TextFieldShow({required this.labeltext,required this.controller,required this.fieldIC,required this.suffixIc,required this.validator});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: controller,
          validator: validator,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 19.0),
              prefixIcon: fieldIC,
              suffixIcon:InkWell(
                child: suffixIc,
              ),
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                color:Colors.grey,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(5.0)))),
    );
  }
}