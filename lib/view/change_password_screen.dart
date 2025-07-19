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
import '../widgets/app_bar_widget.dart';
import '../widgets/input_field_simple.dart';

class ChangePassword extends StatefulWidget {
  final String userEmail;

  ChangePassword(this.userEmail);

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final dashBoardBloc = Modular.get<DashboardCubit>();
  final authBloc = Modular.get<AuthCubit>();
  List<dynamic> userProfile = [];
  TextEditingController professionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? selectedValueCountryCode;
  bool isLoading = false;
  String profession = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  double _strength = 0;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isObscureCurrentPassword = true;
  String _displayText = '';
  bool isObscureNewPassword = true;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: Scaffold(
              body: BlocBuilder(
        bloc: dashBoardBloc,
        builder: (context, state) {
          return Form(
              key: _formKey,
              child: Stack(
                children: [
                //  BackgroundWidget(),
                  Column(
                    children: [
                      AppBarNew(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        iconButton: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_outlined,
                              color: Colors.white),
                          onSelected: handleClick,
                          itemBuilder: (BuildContext context) {
                            return {'Logout'}.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                        showBackIc: true,
                      ),
                      Expanded(
                        child: isLoading
                            ? Loader()
                            : ListView(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                children: [
                                  const SizedBox(height: 15),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: const Text(
                                      'Change Password',
                                      style: TextStyle(
                                          color: Color(0xFF8A8A8A),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFieldPass(
                                    controller: currentPasswordController,
                                    labeltext: 'Current Password*',
                                    onChanged: () {},
                                    validator: null,
                                    isBoscure: isObscureCurrentPassword,
                                    onIconTap: () {
                                      if (isObscureCurrentPassword) {
                                        isObscureCurrentPassword = false;
                                      } else {
                                        isObscureCurrentPassword = true;
                                      }

                                      setState(() {});
                                    },
                                  ),
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
                                                  : const Icon(
                                                      Icons.remove_red_eye,
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
                                  const SizedBox(height: 5),
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
                                  const SizedBox(height: 10),
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 6),
                                    height: 48,
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppTheme.themeColor),
                                        ),
                                        onPressed: () => _submitHandler(context),
                                        child: const Text("Change Password",
                                            style: TextStyle(fontSize: 15))),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                      ),
                    ],
                  ),
                ],
              ));
        },
      ))),
    );
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

    changePassword(context);
  }

  _fetchSignUpData() {
    //prepare data
  }

  @override
  void initState() {
    super.initState();
  }

  changePassword(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Please wait...');
    var formData = {
      'auth_key': AppModel.authKey,
      'email': widget.userEmail,
      'password': currentPasswordController.text,
      'new_password': newPasswordController.text,
    };
    print(formData);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('updatePassword', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    Navigator.pop(context);
    print(responseJson);
    if (responseJson['status'] == AppConstant.apiSuccess) {
      Toast.show(responseJson['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context);
    } else {
      Toast.show(responseJson['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
    /* professionController.text=userProfile[0]['profession'];
    nameController.text=userProfile[0]['first_name'];
    lastNameController.text=userProfile[0]['last_name'];
    emailController.text=userProfile[0]['email'];
    mobileController.text=userProfile[0]['mobile_number'];*/

    setState(() {});
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
    }
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
