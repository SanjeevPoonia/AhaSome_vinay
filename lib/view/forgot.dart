import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:toast/toast.dart';

import '../utils/app_theme.dart';
import '../utils/image_assets.dart';
import '../widgets/input_field.dart';

class Forgot extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  final authBloc = Modular.get<AuthCubit>();

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
                                'Forgot Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              TextFieldShow(
                                controller: emailController,
                                labeltext: 'Email*',
                                validator: emailValidator,
                                fieldIC: const Icon(Icons.mail,
                                    color: AppTheme.icColor),
                                suffixIc: const Icon(
                                  Icons.abc,
                                  size: 0,
                                ),
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
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppTheme.themeColor),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                                side: BorderSide(
                                                    color: AppTheme.themeColor)))),
                                    onPressed: () {
                                      _submitHandler(context);
                                    },
                                    child: const Text("Send OTP", style: TextStyle(fontSize: 14))),
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

  void _submitHandler(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _callSendOTPAPI(context);
  }

  String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Email is required and should be valid Email address.';
    }
    return null;
  }

  _callSendOTPAPI(BuildContext context) {
    var formData = {'email': emailController.text};
    authBloc.sendOtpForgot(context, formData);
  }
}
