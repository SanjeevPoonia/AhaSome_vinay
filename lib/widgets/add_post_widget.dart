import 'dart:convert';
import 'dart:io';

import 'package:aha_project_files/network/api_dialog.dart';
import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/widgets/loader.dart';
import 'package:aha_project_files/widgets/player_widget.dart';
import 'package:aha_project_files/widgets/small_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../models/app_modal.dart';
import '../network/api_helper.dart';
import '../network/bloc/dashboard_bloc.dart';
class AddPostWidget extends StatefulWidget {
  final String postType;
  final int? groupId;

  AddPostWidget(this.postType, this.groupId);

  @override
  PostState createState() => PostState();
}

class PostState extends State<AddPostWidget> {
  var addPostController = TextEditingController();
  File? _selectedFile;
  bool isLoading=false;
  bool isGifSelected = false;
  String selectedGifName = '';
  double uploadingProgress=0.0;
  DateTime currentDate = DateTime.now();
  final picker = ImagePicker();
  List<dynamic> postListAsString = [];
  List<dynamic> postList = [];
  List<dynamic> gifList = [];
  String? selectedPostType;
  bool isImage = true;
  VideoPlayerController? _controller;
  int? selectedID;
  final dashboardBloc = Modular.get<DashboardCubit>();
  final authBloc = Modular.get<AuthCubit>();
  VideoPlayerOptions videoPlayerOptions =
      VideoPlayerOptions(mixWithOthers: true);
  bool isCamera = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              body: BlocBuilder(
                  bloc: dashboardBloc,
                  builder: (context, state) {
                    return Column(
                      children: [
                        Card(
                          margin: EdgeInsets.zero,
                          elevation: 5,
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    if(WidgetsBinding.instance.window.viewInsets.bottom > 0.0)
                                    {
                                      FocusManager.instance.primaryFocus?.unfocus();

                                    }
                                    else
                                    {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Icon(Icons.arrow_back_rounded),
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Create post',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    _pickPostData();
                                  },
                                  child: Container(
                                    width: 70,
                                    margin: const EdgeInsets.only(right: 10),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF2C9CD3),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Center(
                                      child: isLoading
                                          ? CircularPercentIndicator(
                                        radius: 17,
                                        lineWidth: 3.0,
                                        percent: uploadingProgress/100,
                                        center: Text(
                                          uploadingProgress.round().toString()+" %",
                                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w500),
                                        ),
                                        progressColor: Colors.green,
                                      )
                                          : const Text(
                                              'POST',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17),
                                            ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 15),
                            BlocBuilder(
                                bloc: authBloc,
                                builder: (context, state) {
                                  return CircleAvatar(
                                    radius: 24.0,
                                    backgroundImage:
                                        NetworkImage(authBloc.state.profileImage),
                                  );
                                }),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder(
                                    bloc: authBloc,
                                    builder: (context, state) {
                                      return Text(
                                        '${authBloc.state.userModel!.firstName} ${authBloc.state.userModel!.lastName}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      );
                                    }),
                                const SizedBox(height: 5),
                                Text(
                                  _parseServerDate(currentDate.toString()),
                                  style:
                                      TextStyle(color: Colors.grey, fontSize: 11),
                                ),
                              ],
                            )),
                            const Icon(Icons.more_vert, color: Colors.white)
                          ],
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              controller: addPostController,
                              textCapitalization:
                              TextCapitalization
                                  .sentences,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              maxLength: 150,
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 10.0),
                                hintText: 'Post something',
                                hintStyle: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.grey,
                                ),
                              )),
                        ),
                        isImage
                            ? _selectedFile != null
                                ? Expanded(child: Image.file(_selectedFile!))
                                : Expanded(child: Container())
                            : isGifSelected
                                ? Expanded(child: Image.network(selectedGifName))
                                : _controller != null
                                    ? Expanded(
                                        child: Stack(
                                        children: [
                                          VideoPlayer(_controller!),
                                          Controls(
                                            controller: _controller!,
                                            iconSize: 70,
                                          )
                                        ],
                                      ))
                                    : Expanded(child: Container()),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 1,
                          color: Colors.grey,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              selectedPostType != null
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      width: 150,
                                      height: 40,
                                      child: DropdownButtonFormField2(
                                        decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none),
                                        isExpanded: true,
                                        hint: const Text(
                                          'Post Type',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          color: Colors.black,
                                        ),
                                        iconSize: 30,
                                        buttonHeight: 60,
                                        buttonPadding: const EdgeInsets.only(
                                            left: 20, right: 10),
                                        dropdownDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        items: postListAsString
                                            .map((item) =>
                                                DropdownMenuItem<String>(
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
                                            return 'Please select Post Type';
                                          }
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            selectedPostType = value.toString();
                                          });
                                        },
                                        onSaved: (value) {},
                                        value: selectedPostType,
                                      ),
                                    )
                                  : Container(
                                      width: 150,
                                      child: Center(child: Text('Loading...')),
                                    ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  isCamera = false;
                                  getImage();
                                },
                                child: const Icon(
                                  Icons.image,
                                  color: AppTheme.gradient2,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                  onTap: () {
                                    isCamera = true;
                                    getImageFromCamera();
                                  },
                                  child: const Icon(Icons.camera_enhance,
                                      color: AppTheme.gradient1, size: 30)),
                              SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  fetchGIFs();
                                },
                                child: const Icon(
                                  Icons.gif,
                                  color: AppTheme.gradient2,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  showCustomDialog(context);

                                  // getVideo();
                                },
                                child: const Icon(Icons.videocam,
                                    color: AppTheme.gradient2, size: 30),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }))),
    );
  }

  Future getImage() async {
    isImage = true;
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (pickedFile != null) {
      _selectedFile = File(pickedFile.path);
      isGifSelected = false;
      if(Platform.isIOS)
      {
        _selectedFile= await FlutterExifRotation.rotateImage(path: _selectedFile!.path);
      }
      //userImages.add(_image!);
      setState(() {});
    }
  }

  Future getImageFromCamera() async {
    isImage = true;
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 25);
    if (pickedFile != null) {
      _selectedFile = File(pickedFile.path);
      isGifSelected = false;
      if(Platform.isIOS)
        {
          _selectedFile= await FlutterExifRotation.rotateImage(path: _selectedFile!.path);
          setState(() {});
        }
      else
        {
          setState(() {});
        }
    }
  }

  _pickPostData() async {
    if (selectedPostType == null) {
      Toast.show('Please select a Post category',
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: Colors.blueAccent);
    } else if (_selectedFile != null) {
      int fileSize = _selectedFile!.lengthSync();
      // size in bytes

      if (fileSize > 16000000) {
        showFileDialog();
      } else {
        handleAPI();
      }
    } else {
      handleAPI();
    }
  }

  showFileDialog() {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Limit exceeded",
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.grey,
        ),
      ),
      content: Text(
        "File cannot be greater then 16mb",
        style: TextStyle(
          fontSize: 12.0,
          color: AppTheme.gradient1,
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  handleAPI() async {
    {


       if(addPostController.text == '' && _selectedFile==null && isGifSelected==false)
         {

           Toast.show('Post cannot be empty',
               duration: Toast.lengthShort,
               gravity: Toast.bottom,
               backgroundColor: Colors.blue);


         }

    else  {
         for (int i = 0; i < postList.length; i++) {
           if (postList[i]['name'] == selectedPostType) {
             selectedID = postList[i]['id'];
             break;
           }
         }
         var requestModel;

         // GIF

         if (isGifSelected) {
           if (widget.postType == 'Group') {
             requestModel = FormData.fromMap({
               'body': addPostController.text,
               'category_id': selectedID,
               'auth_key': AppModel.authKey,
               'gif': selectedGifName,
               'group_id': widget.groupId
             });
           } else {
             requestModel = FormData.fromMap({
               'body': addPostController.text,
               'category_id': selectedID,
               'gif': selectedGifName,
               'auth_key': AppModel.authKey,
             });
           }
         }


         // normal files


         else {
           if (_selectedFile != null) {
             // filename: "post.gif"

             String? fileType = lookupMimeType(_selectedFile!.path);
             print(fileType);
             if (fileType!.endsWith('gif')) {
               if (widget.postType == 'Group') {
                 requestModel = FormData.fromMap({
                   'body': addPostController.text,
                   'category_id': selectedID,
                   'auth_key': AppModel.authKey,
                   'group_id': widget.groupId,
                   'image': await MultipartFile.fromFile(_selectedFile!.path),
                 });
               } else {
                 requestModel = FormData.fromMap({
                   'body': addPostController.text,
                   'category_id': selectedID,
                   'auth_key': AppModel.authKey,
                   'image': await MultipartFile.fromFile(_selectedFile!.path),
                 });
               }
             } else if (fileType.startsWith('image/')) {
               if (isCamera) {
                 if (widget.postType == 'Group') {
                   requestModel = FormData.fromMap({
                     'body': addPostController.text,
                     'category_id': selectedID,
                     'auth_key': AppModel.authKey,
                     'group_id': widget.groupId,
                     'image_capture': await MultipartFile.fromFile(
                       _selectedFile!.path,
                     ),
                   });
                 } else {
                   requestModel = FormData.fromMap({
                     'body': addPostController.text,
                     'category_id': selectedID,
                     'auth_key': AppModel.authKey,
                     'image_capture': await MultipartFile.fromFile(
                       _selectedFile!.path,
                     ),
                   });
                 }
               } else {
                 if (widget.postType == 'Group') {
                   requestModel = FormData.fromMap({
                     'body': addPostController.text,
                     'category_id': selectedID,
                     'auth_key': AppModel.authKey,
                     'group_id': widget.groupId,
                     'image': await MultipartFile.fromFile(
                       _selectedFile!.path,
                     ),
                   });
                 } else {
                   requestModel = FormData.fromMap({
                     'body': addPostController.text,
                     'category_id': selectedID,
                     'auth_key': AppModel.authKey,
                     'image': await MultipartFile.fromFile(
                       _selectedFile!.path,
                     ),
                   });
                 }
               }
             } else if (fileType.startsWith('video/')) {
               if (widget.postType == 'Group') {
                 requestModel = FormData.fromMap({
                   'body': addPostController.text,
                   'category_id': selectedID,
                   'auth_key': AppModel.authKey,
                   'group_id': widget.groupId,
                   'video_recording': await MultipartFile.fromFile(
                     _selectedFile!.path,
                   ),
                 });
               } else {
                 requestModel = FormData.fromMap({
                   'body': addPostController.text,
                   'category_id': selectedID,
                   'auth_key': AppModel.authKey,
                   'video_recording': await MultipartFile.fromFile(
                     _selectedFile!.path,
                   ),
                 });
               }
             }
           }

           // for groups


           else {
             if (widget.postType == 'Group') {
               requestModel = FormData.fromMap({
                 'body': addPostController.text,
                 'category_id': selectedID,
                 'auth_key': AppModel.authKey,
                 'group_id': widget.groupId
               });
             } else {
               requestModel = FormData.fromMap({
                 'body': addPostController.text,
                 'category_id': selectedID,
                 'auth_key': AppModel.authKey,
               });
             }
           }
         }

         print(requestModel.fields.toString());

         addPost(context, requestModel);





       /*  bool apiStatus = await dashboardBloc.addPost(context, requestModel);
         if (apiStatus) {
           updatePostCount();
           Navigator.pop(context, 'animationData');
         }*/
       }


    }
  }
   addPost(BuildContext context, FormData requestModel) async {
    uploadingProgress=0.0;
    setState(() {
      isLoading=true;
    });

    print(AppConstant.appBaseURL + 'userPost');
    try {
      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      final response = await dio.post(AppConstant.appBaseURL + 'userPost',
          data: requestModel,
        onSendProgress: (int sent, int total) {
          print('$sent $total');

          int mul=sent*100;
          uploadingProgress=mul/total;
          print(uploadingProgress.toString()+'% ^^^');
          setState(() {

          });

        },

      );

      AppModel.setNewPost(true);
      print(requestModel.fields);
      var responseBody = response.data;
      setState(() {
        isLoading=false;
      });
      print(responseBody);
      String jsonsDataString = responseBody.toString();
      final jsonData = jsonDecode(jsonsDataString);
      if (jsonData['status'] == 1) {
        updatePostCount();
        Navigator.pop(context, 'animationData');


      } else {

        Toast.show(jsonData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);

      }
    } catch (errorMessage) {

      String message = errorMessage.toString();
      print(message);

    }
  }
  updatePostCount() {
    int? currentCount = dashboardBloc.state.ahaByMe;
    currentCount = currentCount! + 1;
    dashboardBloc.updateAHAByMe(currentCount);
  }

  @override
  void initState() {
    super.initState();
    /*  Future.delayed(const Duration(milliseconds: 500), () {

    });*/
    fetchCategories(context);
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller?.pause();
      _controller?.dispose();
    }
    super.dispose();
  }

  fetchCategories(BuildContext context) async {
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.get('postCategories', context);
    var responseJson = jsonDecode(response.body.toString());
    postList = responseJson['post_categories'];
    //selectedPostType

    if (postListAsString.length != 0) {
      postListAsString.clear();
    }
    for (int i = 0; i < postList.length; i++) {
      postListAsString.add(postList[i]['name']);
    }

    if (postListAsString.length != 0) {
      selectedPostType = postListAsString[0];
    }

    print(selectedPostType.toString() + ' Post Type');

    setState(() {});
  }

  fetchGIFs() async {
    APIDialog.showAlertDialog(context, 'Please wait...');

    for (int i = 0; i < postList.length; i++) {
      if (postList[i]['name'] == selectedPostType) {
        selectedID = postList[i]['id'];
        break;
      }
    }

    var requestModel = {
      'auth_key': AppModel.authKey,
      'category_id': selectedID
    };

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('categoryGif', requestModel, context);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);
    Navigator.pop(context);
    gifList = responseJson['data'];
    setState(() {});
    gifDialog(context);
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppTheme.gradient4),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            getVideo(true);
                          },
                          child: const Text("Camera",
                              style: TextStyle(fontSize: 14))),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppTheme.gradient1),
                          ),
                          onPressed: () {
                            Navigator.pop(context);

                            getVideo(false);
                          },
                          child: const Text("Gallery",
                              style: TextStyle(fontSize: 14))),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  String _parseServerDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    final DateFormat dayFormatter = DateFormat.MMMEd();
    String dayAsString = dayFormatter.format(dateTime);
    return dayAsString;
  }

  Future getVideo(bool isCamera) async {
    isImage = false;
    final pickedFile;
    if (isCamera) {
      pickedFile = await picker.pickVideo(source: ImageSource.camera);
      isGifSelected = false;
    } else {
      pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      isGifSelected = false;
    }

    if (pickedFile != null) {
      // check for file size
      _selectedFile = File(pickedFile!.path);
      _controller = VideoPlayerController.file(_selectedFile!,
          videoPlayerOptions: videoPlayerOptions)
        ..initialize().then((_) {
          //  _controller.play();
          setState(() {});
        });
    }
  }

  void gifDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)), //this right here
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 12),
                          Row(
                            children: [
                              const Text(
                                'Select GIF',
                                style: TextStyle(
                                    color: Color(0XFF606060),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                              const Spacer(),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.close))
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 200,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                                crossAxisCount: 3,
                              ),
                              itemCount: gifList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    updateUI(index);
                                  },
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: gifList[index]['gif_name'],
                                    placeholder: (context, url) => Image.asset(
                                        'assets/picture.png',
                                        width: 20,
                                        height: 20),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),

                                  /* Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            gifList[index]['gif_name']),
                                      ),
                                    ),
                                  ),*/
                                );
                                // Item rendering
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
          });
        });
  }

  updateUI(int index) {
    setState(() {
      isGifSelected = true;
      isImage = false;
      selectedGifName = gifList[index]['gif_name'];
    });
  }
}
