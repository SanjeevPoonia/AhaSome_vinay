import 'dart:convert';

import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:toast/toast.dart';
import '../models/app_modal.dart';
import '../network/api_helper.dart';
import '../network/bloc/auth_bloc.dart';
import '../network/bloc/dashboard_bloc.dart';
import '../utils/app_theme.dart';
import '../utils/image_assets.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/input_field.dart';
import '../widgets/input_field_simple.dart';

class ForgotPassword extends StatefulWidget {
  final String userEmail;

  ForgotPassword(this.userEmail);

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  bool isObscureNewPassword = true;
  final authBloc = Modular.get<AuthCubit>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  double _strength = 0;
  String _displayText = '';
  late String _password;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/slider_1.jpg'),
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.35), BlendMode.multiply),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 65),
                      Image.asset(ImageAssets.logoWithText,
                          width: 240, height: 190),
                      const SizedBox(height: 15),
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'New Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: newPasswordController,
                                    obscureText: isObscureNewPassword,
                                    onChanged: (value) {
                                      _checkPassword(value);
                                    },
                                    validator: checkPasswordValidator,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(
                                            18.0, 20.0, 10.0, 19.0),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            if (isObscureNewPassword) {
                                              isObscureNewPassword = false;
                                            } else {
                                              isObscureNewPassword = true;
                                            }

                                            setState(() {});
                                          },
                                          child: isObscureNewPassword
                                              ? const Icon(
                                                  Icons.visibility_off,
                                                  color: AppTheme.icColor,
                                                )
                                              : const Icon(Icons.remove_red_eye,
                                                  color: AppTheme.icColor),
                                        ),
                                        labelText: 'New Password*',
                                        labelStyle: const TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 2),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 2),
                                            borderRadius:
                                                BorderRadius.circular(5.0)))),
                              ),
                              newPasswordController.text.isNotEmpty
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      child: LinearProgressIndicator(
                                        value: _strength,
                                        backgroundColor: Colors.grey[300],
                                        color: _strength <= 1 / 4
                                            ? Colors.red
                                            : _strength == 2 / 4
                                                ? Colors.yellow
                                                : _strength == 3 / 4
                                                    ? Colors.blue
                                                    : Colors.green,
                                        minHeight: 10,
                                      ),
                                    )
                                  : Container(),
                              newPasswordController.text.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 7),
                                      child: Text(
                                        _displayText,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(height: 5),
                              TextFieldSimple(
                                controller: confirmPasswordController,
                                labeltext: 'Confirm Password*',
                                validator: (val) {
                                  if (val!.isEmpty)
                                    return 'Cannot be left empty';
                                  if (val != newPasswordController.text) {
                                    return 'Password and Confirm Password do not match';
                                  }
                                  return null;
                                },
                                disable: true,
                              ),
                              SizedBox(height: 8),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                height: 48,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor: MaterialStateProperty.all<Color>(
                                            Colors.white),
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            AppTheme.themeColor),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                                side: BorderSide(
                                                    color:
                                                        AppTheme.themeColor)))),
                                    onPressed: () {
                                      _submitHandler(context);
                                    },
                                    child: const Text("Change Password",
                                        style: TextStyle(fontSize: 14))),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Email is required and should be valid Email address.';
    }
    return null;
  }

  String? nameValidator(String? value) {
    if (value!.isEmpty || !RegExp(r"[a-zA-Z]").hasMatch(value)) {
      return 'Enter a valid name';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value!)) {
      return 'Enter a valid Mobile Number';
    }
    return '';
  }

  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be Empty';
    }
    return null;
  }

  void _submitHandler(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _changePassword(context);
  }

  _changePassword(BuildContext context) {
    var formData = {
      'email': widget.userEmail,
      'password': newPasswordController.text
    };

    authBloc.changeForgotPassword(context, formData);
  }

  @override
  void initState() {
    super.initState();
  }

  String? checkPasswordValidator(String? value) {
    if (value!.length < 6) {
      return 'Password should have atleast 6 digit';
    }
    return null;
  }

  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = '';
      });
    } else if (_password.length < 3) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'too short';
      });
    } else if (_password.length >= 3 && _password.length < 6) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'not strong';
      });
    } else {
      setState(() {
        _strength = 1;
        _displayText = 'great';
      });
    }
  }
}
