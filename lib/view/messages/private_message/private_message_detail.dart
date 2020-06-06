import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/ReceiveNotfication.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/messages/models/private_chat_provider.dart';
import 'package:gamming_community/view/messages/private_message/private_chats.dart';
import 'package:rxdart/rxdart.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class PrivateMessagesDetail extends StatefulWidget {
  final String chatID;
  final List member;
  PrivateMessagesDetail({this.chatID,this.member});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<PrivateMessagesDetail>
    with AutomaticKeepAliveClientMixin<PrivateMessagesDetail>, TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String roomName = "Sample here";
  bool isSubmited = false;
  TextEditingController chatController;
  PrivateChatProvider chatProvider;
  ScrollController scrollController;

  GraphQLQuery query = GraphQLQuery();
  String senderUrl = AppConstraint.default_profile;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
  NotificationAppLaunchDetails notificationAppLaunchDetails;

  List<String> sampleUser = [
    "https://api.adorable.io/avatars/90/abott@adorable.io.png",
    "https://api.adorable.io/avatars/90/magic.png",
    "https://api.adorable.io/avatars/90/closer.png",
    "https://api.adorable.io/avatars/90/mygf.png",
    "https://api.adorable.io/avatars/90/yolo.pngCopy.png",
    "https://api.adorable.io/avatars/90/facebook.png",
    "https://api.adorable.io/avatars/90/dump.png",
    "https://api.adorable.io/avatars/90/pikachu.png",
    "https://api.adorable.io/avatars/90/lumber.png",
    "https://api.adorable.io/avatars/90/wing.png"
  ];
  Future getImage() async {
    return sampleUser;
  }

  void loadMessage() async {
    /* var animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    // TODO
    var result = await MainRepo.queryGraphQL("", query.getPrivateMessges(widget.currentID));

    var listMessage = PrivateMessages.fromJson(result.data['getPrivateChat']).privateMessages;

    listMessage.forEach((e) {
      chatProvider.onAddNewMessage(PrivateChat(
        currentID: widget.currentID,
        sender: {"id": e.sender['id'], "profile_url": e.sender['profile_url']},
        animationController: animationController,
        text: e.text,
        sendDate: e.createAt,
      ));
      animationController.forward();
      animateToBottom();
    });*/
  }

  void onSendMesasge(String message) {
    if (chatController.text.isEmpty) return;

    var animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    /* var chatMessage = PrivateChat(
      currentID: widget.currentID,
      sender: {"id": widget.currentID, "profile_url": widget.profileUrl},
      animationController: animationController,
      text: chatController.text,
      sendDate: DateTime.now(),
    );*/
    sendMessageToSocket();

    // chatMessage.animationController.forward();

    // add mess to listview
    // chatProvider.onAddNewMessage(chatMessage);

    chatController.clear();
    animateToBottom();
  }

  void sendMessageToSocket() {
    /* chatProvider.socket.emit('chat-private', [
      [
        {
          "roomID": widget.chatID,
        },
        {
          "user": {"id": widget.currentID},
          "text": chatController.text
        }
      ]
    ]);*/
    animateToBottom();
  }

  void onRecieveMessage() {
    chatProvider.socket.on('message-private', (data) async {
      print('recive message' + data.toString());
      print(data[1]['user']['id']);
      notificationAppLaunchDetails =
          await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

      var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

      var initializationSettings = InitializationSettings(initializationSettingsAndroid, null);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload);
      });
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.Max, priority: Priority.High, ticker: 'ticker');

      var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, null);
      await flutterLocalNotificationsPlugin.show(
          0, data[1]['user']['id'], data[1]['text'], platformChannelSpecifics,
          payload: 'item x');

      var animationController =
          AnimationController(vsync: this, duration: Duration(milliseconds: 500));
      /* var chatMessage = PrivateChat(
          sender: {"id": data[1]['user']['id'], "profile_url": widget.profileUrl},
          text: data[1]['text'],
          animationController: animationController,
          sendDate: DateTime.now());*/
      //add message to end
      //chatMessage.animationController.forward();
      // add message to list and update UI
      //   chatProvider.onAddNewMessage(chatMessage);

      await Future.delayed(Duration(milliseconds: 100));

      animateToBottom();
    });
  }

  void animateToBottom() async {
    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      curve: Curves.linear,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    chatController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((d) {
      chatProvider.initSocket();
      //chatProvider.joinRoom(widget.chatID);
      loadMessage();
      onRecieveMessage();
      animateToBottom();
    });
  }

  @override
  void dispose() {
    chatController.dispose();
    chatProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Injector.get(context: context);
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(icon: Icon(Icons.chevron_left), onPressed: () {})),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("widget.currentID"),
                      ],
                    ),
                    Positioned(
                        right: 5,
                        child: Material(
                          color: Colors.transparent,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.call),
                                onPressed: () {
                                  //callGroup(context, getImage());
                                },
                              ),
                              // see list of user here
                              IconButton(
                                icon: Icon(Icons.group),
                                onPressed: () {
                                  scaffoldKey.currentState.openEndDrawer();
                                },
                              )
                            ],
                          ),
                        ))
                  ],
                )),
            SizedBox(height: 10),
            // message area
            Flexible(
                child: ListView.builder(
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 12),
                    itemCount: chatProvider.messages.length,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          if (index == 0) Text(formatDate(chatProvider.messages[index].sendDate)),
                          if (index != 0 &&
                              chatProvider.messages[index - 1].sendDate.minute !=
                                  chatProvider.messages[index].sendDate.minute)
                            Text(formatDateTime(chatProvider.messages[index].sendDate)),
                          chatProvider.messages[index],
                        ],
                      );
                    })),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white70,
              ),
              child: Row(
                children: <Widget>[
                  Material(
                    type: MaterialType.circle,
                    clipBehavior: Clip.antiAlias,
                    color: Colors.transparent,
                    child: IconButton(
                        icon: Icon(Icons.attach_file),
                        onPressed: () {
                          print('Attach');
                        },
                        color: Colors.black),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: TextField(
                        onSubmitted: (value) {
                          setState(() {
                            isSubmited = true;
                          });
                        },
                        controller: chatController,
                        style: TextStyle(color: Colors.black),
                        decoration:
                            InputDecoration(border: InputBorder.none, hintText: 'Text here')),
                  ),
                  Material(
                      type: MaterialType.circle,
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent,
                      child: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.bubble_chart),
                          onPressed: () {
                            onSendMesasge(chatController.text);
                          }))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/*Future callGroup(BuildContext context, Future getImage) {
  return showModalBottomSheet(
      context: context,
      builder: (bottomSheetBuilder) => Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: AppColors.BACKGROUND_COLOR),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Invite to call',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text('Select user')
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {},
                  )
                ],
              ),
              Expanded(
                  flex: 1,
                  child: FutureBuilder(
                      future: getImage,
                      initialData: [],
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else
                          return ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                    thickness: 1,
                                  ),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(10000.0),
                                            child: CachedNetworkImage(
                                              height: 50,
                                              width: 50,
                                              imageUrl: snapshot.data[index],
                                              fadeInDuration: Duration(seconds: 3),
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Hummmmmmmmm",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Stack(
                                          alignment: Alignment.centerRight,
                                          children: <Widget>[
                                            Positioned(
                                                child: SizedBox(
                                              width: 60,
                                              child: RaisedButton(
                                                  color: Colors.indigo,
                                                  onPressed: () {},
                                                  child: Text("Add")),
                                            ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                      }))
            ],
          )));
}*/