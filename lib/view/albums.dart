import 'dart:typed_data';

import 'package:aha_project_files/network/bloc/auth_bloc.dart';
import 'package:aha_project_files/network/constants.dart';
import 'package:aha_project_files/utils/app_theme.dart';
import 'package:aha_project_files/view/image_display.dart';
import 'package:aha_project_files/widgets/background_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../models/app_modal.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/list_video_widget.dart';
import '../widgets/loader.dart';
import 'full_video_screen.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  AlbumState createState() => AlbumState();
}

class AlbumState extends State<AlbumScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final authBloc = Modular.get<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navigationRed,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                BackgroundWidget(),
                BlocBuilder(
                    bloc: authBloc,
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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

                          const SizedBox(height: 15),

                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              'Album',
                              style: TextStyle(
                                  color: Color(0xFf42BFB7),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // the tab bar with two items
                          SizedBox(
                            height: 50,
                            child: AppBar(
                              backgroundColor: AppTheme.gradient2,
                              bottom: TabBar(
                                unselectedLabelColor: Colors.grey,
                                labelColor: Colors.white,
                                labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Baumans',
                                    fontSize: 16),
                                controller: _tabController,
                                tabs: const [
                                  Tab(
                                    text: 'My Pictures',
                                  ),
                                  Tab(
                                    text: 'My Posts',
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Expanded(
                            child: authBloc.state.isLoading
                                ? Loader()
                                : TabBarView(
                                    controller: _tabController,
                                    children: [
                                      // first tab for user images
                                      authBloc.state.userAlbumList.length == 0
                                          ? const Center(
                                              child: Text('No Images found'),
                                            )
                                          : GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 0,
                                                mainAxisSpacing: 0,
                                                crossAxisCount: 3,
                                              ),
                                              itemCount: authBloc
                                                  .state.userAlbumList.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ImageDisplay(
                                                            image:
                                                                authBloc
                                                                    .state
                                                                    .userAlbumList[
                                                                        index]
                                                                    .user_image!),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: CachedNetworkImageProvider(

                                                                authBloc
                                                                    .state
                                                                    .userAlbumList[
                                                                        index]
                                                                    .user_image!),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                                // Item rendering
                                              },
                                            ),

                                      // second tab for posts images

                                      authBloc.state.postsAlbumList.length == 0
                                          ? const Center(
                                              child: Text('No Images found'),
                                            )
                                          : GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 0,
                                                mainAxisSpacing: 0,
                                                crossAxisCount: 3,
                                              ),
                                              itemCount: authBloc
                                                  .state.postsAlbumList
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                        onTap: () {
                                                           if(authBloc.state.postsAlbumList[index].gif_id
                                                              !=null)
                                                          {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ImageDisplay(
                                                                    image:
                                                                        authBloc
                                                                            .state
                                                                            .postsAlbumList[
                                                                        index]
                                                                            .gif_id.toString()),
                                                              ),
                                                            );
                                                          }


                                                          else if(authBloc.state.postsAlbumList[index].image
                                                              !=null)
                                                            {
                                                              if(authBloc.state.postsAlbumList[index].video_capture_full
                                                                  !=null && authBloc.state.postsAlbumList[index].video_capture_full
                                                                  !="")
                                                                {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => FullVideoScreen(

                                                                          authBloc
                                                                              .state
                                                                              .postsAlbumList[
                                                                          index]
                                                                              .video_capture_full.toString(), authBloc
                                                                          .state
                                                                          .postsAlbumList[
                                                                      index]
                                                                          .image.toString()),
                                                                    ),
                                                                  );

                                                                }
                                                              else
                                                                {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => ImageDisplay(
                                                                          image:
                                                                          authBloc
                                                                              .state
                                                                              .postsAlbumList[
                                                                          index]
                                                                              .image_full.toString()),
                                                                    ),
                                                                  );
                                                                }



                                                            }
                                                          else if(authBloc.state.postsAlbumList[index].image_capture
                                                               !=null)
                                                            {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ImageDisplay(
                                                                      image:
                                                                          authBloc
                                                                              .state
                                                                              .postsAlbumList[
                                                                          index].capture_full
                                                                              .toString()),
                                                                ),
                                                              );
                                                            }



                                                        },
                                                        child:


                                                        authBloc.state.postsAlbumList[index].gif_id!=null?
                                                        Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            image:
                                                            DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: CachedNetworkImageProvider(
                                                                      authBloc
                                                                          .state
                                                                          .postsAlbumList[
                                                                      index]
                                                                          .gif_id!),
                                                            ),
                                                          ),
                                                        ):


                                                        authBloc.state.postsAlbumList[index].image_capture!=null?
                                                        Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            image:
                                                            DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: CachedNetworkImageProvider(
                                                                  authBloc
                                                                      .state
                                                                      .postsAlbumList[
                                                                  index]
                                                                      .image_capture!),
                                                            ),
                                                          ),
                                                        ):






Stack(
  children: [
      Container(
        decoration:
        BoxDecoration(
          image:
          DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
                authBloc
                    .state
                    .postsAlbumList[
                index]
                    .image!),
          ),
        ),
      ),

      authBloc.state.postsAlbumList[index].video_capture_full
          !=null && authBloc.state.postsAlbumList[index].video_capture_full
          !=""?
      Center(child: Icon(Icons.play_arrow,color: Colors.white,size: 40))
      :Container()


  ],
)


                                                );
                                                // Item rendering
                                              },
                                            ),
                                    ],
                                  ),
                          ),

                          /*  Row(
                    children: [

                      SizedBox(width: 15,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 4,
                            shadowColor: Color(0xffFFC3CA),
                            margin: EdgeInsets.zero,
                            color: Color(0xffFFC3CA),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child:  Container(
                              margin: EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [


                                  Row(
                                    children: [
                                      Container(

                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),

                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Image.asset('assets/dummy_album.jpg'),
                                        ),



                                      ),

                                      SizedBox(width: 15,),


                                      Container(

                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),

                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Image.asset('assets/dummy_album.jpg'),
                                        ),



                                      )


                                    ],


                                  ),

                                  SizedBox(height: 15,),

                                  Row(
                                    children: [

                                      Container(

                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),

                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Image.asset('assets/dummy_album.jpg'),
                                        ),



                                      ),
                                    ],
                                  )







                                ],
                              ),

                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Other',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                          ),


                        ],

                      ),
                    ],
                  )*/
                        ],
                      );
                    })
              ],
            )),
      ),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        Utils.logoutUser(context);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _callAPI();
  }

  _callAPI() {
    var requestModel = {'auth_key': AppModel.authKey};
    authBloc.fetchUserAlbums(context, requestModel);
  }
  Future<Uint8List> returnThumbnail(String path) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      quality: 15,
    );
    return uint8list!;
  }
}

