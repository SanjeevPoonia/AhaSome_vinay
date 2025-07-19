import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/view/forgot_password.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:toast/toast.dart';
import 'dart:async';

import '../network/bloc/auth_bloc.dart';
import '../utils/app_theme.dart';

class OTPScreen extends StatefulWidget {
  final String otp, email, callbackType;

  OTPScreen(this.otp, this.email, this.callbackType);

  OTPState createState() => OTPState();
}

class OTPState extends State<OTPScreen> {
  var _fromData;
  String otpText='';
  String userEnteredOTP = '';
  final authBloc = Modular.get<AuthCubit>();
  late Timer _timer;
  int _start = 20;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            BackgroundWidget(),
            Column(
              children: [
                const SizedBox(
                  height: 65,
                ),
                Center(
                    child: Image.asset('assets/otp_ic.png',
                        color: AppTheme.gradient1)),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Verification Code',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 17.5),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Please enter the OTP sent on your email',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.5),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: OtpTextField(
                    numberOfFields: 6,
                    borderColor: Color(0xFF512DA8),
                    focusedBorderColor: AppTheme.gradient1,
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: true,
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      //handle validation or checks here
                    },

                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      setState(() {
                        userEnteredOTP = verificationCode;
                      });

                      print(verificationCode);
                    }, // end onSubmit
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: (){
                        if(_start==0)
                        {
                          _callResendOTP(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(

                          _start==0?
                          'Resend Otp':
                          'Resend Otp '+_start.toString(),
                          style: TextStyle(

                              color:

                              _start==0?
                              Colors.brown:
                              Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    height: 55,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppTheme.themeColor),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                            color: AppTheme.themeColor)))),
                        onPressed: () {
                          if (userEnteredOTP.length == 6) {
                            // call API

                            _verifyOTP();
                          }
                        },
                        child: const Text("Verify OTP",
                            style: TextStyle(fontSize: 14)))),
              ],
            )
          ],
        ),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    print(widget.otp);
    startTimer();
    otpText=widget.otp;
    _fromData = {
      'user_email': '',
      'otp': '',
    };
  }

  _verifyOTP() {
    _fromData["user_email"] = widget.email;
    _fromData["otp"] = userEnteredOTP;
    APIDialog.showAlertDialog(context, 'Verifying OTP');
    authBloc.verifyUserOTP(context, _fromData);
  }

  _callResendOTP(BuildContext context) async {
    print(widget.email);
    var formData = {'email': widget.email};
    String newOtp= await authBloc.resendOtp(context, formData);
    setState((){
      _start=20;
    });
    startTimer();
    otpText=newOtp;
    print(otpText);
  }
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer)
      {        if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
      },
    );
  }

}
