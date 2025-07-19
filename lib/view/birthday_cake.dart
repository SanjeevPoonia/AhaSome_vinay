import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';

class BirthdayCake extends StatefulWidget {
  BirthdayState createState() => BirthdayState();
}

class BirthdayState extends State<BirthdayCake> {
  Uint8List? _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  final picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 30),
          Screenshot(
              child: Container(
                width: double.infinity,
                //color: Colors.greenAccent,
                height: 350,
                child: Stack(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        print('triggered');
                      },
                      child: InteractiveViewer(
                          boundaryMargin: EdgeInsets.all(100),
                          minScale: 0.5,
                          maxScale: 2,
                          child: _image!=null?Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: FileImage(_image!),
                              ),
                            ),
                          ):Container()),
                    ),
                    IgnorePointer(
                      ignoring: true,
                      child:
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/frame.png'),
                          ),
                        ),
                      )

                    )
                  ],
                ),
              ),
              controller: screenshotController),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              getImage();
            },
            child: Container(
              width: 100,
              height: 50,
              color: Colors.blue,
              child: Center(
                child: Text('Pick Image',style: TextStyle(
                  color: Colors.white
                ),),
              ),
            ),
          ),

          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              screenshotController
                  .capture(delay: Duration(milliseconds: 10))
                  .then((capturedImage) async {
                ShowCapturedWidget(context, capturedImage!);
              }).catchError((onError) {
                print(onError);
              });
            },
            child: Container(
              width: 100,
              height: 50,
              color: Colors.green,
              child: Center(
                child: Text('Export Image',style: TextStyle(
                    color: Colors.white
                ),),
              ),
            ),
          )


        ],
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 25);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }
}
