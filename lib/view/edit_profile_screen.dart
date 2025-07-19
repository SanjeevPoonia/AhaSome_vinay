import 'dart:convert';

import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/view/change_password_screen.dart';
import 'package:aha_project_files/view/edit_hobbies_screen.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:country_picker/country_picker.dart';
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
import '../network/bloc/friends_bloc.dart';
import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/input_field_simple.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final _formKeySignUp = GlobalKey<FormState>();
  List<String> hobbiesList=[];
  final friendsBloc = Modular.get<FriendsCubit>();
  final dashBoardBloc = Modular.get<DashboardCubit>();
  final authBloc = Modular.get<AuthCubit>();
  List<dynamic> userProfile = [];
  TextEditingController professionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  String hobbies='';
  String? selectedValueCountryCode;
  bool isLoading = false;
  String profession = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: Scaffold(
              body: BlocBuilder(
        bloc: dashBoardBloc,
        builder: (context, state) {
          return Form(
              key: _formKeySignUp,
              child: Stack(
                children: [
                  BackgroundWidget(),
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
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                children: [
                                  const SizedBox(height: 15),
                                   Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Edit Basic Info',
                                          style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePassword(emailController.text)));
                                          },
                                          child: Text(
                                            'Change Password',
                                            style: TextStyle(
                                                color: AppTheme.navigationRed,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: TextFieldSimple(
                                          controller: nameController,
                                          labeltext: 'First Name*',
                                          validator: nameValidator,
                                          disable: true,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: TextFieldSimple(
                                          controller: lastNameController,
                                          labeltext: 'Last Name*',
                                          validator: nameValidator,
                                          disable: true,
                                        ),
                                      )
                                    ],
                                  ),

                                  /*   TextFieldPhone(
                                controller: mobileController,
                                labeltext: 'Mobile Number',
                                suffixIc: false,
                              ),
*/
                                  const SizedBox(height: 5),
                                  TextFieldSimple(
                                    controller: emailController,
                                    labeltext: 'Email*',
                                    validator: emailValidator,
                                    disable: false,
                                  ),

                                  const SizedBox(height: 5),
                                  TextFieldPhone(
                                    controller: mobileController,
                                    labeltext: 'Mobile Number',
                                    suffixIc: false,
                                  ),
                                  const SizedBox(height: 5),

                                  InkWell(
                                    onTap: (){
                                      showCountryPicker(
                                        context: context,
                                        countryListTheme: CountryListThemeData(
                                          flagSize: 25,
                                          backgroundColor: Colors.white,
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87),
                                          bottomSheetHeight: 500,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                          ),
                                          //Optional. Styles the search field.
                                          inputDecoration: InputDecoration(
                                            labelText: 'Search Countries',
                                            hintText: 'Start typing to search',
                                            suffixIcon: const Icon(Icons.search),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: const Color(0xFF8C98A8)
                                                    .withOpacity(0.2),
                                              ),
                                            ),
                                          ),
                                        ),

                                        showPhoneCode: false,

                                        // optional. Shows phone code before the country name.
                                        onSelect: (Country country) {
                                          if (kDebugMode) {
                                            print(
                                                'Select country: ${country.displayName}');
                                          }
                                          setState(() {
                                            countryController.text = country.name;
                                          });
                                        },
                                      );
                                    },
                                    child:   TextFieldSimple(
                                      controller: countryController,
                                      labeltext: 'Country*',
                                      validator: null,
                                      disable: false,
                                    ),
                                  ),

                                  const SizedBox(height: 5),
                                  TextFieldSimple(
                                    controller: stateController,
                                    labeltext: 'State',
                                    validator: null,
                                    disable: true,
                                  ),


                                  SizedBox(height: 13),

                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10,top: 10),
                                        child: Text(
                                          'Hobbies',
                                          style: TextStyle(
                                              color: Colors.brown,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ),

                                     Spacer(),

                                      Container(
                                        margin:
                                        const EdgeInsets.only(left: 10,top: 5),
                                        height: 30,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                              backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppTheme.navigationRed),
                                            ),
                                            onPressed: () async {

                                              hobbies=hobbies.replaceAll('[','');
                                              hobbies=hobbies.replaceAll(']','');
                                              print(hobbies);

                                              List<String> list= (hobbies.split(','));
                                              print('***');
                                              print(list);

                                              final data= await Navigator.push(context, MaterialPageRoute(builder: (context)=>EditHobbyScreen(list)));
                                              if(data!=null)
                                              {
                                                fetchAboutUser(context);
                                              }


          },
                                            child: const Text("Edit",
                                                style: TextStyle(fontSize: 15))),



                                      ),

                                      SizedBox(width: 20)



                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(left: 10,right: 10),
                                    child: Text(
                                      hobbies,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.5),
                                    ),
                                  ),



                                  const SizedBox(height: 20),
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
                                        onPressed: () =>
                                            _submitHandlerSignUp(context),
                                        child: const Text("UPDATE",
                                            style: TextStyle(fontSize: 17))),
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

  void _submitHandlerSignUp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_formKeySignUp.currentState!.validate()) {
      return;
    }
    _formKeySignUp.currentState!.save();

    updateUserProfile(context);
  }

  _fetchSignUpData() {
    //prepare data
  }

  @override
  void initState() {
    super.initState();

    fetchAboutUser(context);
  }

  fetchAboutUser(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var formData = {'auth_key': AppModel.authKey};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('aboutUser', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    userProfile = responseJson['user_profile'];
    if(userProfile[0]['profession']!=null)
    {
      professionController.text = userProfile[0]['profession'];
    }
    nameController.text = userProfile[0]['first_name'];
    lastNameController.text = userProfile[0]['last_name'];
    emailController.text = userProfile[0]['email'];
    countryController.text = userProfile[0]['country'];
    if(userProfile[0]['state']!=null)
    {
      stateController.text = userProfile[0]['state'];
    }
   hobbies = userProfile[0]['hobbies'].toString();
   //hobbiesList = userProfile[0]['hobbies'];
    if(userProfile[0]['mobile_number']!=null)
      {
        mobileController.text =userProfile[0]['mobile_number'].toString();
      }
    isLoading = false;

    setState(() {});
  }

  updateUserProfile(BuildContext context) async {
    APIDialog.showAlertDialog(context, 'Updating profile...');
    var formData = {
      'auth_key': AppModel.authKey,
      'first_name': nameController.text,
      'last_name': lastNameController.text,
      'gender': friendsBloc.state
          .friendProfile[0].gender,
      'date_of_birth':  friendsBloc.state
          .friendProfile[0].date_of_birth,
      'profession': professionController.text,
      'country': countryController.text,
      'state': stateController.text,
      'mobile_number': mobileController.text,
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('editBasicInfo', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    Navigator.pop(context);
    print(responseJson);
    if (responseJson['status'] == AppConstant.apiSuccess) {
      Toast.show('Updated Successfully',
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context, 'Profile Updated');
      authBloc.refreshNameEveryWhere(responseJson['edit_user']['first_name'],
          responseJson['edit_user']['last_name']);
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
        Utils.logoutUser(context);
        break;
    }
  }
}
