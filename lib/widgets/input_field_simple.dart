

import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class TextFieldSimple extends StatelessWidget {
  TextEditingController controller;
  String labeltext;
  bool disable;
  final String? Function(String?)? validator;
  TextFieldSimple({required this.labeltext,required this.controller,required this.validator,required this.disable});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: controller,
          validator: validator,
          enabled: disable,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(18.0, 20.0, 10.0, 19.0),
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                color:Colors.grey,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(5.0)))),
    );
  }
}



class TextFieldPhone extends StatelessWidget {
  TextEditingController controller;
  String labeltext;

  bool suffixIc;
  TextFieldPhone({required this.labeltext,required this.controller,required this.suffixIc});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: controller,
          maxLength: 14,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(18.0, 20.0, 10.0, 19.0),
              suffixIcon: suffixIc?Icon(Icons.remove_red_eye, color: AppTheme.icColor):null,
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                color:Colors.grey,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(5.0)))),
    );
  }
}

class TextFieldPass extends StatelessWidget {
  TextEditingController controller;
  String labeltext;
  final String? Function(String?)? validator;
  bool isBoscure;
  Function onIconTap;
  Function onChanged;
  TextFieldPass({required this.labeltext,required this.controller,required this.validator,required this.isBoscure,required this.onIconTap,required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: controller,
          obscureText: isBoscure,
          onChanged: (value){
            onChanged();
          },
          validator: validator,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(18.0, 20.0, 10.0, 19.0),
              suffixIcon:GestureDetector(
                onTap: (){
                  onIconTap();
                },
                child: isBoscure?Icon(
                  Icons.visibility_off,
                  color: AppTheme.icColor,
                ): Icon(Icons.remove_red_eye, color: AppTheme.icColor),

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
                  borderSide: BorderSide(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(5.0)))),
    );
  }
}




class TextFieldWithHint extends StatelessWidget {
  TextEditingController controller;
  String labeltext;
  final String? Function(String?)? validator;

  bool suffixIc;
  TextFieldWithHint({required this.labeltext,required this.controller,required this.suffixIc,required this.validator});
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
              contentPadding: EdgeInsets.fromLTRB(18.0, 12.0, 10.0, 12.0),
              suffixIcon: suffixIc?Icon(Icons.visibility_off, color: AppTheme.icColor):null,
              hintText: labeltext,
              hintStyle: TextStyle(
                fontSize: 15.0,
                color:Colors.grey,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(5.0)))),
    );
  }
}