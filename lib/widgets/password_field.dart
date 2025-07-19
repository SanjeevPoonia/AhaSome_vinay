import 'package:aha_project_files/utils/app_theme.dart';
import 'package:flutter/material.dart';

class PasswordWidget extends StatelessWidget {
  TextEditingController controller;
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  Function onIconTap;
  Function onChanged;
  bool isOnscure;
  final String? Function(String?)? validator;

  PasswordWidget(
      {required this.labeltext,
      required this.controller,
      required this.fieldIC,
      required this.suffixIc,
      required this.onIconTap,
      required this.isOnscure,
      required this.validator,
        required this.onChanged


      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: controller,
          onChanged: onChanged(),
          validator: validator,
          obscureText: isOnscure,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 19.0),
              prefixIcon: fieldIC,
              suffixIcon: IconButton(
                icon: isOnscure
                    ? Icon(
                        Icons.visibility_off,
                        color: AppTheme.icColor,
                      )
                    : suffixIc,
                onPressed: () {
                  onIconTap();
                },
              ),
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                color: Colors.grey,
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
