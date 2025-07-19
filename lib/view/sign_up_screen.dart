import 'dart:convert';
import 'dart:io';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/view/privacy_policy.dart';
import 'package:aha_project_files/view/terms_scereen.dart';
import 'package:aha_project_files/widgets/terms_separate.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import '../models/app_modal.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../network/bloc/auth_bloc.dart';
import '../utils/app_theme.dart';
import '../widgets/input_field_simple.dart';
import 'package:country_codes/country_codes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUpScreen> {
  final _formKeySignUp = GlobalKey<FormState>();
  File? _image;
  String selectedCode='';
  double _strength = 0;
  String _displayText = '';
  bool ugcConditionsAgreed=false;

  String? _platformVersion = 'Unknown';

  String? dobDate;
  String? marriageDate;
  String stateName='';
  String countryName='';
  String countryISOCode='';

  String fcmToken='';
  DateTime todaysDate = DateTime.now();
  final picker = ImagePicker();
  final authBloc = Modular.get<AuthCubit>();
  TextEditingController hobbiesController = TextEditingController();
  var focusNode = FocusNode();
  bool hobbiesVisibility = false;
  List<dynamic> hobbiesAPIList = [];
  List<dynamic> hobbiesSearchAPIList = [];
  List<String> tabAddedList = [];
  List<String> tabAddedListOrange = [];
  TextEditingController professionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordControllerSignUp = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController stateControllerController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? selectedValueCountryCode;
  String? selectedValueCountry;
  String? selectedGender;
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool isObscurePasswordS = true;
  String selectedCountry = 'Select Country';
  List<dynamic> telephoneList=[{"country":"Afghanistan","code":"93","iso":"AF"},
  {"country":"Albania","code":"355","iso":"AL"},
{"country":"Algeria","code":"213","iso":"DZ"},
{"country":"American Samoa","code":"1-684","iso":"AS"},
{"country":"Andorra","code":"376","iso":"AD"},
{"country":"Angola","code":"244","iso":"AO"},
{"country":"Anguilla","code":"1-264","iso":"AI"},
{"country":"Antarctica","code":"672","iso":"AQ"},
{"country":"Antigua and Barbuda","code":"1-268","iso":"AG"},
{"country":"Argentina","code":"54","iso":"AR"},
{"country":"Armenia","code":"374","iso":"AM"},
{"country":"Aruba","code":"297","iso":"AW"},
{"country":"Australia","code":"61","iso":"AU"},
{"country":"Austria","code":"43","iso":"AT"},
{"country":"Azerbaijan","code":"994","iso":"AZ"},
{"country":"Bahamas","code":"1-242","iso":"BS"},
{"country":"Bahrain","code":"973","iso":"BH"},
{"country":"Bangladesh","code":"880","iso":"BD"},
{"country":"Barbados","code":"1-246","iso":"BB"},
{"country":"Belarus","code":"375","iso":"BY"},
{"country":"Belgium","code":"32","iso":"BE"},
{"country":"Belize","code":"501","iso":"BZ"},
{"country":"Benin","code":"229","iso":"BJ"},
{"country":"Bermuda","code":"1-441","iso":"BM"},
{"country":"Bhutan","code":"975","iso":"BT"},
{"country":"Bolivia","code":"591","iso":"BO"},
{"country":"Bosnia and Herzegovina","code":"387","iso":"BA"},
{"country":"Botswana","code":"267","iso":"BW"},
{"country":"Brazil","code":"55","iso":"BR"},
{"country":"British Indian Ocean Territory","code":"246","iso":"IO"},
{"country":"British Virgin Islands","code":"1-284","iso":"VG"},
{"country":"Brunei","code":"673","iso":"BN"},
{"country":"Bulgaria","code":"359","iso":"BG"},
{"country":"Burkina Faso","code":"226","iso":"BF"},
{"country":"Burundi","code":"257","iso":"BI"},
{"country":"Cambodia","code":"855","iso":"KH"},
{"country":"Cameroon","code":"237","iso":"CM"},
{"country":"Canada","code":"1","iso":"CA"},
{"country":"Cape Verde","code":"238","iso":"CV"},
{"country":"Cayman Islands","code":"1-345","iso":"KY"},
{"country":"Central African Republic","code":"236","iso":"CF"},
{"country":"Chad","code":"235","iso":"TD"},
{"country":"Chile","code":"56","iso":"CL"},
{"country":"China","code":"86","iso":"CN"},
{"country":"Christmas Island","code":"61","iso":"CX"},
{"country":"Cocos Islands","code":"61","iso":"CC"},
{"country":"Colombia","code":"57","iso":"CO"},
{"country":"Comoros","code":"269","iso":"KM"},
{"country":"Cook Islands","code":"682","iso":"CK"},
{"country":"Costa Rica","code":"506","iso":"CR"},
{"country":"Croatia","code":"385","iso":"HR"},
{"country":"Cuba","code":"53","iso":"CU"},
{"country":"Curacao","code":"599","iso":"CW"},
{"country":"Cyprus","code":"357","iso":"CY"},
{"country":"Czech Republic","code":"420","iso":"CZ"},
{"country":"Democratic Republic of the Congo","code":"243","iso":"CD"},
{"country":"Denmark","code":"45","iso":"DK"},
{"country":"Djibouti","code":"253","iso":"DJ"},
{"country":"Dominica","code":"1-767","iso":"DM"},
{"country":"Dominican Republic","code":"1-809, 1-829, 1-849","iso":"DO"},
{"country":"East Timor","code":"670","iso":"TL"},
{"country":"Ecuador","code":"593","iso":"EC"},
{"country":"Egypt","code":"20","iso":"EG"},
{"country":"El Salvador","code":"503","iso":"SV"},
{"country":"Equatorial Guinea","code":"240","iso":"GQ"},
{"country":"Eritrea","code":"291","iso":"ER"},
{"country":"Estonia","code":"372","iso":"EE"},
{"country":"Ethiopia","code":"251","iso":"ET"},
{"country":"Falkland Islands","code":"500","iso":"FK"},
{"country":"Faroe Islands","code":"298","iso":"FO"},
{"country":"Fiji","code":"679","iso":"FJ"},
{"country":"Finland","code":"358","iso":"FI"},
{"country":"France","code":"33","iso":"FR"},
{"country":"French Polynesia","code":"689","iso":"PF"},
{"country":"Gabon","code":"241","iso":"GA"},
{"country":"Gambia","code":"220","iso":"GM"},
{"country":"Georgia","code":"995","iso":"GE"},
{"country":"Germany","code":"49","iso":"DE"},
{"country":"Ghana","code":"233","iso":"GH"},
{"country":"Gibraltar","code":"350","iso":"GI"},
{"country":"Greece","code":"30","iso":"GR"},
{"country":"Greenland","code":"299","iso":"GL"},
{"country":"Grenada","code":"1-473","iso":"GD"},
{"country":"Guam","code":"1-671","iso":"GU"},
{"country":"Guatemala","code":"502","iso":"GT"},
{"country":"Guernsey","code":"44-1481","iso":"GG"},
{"country":"Guinea","code":"224","iso":"GN"},
{"country":"Guinea-Bissau","code":"245","iso":"GW"},
{"country":"Guyana","code":"592","iso":"GY"},
{"country":"Haiti","code":"509","iso":"HT"},
{"country":"Honduras","code":"504","iso":"HN"},
{"country":"Hong Kong","code":"852","iso":"HK"},
{"country":"Hungary","code":"36","iso":"HU"},
{"country":"Iceland","code":"354","iso":"IS"},
{"country":"India","code":"91","iso":"IN"},
{"country":"Indonesia","code":"62","iso":"ID"},
{"country":"Iran","code":"98","iso":"IR"},
{"country":"Iraq","code":"964","iso":"IQ"},
{"country":"Ireland","code":"353","iso":"IE"},
{"country":"Isle of Man","code":"44-1624","iso":"IM"},
{"country":"Israel","code":"972","iso":"IL"},
{"country":"Italy","code":"39","iso":"IT"},
{"country":"Ivory Coast","code":"225","iso":"CI"},
{"country":"Jamaica","code":"1-876","iso":"JM"},
{"country":"Japan","code":"81","iso":"JP"},
{"country":"Jersey","code":"44-1534","iso":"JE"},
{"country":"Jordan","code":"962","iso":"JO"},
{"country":"Kazakhstan","code":"7","iso":"KZ"},
{"country":"Kenya","code":"254","iso":"KE"},
{"country":"Kiribati","code":"686","iso":"KI"},
{"country":"Kosovo","code":"383","iso":"XK"},
{"country":"Kuwait","code":"965","iso":"KW"},
{"country":"Kyrgyzstan","code":"996","iso":"KG"},
{"country":"Laos","code":"856","iso":"LA"},
{"country":"Latvia","code":"371","iso":"LV"},
{"country":"Lebanon","code":"961","iso":"LB"},
{"country":"Lesotho","code":"266","iso":"LS"},
{"country":"Liberia","code":"231","iso":"LR"},
{"country":"Libya","code":"218","iso":"LY"},
{"country":"Liechtenstein","code":"423","iso":"LI"},
{"country":"Lithuania","code":"370","iso":"LT"},
{"country":"Luxembourg","code":"352","iso":"LU"},
{"country":"Macao","code":"853","iso":"MO"},
{"country":"Macedonia","code":"389","iso":"MK"},
{"country":"Madagascar","code":"261","iso":"MG"},
{"country":"Malawi","code":"265","iso":"MW"},
{"country":"Malaysia","code":"60","iso":"MY"},
{"country":"Maldives","code":"960","iso":"MV"},
{"country":"Mali","code":"223","iso":"ML"},
{"country":"Malta","code":"356","iso":"MT"},
{"country":"Marshall Islands","code":"692","iso":"MH"},
{"country":"Mauritania","code":"222","iso":"MR"},
{"country":"Mauritius","code":"230","iso":"MU"},
{"country":"Mayotte","code":"262","iso":"YT"},
{"country":"Mexico","code":"52","iso":"MX"},
{"country":"Micronesia","code":"691","iso":"FM"},
{"country":"Moldova","code":"373","iso":"MD"},
{"country":"Monaco","code":"377","iso":"MC"},
{"country":"Mongolia","code":"976","iso":"MN"},
{"country":"Montenegro","code":"382","iso":"ME"},
{"country":"Montserrat","code":"1-664","iso":"MS"},
{"country":"Morocco","code":"212","iso":"MA"},
{"country":"Mozambique","code":"258","iso":"MZ"},
{"country":"Myanmar","code":"95","iso":"MM"},
{"country":"Namibia","code":"264","iso":"NA"},
{"country":"Nauru","code":"674","iso":"NR"},
{"country":"Nepal","code":"977","iso":"NP"},
{"country":"Netherlands","code":"31","iso":"NL"},
{"country":"Netherlands Antilles","code":"599","iso":"AN"},
{"country":"New Caledonia","code":"687","iso":"NC"},
{"country":"New Zealand","code":"64","iso":"NZ"},
{"country":"Nicaragua","code":"505","iso":"NI"},
{"country":"Niger","code":"227","iso":"NE"},
{"country":"Nigeria","code":"234","iso":"NG"},
{"country":"Niue","code":"683","iso":"NU"},
{"country":"North Korea","code":"850","iso":"KP"},
{"country":"Northern Mariana Islands","code":"1-670","iso":"MP"},
{"country":"Norway","code":"47","iso":"NO"},
{"country":"Oman","code":"968","iso":"OM"},
{"country":"Pakistan","code":"92","iso":"PK"},
{"country":"Palau","code":"680","iso":"PW"},
{"country":"Palestine","code":"970","iso":"PS"},
{"country":"Panama","code":"507","iso":"PA"},
{"country":"Papua New Guinea","code":"675","iso":"PG"},
{"country":"Paraguay","code":"595","iso":"PY"},
{"country":"Peru","code":"51","iso":"PE"},
{"country":"Philippines","code":"63","iso":"PH"},
{"country":"Pitcairn","code":"64","iso":"PN"},
{"country":"Poland","code":"48","iso":"PL"},
{"country":"Portugal","code":"351","iso":"PT"},
{"country":"Puerto Rico","code":"1-787, 1-939","iso":"PR"},
{"country":"Qatar","code":"974","iso":"QA"},
{"country":"Republic of the Congo","code":"242","iso":"CG"},
{"country":"Reunion","code":"262","iso":"RE"},
{"country":"Romania","code":"40","iso":"RO"},
{"country":"Russia","code":"7","iso":"RU"},
{"country":"Rwanda","code":"250","iso":"RW"},
{"country":"Saint Barthelemy","code":"590","iso":"BL"},
{"country":"Saint Helena","code":"290","iso":"SH"},
{"country":"Saint Kitts and Nevis","code":"1-869","iso":"KN"},
{"country":"Saint Lucia","code":"1-758","iso":"LC"},
{"country":"Saint Martin","code":"590","iso":"MF"},
{"country":"Saint Pierre and Miquelon","code":"508","iso":"PM"},
{"country":"Saint Vincent and the Grenadines","code":"1-784","iso":"VC"},
{"country":"Samoa","code":"685","iso":"WS"},
{"country":"San Marino","code":"378","iso":"SM"},
{"country":"Sao Tome and Principe","code":"239","iso":"ST"},
{"country":"Saudi Arabia","code":"966","iso":"SA"},
{"country":"Senegal","code":"221","iso":"SN"},
{"country":"Serbia","code":"381","iso":"RS"},
{"country":"Seychelles","code":"248","iso":"SC"},
{"country":"Sierra Leone","code":"232","iso":"SL"},
{"country":"Singapore","code":"65","iso":"SG"},
{"country":"Sint Maarten","code":"1-721","iso":"SX"},
{"country":"Slovakia","code":"421","iso":"SK"},
{"country":"Slovenia","code":"386","iso":"SI"},
{"country":"Solomon Islands","code":"677","iso":"SB"},
{"country":"Somalia","code":"252","iso":"SO"},
{"country":"South Africa","code":"27","iso":"ZA"},
{"country":"South Korea","code":"82","iso":"KR"},
{"country":"South Sudan","code":"211","iso":"SS"},
{"country":"Spain","code":"34","iso":"ES"},
{"country":"Sri Lanka","code":"94","iso":"LK"},
{"country":"Sudan","code":"249","iso":"SD"},
{"country":"Suriname","code":"597","iso":"SR"},
{"country":"Svalbard and Jan Mayen","code":"47","iso":"SJ"},
{"country":"Swaziland","code":"268","iso":"SZ"},
{"country":"Sweden","code":"46","iso":"SE"},
{"country":"Switzerland","code":"41","iso":"CH"},
{"country":"Syria","code":"963","iso":"SY"},
{"country":"Taiwan","code":"886","iso":"TW"},
{"country":"Tajikistan","code":"992","iso":"TJ"},
{"country":"Tanzania","code":"255","iso":"TZ"},
{"country":"Thailand","code":"66","iso":"TH"},
{"country":"Togo","code":"228","iso":"TG"},
{"country":"Tokelau","code":"690","iso":"TK"},
{"country":"Tonga","code":"676","iso":"TO"},
{"country":"Trinidad and Tobago","code":"1-868","iso":"TT"},
{"country":"Tunisia","code":"216","iso":"TN"},
{"country":"Turkey","code":"90","iso":"TR"},
{"country":"Turkmenistan","code":"993","iso":"TM"},
{"country":"Turks and Caicos Islands","code":"1-649","iso":"TC"},
{"country":"Tuvalu","code":"688","iso":"TV"},
{"country":"U.S. Virgin Islands","code":"1-340","iso":"VI"},
{"country":"Uganda","code":"256","iso":"UG"},
{"country":"Ukraine","code":"380","iso":"UA"},
{"country":"United Arab Emirates","code":"971","iso":"AE"},
{"country":"United Kingdom","code":"44","iso":"GB"},
{"country":"United States","code":"1","iso":"US"},
{"country":"Uruguay","code":"598","iso":"UY"},
{"country":"Uzbekistan","code":"998","iso":"UZ"},
{"country":"Vanuatu","code":"678","iso":"VU"},
{"country":"Vatican","code":"379","iso":"VA"},
{"country":"Venezuela","code":"58","iso":"VE"},
{"country":"Vietnam","code":"84","iso":"VN"},
{"country":"Wallis and Futuna","code":"681","iso":"WF"},
{"country":"Western Sahara","code":"212","iso":"EH"},
{"country":"Yemen","code":"967","iso":"YE"},
{"country":"Zambia","code":"260","iso":"ZM"},
{"country":"Zimbabwe","code":"263","iso":"ZW"}];
  late String _password;
  bool isObscureConfirm = true;
  final List<String> countryCodeItems = [
    '+91',
    '+98',
    '+99',
  ];

  final List<String> genderList = [
    'Male ',
    'Female',
    'Prefer not to share',
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeySignUp,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12))),
        child:  ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.center,
              child: _image == null
                  ? Stack(
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/man.png')),
                    ),
                  ),
                  InkWell(
                    onTap: () {

                      getImage();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 70, left: 60),
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                          color: Color(0xFfDD2E44),
                          shape: BoxShape.circle),
                      child: const Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          )),
                    ),
                  )
                ],
              )
                  : Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover, image: FileImage(_image!)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Upload your happy pic*',
                style: TextStyle(color: AppTheme.dashboardTeal, fontSize: 15),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: const [
                  Text(
                    'Hobbies top 3* ',
                    style:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  Expanded(
                    child: Text(
                      '(3 are mandatory and 2 optional) hjgjrj',
                      style: TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 7),
              child: TextField(
                controller: hobbiesController,
                focusNode: focusNode,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    hobbiesVisibility = false;
                  });
                },
                onTap: () {
                  setState(() {
                    hobbiesVisibility = true;
                  });
                },
                onChanged: (value) {
                  _runFilter(value);
                },
                decoration: const InputDecoration(
                    labelText: 'Search Hobbies',
                    suffixIcon: Icon(
                      Icons.search,
                      color: AppTheme.navigationRed,
                    )),
              ),
            ),
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    Visibility(
                      visible: tabAddedList.isNotEmpty ? true : false,
                      child: SizedBox(
                        height: 42,
                        child: ListView.builder(
                            padding: const EdgeInsets.only(left: 8),
                            itemCount: tabAddedList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int pos) {
                              return Row(
                                children: [
                                  Container(
                                    height: 42,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff4DBD33),
                                        borderRadius:
                                        BorderRadius.circular(30)),
                                    child: Row(
                                      children: [
                                        Text(
                                          tabAddedList[pos],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        InkWell(
                                          onTap: () {
                                            tabAddedList
                                                .remove(tabAddedList[pos]);
                                            setState(() {});
                                          },
                                          child: const Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              );
                            }),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Visibility(
                      visible: tabAddedListOrange.isNotEmpty ? true : false,
                      child: SizedBox(
                        height: 42,
                        child: ListView.builder(
                            padding: const EdgeInsets.only(left: 8),
                            itemCount: tabAddedListOrange.length,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int pos) {
                              return Row(
                                children: [
                                  Container(
                                    height: 42,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: AppTheme.gradient4,
                                        borderRadius:
                                        BorderRadius.circular(30)),
                                    child: Row(
                                      children: [
                                        Text(
                                          tabAddedListOrange[pos],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        InkWell(
                                          onTap: () {
                                            tabAddedListOrange.remove(
                                                tabAddedListOrange[pos]);
                                            setState(() {});
                                          },
                                          child: const Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              );
                            }),
                      ),
                    ),

                   // const SizedBox(height: 5),
/*
                    TextFieldSimple(
                      controller: professionController,
                      labeltext: 'Profession',
                      validator: null,
                      disable: true,
                    ),*/

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

                    Row(
                      children: [
                        InkWell(
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
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
                                  labelText: 'Search',
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

                              // optional. Shows phone code before the country name.
                              onSelect: (Country country) {
                                if (kDebugMode) {
                                  print(
                                      'Select country: ${country.displayName}');
                                }
                                setState(() {
                                  selectedCode = country.phoneCode;
                                });
                              },
                            );





                          },
                          child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 1),

                                  borderRadius: BorderRadius.circular(5)
                              ),
                              transform:
                              Matrix4.translationValues(0.0, -12.0, 0.0),
                              margin: const EdgeInsets.only(left: 8),
                              width: 90,
                              height: 55,
                              child:
                              Row(
                                children: [
                                  Text(selectedCode!=''?'+'+selectedCode.toString():'',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),

                                  const Spacer(),

                                  const Icon(
                                      Icons.keyboard_arrow_down_outlined
                                  ),
                                  const SizedBox(width: 10)










                                ],
                              )



                            /*DropdownButtonFormField2(
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                isExpanded: true,
                                hint: const Text(
                                  '+324',
                                  style: TextStyle(fontSize: 14),
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 30,
                                buttonHeight: 58,
                                buttonPadding:
                                    const EdgeInsets.only(left: 20, right: 10),
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                items: countryCodeItems
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                *//* validator: (value) {
                                  if (value == null) {
                                    return 'Please select country code';
                                  }
                                },*//*
                                onChanged: (value) {
                                  //Do something when changing the item if you want.
                                },
                                onSaved: (value) {
                                  selectedValueCountryCode = value.toString();
                                },
                              ),*/
                          ),
                        ),
                        Expanded(
                          child: TextFieldPhone(
                            controller: mobileController,
                            labeltext: 'Mobile Number',
                            suffixIc: false,
                          ),
                        )
                      ],
                    ),

                    TextFieldSimple(
                      controller: emailController,
                      labeltext: 'Email*',
                      validator: emailValidator,
                      disable: true,
                    ),

                    const SizedBox(height: 5),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        isExpanded: true,
                        hint: const Text(
                          'Select Gender',
                          style: TextStyle(fontSize: 14),
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                        buttonHeight: 60,
                        buttonPadding:
                        const EdgeInsets.only(left: 20, right: 10),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        items: genderList
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select gender';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          //Do something when changing the item if you want.
                        },
                        onSaved: (value) {
                          selectedGender = value.toString();
                        },
                      ),
                    ),
                    const SizedBox(height: 5),

/*

                      TextFieldPass(
                        controller: passwordControllerSignUp,
                        labeltext: 'Password*',

                        validator: checkPasswordValidator,
                        isBoscure: isObscurePasswordS,
                        onIconTap: () {
                          if (isObscurePasswordS) {
                            isObscurePasswordS = false;
                          } else {
                            isObscurePasswordS = true;
                          }

                          setState(() {});
                        },
                      ),
*/

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: passwordControllerSignUp,
                          obscureText: isObscurePasswordS,
                          onChanged: (value) {
                            _checkPassword(value);
                          },
                          validator: checkPasswordValidator,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.fromLTRB(18.0, 20.0, 10.0, 19.0),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  if (isObscurePasswordS) {
                                    isObscurePasswordS = false;
                                  } else {
                                    isObscurePasswordS = true;
                                  }

                                  setState(() {});
                                },
                                child: isObscurePasswordS
                                    ? const Icon(
                                  Icons.visibility_off,
                                  color: AppTheme.icColor,
                                )
                                    : const Icon(Icons.remove_red_eye,
                                    color: AppTheme.icColor),
                              ),
                              labelText: 'Password*',
                              labelStyle: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(5)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.green, width: 2),
                                  borderRadius: BorderRadius.circular(5.0)))),
                    ),

                    passwordControllerSignUp.text.isNotEmpty
                        ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 7),
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

                    passwordControllerSignUp.text.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        _displayText,
                        style: const TextStyle(fontSize: 14),
                      ),
                    )
                        : Container(),

                    const SizedBox(height: 5),

                    TextFieldPass(
                      controller: confirmPasswordController,
                      labeltext: 'Confirm Password*',
                      onChanged: () {},
                      validator: (val) {
                        if (val!.isEmpty) return 'Cannot be left empty';
                        if (val != passwordControllerSignUp.text) {
                          return 'Password and Confirm Password do not match';
                        }
                        return null;
                      },
                      isBoscure: isObscureConfirm,
                      onIconTap: () {
                        if (isObscureConfirm) {
                          isObscureConfirm = false;
                        } else {
                          isObscureConfirm = true;
                        }

                        setState(() {});
                      },
                    ),

                    // const SizedBox(height: 7),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {

                                  FocusScope.of(context).requestFocus(FocusNode());
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
                                        selectedCountry = country.name;
                                      });
                                    },
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.black45, width: 1)),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          selectedCountry,
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black87,
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                  ),
                                ),
                              )),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 1,
                            child: TextFieldWithHint(
                              controller: stateControllerController,
                              labeltext: 'State*',
                              suffixIc: false,
                              validator: null,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),

                     Padding(
                       padding: const EdgeInsets.only(left: 10),
                       child: Text(
                        'Date of birth*',
                        style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500),
                    ),
                     ),
                    const SizedBox(height: 7),
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey, width: 1),
                            borderRadius:
                            BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(

                                dobDate==null?
                                'Select':
                                dobDate!,
                                style: const TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                                maxLines: 2,
                              ),
                            ),

                            SizedBox(width: 5),

                            Icon(Icons.calendar_month,color: AppTheme.gradient1)













                          ],
                        )
                      ),
                    ),

                    SizedBox(height: 10),

                     Padding(
                       padding: const EdgeInsets.only(left: 10),
                       child: Text(
                        'Marriage Anniversary',
                        style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                    ),
                     ),
                    const SizedBox(height: 7),
                    InkWell(
                      onTap: () {
                        _selectMarriageDate(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey, width: 1),
                            borderRadius:
                            BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                marriageDate==null?
                                'Select':
                                marriageDate.toString(),
                                style: const TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                                maxLines: 1,
                              ),
                            ),

                            SizedBox(width: 5),

                            Icon(Icons.calendar_month,color: AppTheme.gradient1)
                          ],
                        ),
                      ),
                    ),


                    const SizedBox(height: 20),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: Checkbox(
                              value: ugcConditionsAgreed,
                              onChanged: (newValue) =>
                                  setState(() => ugcConditionsAgreed = newValue!),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black87,
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'By signing up, you agree to our '),
                                  TextSpan(text: 'Terms & conditions', style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),
                                    recognizer:  TapGestureRecognizer()..onTap = () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsScreen2()));


                                    },



                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(text: 'Privacy Policy', style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),
                                    recognizer:  TapGestureRecognizer()..onTap = () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyScreen()));

                                    },

                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    const SizedBox(height: 15),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 48,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppTheme.themeColor),
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)),
                                      side: BorderSide(
                                          color: AppTheme.themeColor)))),
                          onPressed: ()async

                          {


                          /*  permission = await Geolocator.checkPermission();
                            if (permission == LocationPermission.denied) {
                              permission = await Geolocator.requestPermission();
                              if (permission == LocationPermission.denied)
                            */


                            LocationPermission permission = await Geolocator.checkPermission();
                             bool? serviceEnabled;
                             serviceEnabled = await Geolocator.isLocationServiceEnabled();

                             if(permission==LocationPermission.denied || !serviceEnabled)
                               {
                                 print('Callback recived');
                               //  _determinePosition();

                                 permission = await Geolocator.requestPermission();
                                _determinePosition();

                               }
                             else
                               {
                                 APIDialog.showAlertDialog(context,'Fetching location...');
                                 Position position=await _determinePosition();
                                 print(position.latitude.toString());
                                 print(position.longitude.toString());
                                 List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
                                 print(placemarks[0].country);
                                 print(placemarks[0].administrativeArea);
                                 print(placemarks[0].isoCountryCode);
                                 stateName=placemarks[0].administrativeArea.toString();
                                 countryName=placemarks[0].country.toString();
                                 countryISOCode=placemarks[0].isoCountryCode.toString();
                                 print('All Done');
                                 fetchStateName(position.latitude, position.longitude);

                               }
                          },
                          child: const Text("Next",
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600))),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
                Visibility(
                    visible: hobbiesVisibility,
                    child: Container(
                      height: 250,
                      padding: const EdgeInsets.only(left: 10),
                      color: const Color(0xFFF8E4FF),
                      child: hobbiesSearchAPIList.length != 0 ||
                          hobbiesController.text.isNotEmpty
                          ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: hobbiesSearchAPIList.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              hobbiesController.clear();
                              hobbiesVisibility = false;
                              FocusScope.of(context)
                                  .requestFocus(FocusNode());

                              if (tabAddedList.length < 3) {
                                if (!tabAddedList.contains(
                                    hobbiesSearchAPIList[index]
                                    ['name'])) {
                                  tabAddedList.add(
                                      hobbiesSearchAPIList[index]
                                      ['name']);
                                }
                              } else if (tabAddedListOrange.length <
                                  2) {
                                if (!tabAddedListOrange.contains(
                                    hobbiesSearchAPIList[index]
                                    ['name']) && !tabAddedList.contains(
                                    hobbiesSearchAPIList[index]
                                    ['name'])) {
                                  tabAddedListOrange.add(
                                      hobbiesSearchAPIList[index]
                                      ['name']);
                                }
                              }

                              setState(() {});

                              // List Adding Logic
                            },
                            child: Container(
                                color: const Color(0xFFF8E4FF),
                                /*key: ValueKey(
                                                          _foundUsers[index]),*/
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12, bottom: 12),
                                      child: Text(
                                        hobbiesSearchAPIList[index]
                                        ['name'],
                                        style: const TextStyle(
                                            fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 1,
                                      color: Colors.white,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                    )
                                  ],
                                )),
                          ))
                          : Container(
                          height: 250,
                          color: const Color(0xFFF8E4FF),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: hobbiesAPIList.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  hobbiesController.clear();
                                  hobbiesVisibility = false;

                                  if (tabAddedList.length < 3) {
                                    if (!tabAddedList.contains(
                                        hobbiesAPIList[index]
                                        ['name'])) {
                                      tabAddedList.add(
                                          hobbiesAPIList[index]
                                          ['name']);
                                    }
                                  } else if (tabAddedListOrange
                                      .length <
                                      2) {
                                    if (!tabAddedListOrange.contains(
                                        hobbiesAPIList[index]
                                        ['name']) && !tabAddedList.contains(
                                        hobbiesAPIList[index]
                                        ['name'])) {
                                      tabAddedListOrange.add(
                                          hobbiesAPIList[index]
                                          ['name']);
                                    }
                                  }

                                  /* if (!tabAddedList.contains(
                                                hobbiesAPIList[index]
                                                    ['name'])) {
                                              tabAddedList.add(
                                                  hobbiesAPIList[index]
                                                      ['name']);
                                            }
*/
                                  setState(() {});
                                },
                                child: Container(
                                    color: const Color(0xFFF8E4FF),
                                    key: ValueKey(
                                        hobbiesAPIList[index]
                                        ['name']),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              top: 12,
                                              bottom: 12),
                                          child: Text(
                                            hobbiesAPIList[index]
                                            ['name'],
                                            style: const TextStyle(
                                                fontSize: 16),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          height: 1,
                                          color: Colors.white,
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width,
                                        )
                                      ],
                                    )),
                              ))),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 25);

    _image = File(pickedFile!.path);
    if(Platform.isIOS)
    {
      _image= await FlutterExifRotation.rotateImage(path: _image!.path);
    }
    setState(() {
    });
  }

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = hobbiesAPIList;
    } else {
      results = hobbiesAPIList
          .where((hobbie) => hobbie['name']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      hobbiesSearchAPIList = results;
    });
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

  void printData(){
    print('Data is not found');
    print('The Data needs to be accesed from a different device');

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

  String? checkPasswordValidator(String? value) {
    if (value!.length < 6) {
      return 'Password should have atleast 6 digit';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().subtract(Duration(days: 1)),
        firstDate: DateTime(1950, 8),
        lastDate: DateTime.now().subtract(Duration(days: 1)));
    if (picked != null) {
      dobDate= _parseServerDate(picked);
      setState(() {
      });
    }
  }

  Future<void> _selectMarriageDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().subtract(Duration(days: 1)),
        firstDate: DateTime(1950, 8),
        lastDate: DateTime.now().subtract(Duration(days: 1)));
    if (picked != null /*&& picked != marriageDate*/) {




     marriageDate= _parseServerDate(picked);
      setState(() {
      });
    }
  }

  void _submitHandlerSignUp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_formKeySignUp.currentState!.validate()) {
      return;
    }
    _formKeySignUp.currentState!.save();

    _fetchSignUpData();
  }

  _fetchSignUpData() {
    if (tabAddedList.length < 3) {
      Toast.show('Please select atleast 3 hobbies',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
    } else if (_image == null) {
      Toast.show('Please upload a profile pic',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
    } else if (selectedCountry == 'Select Country') {
      Toast.show('Please select a country',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.blue);
    }
    else if(!ugcConditionsAgreed)
      {
        Toast.show('Please agree to our terms & conditions',
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
      }
    else if(dobDate==null)
      {
        Toast.show('Please select Date of Birth ',
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
      }
    else if(stateControllerController.text=='')
      {
        Toast.show('Please enter State name',
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.blue);
      }

    else {
      //prepare data
      _callSignUpAPI(tabAddedList);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFCMToken();
    initPlatformState();
    fetchCurrentLocation();
  //  fetchStateName(58258.25, 42424.24);

    Future.delayed(const Duration(milliseconds: 500), () {
      fetchHobbies(context);
    });
  }
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
   /* serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }*/

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  fetchCountryCode()async{
    print('Sim Country Code');
    print(FlutterSimCountryCode.simCountryCode.toString());
   // String? locale = await Devicelocale.currentLocale;
   /* Locale ? locale = Localizations.localeOf(context);
    print(locale);*/
    await CountryCodes.init(/*Localizations.localeOf(context)*/); // Optionally, you may provide a `Locale` to get countrie's localizadName
    final CountryDetails details = CountryCodes.detailsForLocale();
    print(details.dialCode!); // Displays en
    selectedCode=details.dialCode!;
    setState(() {

    });
  }
/*  static Locale parse(String localeIdentifier) {
    var parser = LocaleParser(localeIdentifier);
    var locale = parser.toLocale();
 *//*   if (locale == null) {
      throw FormatException('Locale "$localeIdentifier": '
          '${parser.problems.join("; ")}.');
    }*//*
    return locale;
  }*/
  fetchHobbies(BuildContext context) async {

    APIDialog.showAlertDialog(context, 'Fetching hobbies...');
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.get('hobbiesList', context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());
    setState(() {
      hobbiesAPIList = responseJson['show_hobbies'];
    });
  }

  _callSignUpAPI(List<String> hobbiesList) async {
   // APIDialog.showAlertDialog(context, 'Creating user...');
    var formData = FormData.fromMap({
      'first_name': nameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'country': selectedCountry,
      'state': stateControllerController.text,
      'gender': selectedGender,
      'date_of_birth': dobDate,
      'hobbies[]': hobbiesList,
      'password': passwordControllerSignUp.text,
      'password_confirmation': confirmPasswordController.text,
      'device_id':fcmToken.toString(),
      'geo_state':stateName,
      'geo_country':countryName,
      'geo_state_code':stateName,
      'geo_country_cdoe':countryISOCode,
      'avatar': _image == null
          ? null
          : await MultipartFile.fromFile(_image!.path,
              filename: "profile_pic.jpg"),
    });

    print(formData.fields);

    validateEmail(formData);
    //authBloc.addNewUser(context, formData);
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


  fetchFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    fcmToken=token!;
    print('FCM Token');
    print(token);
  }

  String _parseServerDate(DateTime dateTime) {
    final DateFormat dayFormatter = DateFormat.yMMMMd();
    String dayAsString = dayFormatter.format(dateTime);
    return dayAsString;
  }


  fetchCurrentLocation() async {
    Position position=await _determinePosition();
    print(position.latitude.toString());
    print(position.longitude.toString());
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
   /* print(placemarks[0].country);
    print(placemarks[0].administrativeArea);
    print(placemarks[0].isoCountryCode);
*/
   /* stateName=placemarks[0].administrativeArea.toString();*/
    countryName=placemarks[0].country.toString();
    countryISOCode=placemarks[0].isoCountryCode.toString();

    print(stateName);
    print(countryName);
    print(countryISOCode);


  }
  validateEmail(var formData22) async {
    APIDialog.showAlertDialog(context, 'Checking email...');
    var formData = {'email': emailController.text};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('emailCheck', formData, context);
    Navigator.pop(context);
    var responseJson = jsonDecode(response.body.toString());
     if(responseJson['message']=='Available')
       {
         Toast.show(responseJson['message'],
             duration: Toast.lengthLong,
             gravity: Toast.bottom,
             backgroundColor: Colors.green);

         Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsScreen(formData22)));
       }
     else
       {
         Toast.show(responseJson['message'],
             duration: Toast.lengthLong,
             gravity: Toast.bottom,
             backgroundColor: Colors.red);
       }
  }

  fetchStateName(double lat,double longg) async {
    ApiBaseHelper helper = ApiBaseHelper();
    print('THE URL IS '+AppConstant.googleMapBaseURL+'latlng='+lat.toString()+','+longg.toString()+'&key='+AppConstant.googleMapAPIKey);
    var response = await helper.mapGetAPI(AppConstant.googleMapBaseURL+'latlng='+lat.toString()+','+longg.toString()+'&key='+AppConstant.googleMapAPIKey,context);
    print(response);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);
    stateName=responseJson['results'][0]['address_components'][4]['long_name'];
    print('FULL STATE NAME IS AS FOLLOWS '+stateName);
    Navigator.pop(context);
    _submitHandlerSignUp(context);
    setState(() {});
  }


  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterSimCountryCode.simCountryCode;
    } on PlatformException {
      platformVersion = 'Failed to get sim country code.';
    }

    if (!mounted) return;

    print('SimM');
    print(_platformVersion);
    _platformVersion = platformVersion;

    for(int i=0;i<telephoneList.length;i++)
      {
        if(_platformVersion==telephoneList[i]['iso'])
          {
            selectedCode=telephoneList[i]['code'];
            break;
          }
      }

    print(selectedCode.toString());

    setState(() {

    });


  }


  _fetchCurrentTelephoneCode(){




  }


}
