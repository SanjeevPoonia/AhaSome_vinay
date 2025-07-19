import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:aha_project_files/view/forgot_password.dart';
import 'package:aha_project_files/view/sign_up_screen.dart';
import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/utils/image_assets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../network/api_dialog.dart';
import '../widgets/gradient_text.dart';
import '../widgets/input_field.dart';
import 'package:toast/toast.dart';
import 'forgot.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  String selectedString = 'None selected';
  String selectedTab = 'Tab 1';
  bool isObscure = true;
  String? selectedValueState;
  String fcmToken='';
  String? selectedValueHobbies;
  final authBloc = Modular.get<AuthCubit>();
  String? selectedValueGender;
  final _formKeyLogin = GlobalKey<FormState>();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
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
            ListView(
              children: [
                const SizedBox(height: 40),

                selectedTab == 'Tab 1'?
                Center(
                  child: GradientText(
                    'Are you Ready to',
                    style: const TextStyle(fontSize: 20,fontFamily: 'Baumans',fontWeight: FontWeight.w600),
                    gradient: LinearGradient(colors: [
                      AppTheme.gradient1,
                      AppTheme.gradient2,
                      AppTheme.gradient3,
                      AppTheme.gradient4,
                    ]),
                  ),
                ):Container(),

                const SizedBox(height: 25),


                Image.asset(ImageAssets.logoWithText,
                    width: 95, height: 95),
                const SizedBox(height: 20),
                selectedTab == 'Tab 1'?
                const Text(
                  'IT\'S AN AMAZING, HAPPY AND AWESOME\n WORLD!!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13),
                  textAlign: TextAlign.center,
                ):Container(),

                const SizedBox(height: 20),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                          style: ButtonStyle(
                              tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(selectedTab == 'Tab 1'
                                  ? AppTheme.themeColor
                                  : AppTheme.icColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      side: BorderSide(
                                          color: selectedTab == 'Tab 1'
                                              ? AppTheme.themeColor
                                              : AppTheme.icColor)))),
                          onPressed: () {
                            setState(() {
                              selectedTab = 'Tab 1';
                            });
                          },
                          child: const Text("Login", style: TextStyle(fontSize: 14))),
                      ElevatedButton(
                          style: ButtonStyle(
                              tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                              foregroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  selectedTab == 'Tab 2'
                                      ? AppTheme.themeColor
                                      : AppTheme.icColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      side: BorderSide(
                                          color: selectedTab == 'Tab 2' ? AppTheme.themeColor : AppTheme.icColor)))),
                          onPressed: () {
                            setState(() {
                              selectedTab = 'Tab 2';
                            });
                          },
                          child: const Text("Register",
                              style: TextStyle(fontSize: 14)))
                    ],
                  ),
                ),
                selectedTab == 'Tab 1'
                    ? Form(
                    key: _formKeyLogin,
                    child: Card(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 20),
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
                              'Sign In',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),

                            const SizedBox(height: 10),

                            TextFieldShow(
                              controller: loginController,
                              labeltext: 'Email',
                              validator: checkEmptyString,
                              fieldIC: const Icon(Icons.mail,
                                  color: AppTheme.icColor),
                              suffixIc: const Icon(
                                Icons.abc,
                                size: 0,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                  controller: passwordController,
                                  validator: checkPasswordValidator,
                                  obscureText: isObscure,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      contentPadding:
                                      const EdgeInsets.fromLTRB(
                                          0.0, 20.0, 0.0, 19.0),
                                      prefixIcon: const Icon(Icons.lock,
                                          color: AppTheme.icColor),
                                      suffixIcon: IconButton(
                                        icon: isObscure
                                            ? const Icon(
                                          Icons.visibility_off,
                                          color: AppTheme.icColor,
                                        )
                                            : const Icon(
                                          Icons.visibility,
                                          color: AppTheme.icColor,
                                        ),
                                        onPressed: () {
                                          Future.delayed(Duration.zero,
                                                  () async {
                                                if (isObscure) {
                                                  isObscure = false;
                                                } else {
                                                  isObscure = true;
                                                }

                                                setState(() {});
                                              });
                                        },
                                      ),
                                      labelText: 'Password',
                                      labelStyle: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey,
                                              width: 2),
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 2),
                                          borderRadius:
                                          BorderRadius.circular(
                                              5.0)))),
                            ),

                            const SizedBox(height: 13),

                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 6),
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
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(12)),
                                              side: BorderSide(color: AppTheme.themeColor)))),
                                  onPressed: () {
                                    _submitHandler(context);
                                  },
                                  child: const Text("Login",
                                      style: TextStyle(fontSize: 14))),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children:  [
                                const Spacer(),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Forgot()));
                                  },
                                  child:  const Text(
                                    'Forgot Password ?',
                                    style: TextStyle(
                                        color: AppTheme.forgotPassColor,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ))
                    : SignUpScreen(),
                const SizedBox(height: 20)
              ],
            ),
          ],
        ),);
  }

  @override
  void initState() {
    super.initState();
    fetchFCMToken();
  }

  String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be Empty';
    }
    return null;
  }

  String? checkPasswordValidator(String? value) {
    if (value!.length < 6) {
      return 'Password should have atleast 6 digit';
    }
    return null;
  }

  fetchFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    fcmToken=token!;
    print('FCM Token');
    print(token);
  }
  void _submitHandler(BuildContext context) async {
    if (!_formKeyLogin.currentState!.validate()) {
      return;
    }
    _formKeyLogin.currentState!.save();
    _loginUser(context);
  }

  _loginUser(BuildContext context) {
    print(fcmToken);
    var requestModel = {
      'email': loginController.text,
      'password':passwordController.text,
      'device_id':fcmToken.toString()
    };
    authBloc.loginUser('loginUser', context, requestModel);
  }
}
