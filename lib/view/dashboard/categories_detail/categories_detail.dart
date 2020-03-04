import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/Game.dart';
import 'package:gamming_community/view/dashboard/categories_detail/add_room.dart';
import 'package:gamming_community/view/room/create_room.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:video_player/video_player.dart';

GlobalKey _globalKey = GlobalKey();

class CategoriesDetail extends StatefulWidget {
  final String itemTag;
  final Game gameDetail;
  CategoriesDetail({this.itemTag, this.gameDetail});
  @override
  _CategoriesDetailState createState() => _CategoriesDetailState();
}

class _CategoriesDetailState extends State<CategoriesDetail>
    with TickerProviderStateMixin {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  ScrollController _scrollController;
  TabController tabController;
  bool isShowControll = false;
  bool hideButton = true;
  bool titleExpanded = false;
  bool displaytoAppbar = true;
  bool showControl = false;
  bool hideCreateButton = false;
  Config config = Config();
  GraphQLQuery query = GraphQLQuery();
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    _controller = VideoPlayerController.network(widget.gameDetail.trailerUrl);
    _chewieController = ChewieController(
      autoInitialize: true,
      videoPlayerController: _controller,
      allowMuting: true,
      aspectRatio: 4 / 2,
      systemOverlaysAfterFullScreen: [SystemUiOverlay.top],
      looping: false,
      showControlsOnInitialize: false,
      errorBuilder: (context, errorMessage) {
        return Container(color: Colors.blueGrey);
      },
      autoPlay: true,
      showControls: showControl,
      overlay: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            type: MaterialType.circle,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.white,
        handleColor: Colors.indigo,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.blueGrey,
      ),
    );
    //print("${_scrollController.offset}");
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset > 243) {
          setState(() {
            titleExpanded = !titleExpanded;
            displaytoAppbar = !displaytoAppbar;
            hideCreateButton = !hideCreateButton;
            // _chewieController.pause();
          });
        } else if (_scrollController.offset < 200) {
          setState(() {
            titleExpanded = false;
            displaytoAppbar = true;
            hideCreateButton = true;
            //_chewieController.play();
            //displaytoAppbar=!displaytoAppbar;
          });
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients && _scrollController.offset < (190);
  }

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final game = widget.gameDetail;
    return Scaffold(
      body: Hero(
          tag: widget.itemTag,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                expandedHeight: 220,
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    height: 260,
                    width: screenSize.width,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                  titlePadding: EdgeInsets.all(0),
                  title: Visibility(
                    visible: titleExpanded,
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            clipBehavior: Clip.antiAlias,
                            type: MaterialType.circle,
                            child: IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.chevron_left),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: game.logo,
                            placeholder: (context, url) => SpinKitCubeGrid(
                              color: Colors.white,
                              size: 10,
                            ),
                            imageBuilder: (context, imageProvider) => Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      fit: BoxFit.cover, image: imageProvider)),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.error_outline,
                              size: 20,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(game.name),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateRoom()));
                              },
                              child: Text("Create room"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                    width: screenSize.width,
                    height: screenSize.height,
                    child: TabBar(controller: tabController, tabs: [
                      new Tab(
                        icon: const Icon(Icons.home),
                        text: 'Address',
                      ),
                      new Tab(
                        icon: const Icon(Icons.my_location),
                        text: 'Location',
                      ),
                    ])),
                Container(
                  height: 80.0,
                  child: TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      new Card(
                        child: new ListTile(
                          leading: const Icon(Icons.home),
                          title: new TextField(
                            decoration: const InputDecoration(
                                hintText: 'Search for address...'),
                          ),
                        ),
                      ),
                      new Card(
                        child: new ListTile(
                          leading: const Icon(Icons.location_on),
                          title: new Text(
                              'Latitude: 48.09342\nLongitude: 11.23403'),
                          trailing: new IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  ),
                ),
              ]))
            ],
          )),
    );
  }
}
