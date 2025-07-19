
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:aha_project_files/widgets/loader.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/app_modal.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/custom_marker_widget.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);
  @override
  State<MapSample> createState() => MapSampleState();
}
class MapSampleState extends State<MapSample> {
  GoogleMapController? mapController;
  bool isLoading=true;
  List<dynamic> mapElements=[];
  List<Marker> markersWidget = [];
  Set<Marker> markers = Set();
  final GlobalKey globalKey = GlobalKey();
  final Completer<GoogleMapController> _controller = Completer();
  List<dynamic> markersList=[];

  static final CameraPosition _kGooglePlex =  CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
  );

  static final CameraPosition myHome = CameraPosition(
    target:LatLng(26.9124, 75.7873),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
        child: Scaffold(
          body:

              isLoading?
                  Center(
                    child: Loader(),
                  ):


          Stack(
           children: [


             GoogleMap(
                 mapType: MapType.terrain,
                 markers: markers,
                 myLocationEnabled: true,
                 initialCameraPosition: _kGooglePlex,
                 onMapCreated:_onMapCreated
             ),

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

           ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToTheLake(double lat,double longs) async {
    CameraPosition myHome = CameraPosition(
      target:LatLng(lat, longs),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(myHome));

    setState(() {});
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        Utils.logoutUser(context);
        break;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController!.setMapStyle('''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''');
    _controller.complete(controller);

  }
  @override
  void initState() {
    super.initState();
    fetchCurrentLocation();
   // _goToTheLake();
    fetchMarkers();
//    fetchLatLong();

  }


  fetchLatLong() async {
    List<Location> locations = await locationFromAddress("Rajasthan");
    print('LAT LONG');
    print(locations[0].longitude);
    print(locations[0].latitude);

  }

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
  fetchCurrentLocation() async {
    Position position=await _determinePosition();
    print(position.latitude.toString());
    print(position.longitude.toString());
    _goToTheLake(position.latitude, position.longitude);

  }

  fetchMarkers() async {
    setState(() {
      isLoading = true;
    });
    var formData = {'auth_key': AppModel.authKey};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('friendsLocation', formData, context);
    var responseJson = jsonDecode(response.body.toString());
    print(responseJson);
    markersList=responseJson['data2'];

    for(int i=0;i<markersList.length;i++)
      {

        if(markersList[i]['title'].toString().isNotEmpty && markersList[i]['title']!=null && markersList[i]['count']!=0 && markersList[i]['title'].toString().length>3)
          {
            List<Location> locations = await locationFromAddress(markersList[i]['title'].toString());
            print('LAT LONG');
            print(locations[0].longitude);
            print(locations[0].latitude);
            mapElements.add({'location':markersList[i]['title'],'lat':locations[0].latitude,'longi':locations[0].longitude,'count':markersList[i]['count']});
          }
      }
   for(int i=0;i<mapElements.length;i++)
     {
       Uint8List markerIcon = await getBytesFromCanvas(mapElements[i]['count']==0?1:mapElements[i]['count'], 60,60);
       markers.add(
         Marker(
           markerId:  MarkerId('circle'+mapElements[i].toString()),
           icon: BitmapDescriptor.fromBytes(markerIcon),
           position:  LatLng(mapElements[i]['lat'],mapElements[i]['longi']),
         ),
       );
     }

    isLoading = false;

    setState(() {});

    print('NEW MAP FOUND');
    print(mapElements.toString());




   // isLoading=false;

   // _goToTheLake();
  }

/*  addMarkers() async {
    for(int i=0;i<markersList.length;i++)
      {
        if(markersList[i]['value']!=0)
          {
            print('Item Found');
            markers.add(
              Marker(
                  markerId:  MarkerId('markerId'+i.toString()),
                  icon: await MarkerIcon.widgetToIcon(globalKey),
              position:  LatLng(26.7969391, 83.3776302),
            ),
    );

          }
      }
    setState(() {});
  }*/

  Future<Uint8List> getBytesFromCanvas(int customNum, int width, int height) async  {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.limeAccent;
    final Radius radius = Radius.circular(width/2);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(),  height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: customNum.toString(), // your custom number here
      style: TextStyle(fontSize: 30.0, color: Colors.black),
    );

    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * .5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }
}