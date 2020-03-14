import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamming_community/API/Auth.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/utils/uploadFile.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class ProgressButton extends StatefulWidget {
  //TODO: error on update
  final File imagePath;
  final String token;
  final String nickname, email, phone, describe, birthday,userID;
  ProgressButton(
      {this.imagePath,
      this.token,
      this.userID,
      this.nickname,
      this.email,
      this.phone,
      this.describe,
      this.birthday});

  @override
  _ProgressBUttonState createState() => _ProgressBUttonState();
}

class _ProgressBUttonState extends State<ProgressButton>
    with TickerProviderStateMixin {
  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  GraphQLMutation mutation = GraphQLMutation();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget setUpChild() {
    if (_state == 0) {
      return Text(
        "Save",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    } else if (_state == 1) {
      return FutureBuilder(future: Future(() async {
        print("Hree ${widget.imagePath.path}");
        GraphQLClient client = authAPI(widget.token);
        var avatarUrl = await uploadFile(widget.userID,widget.imagePath);
        return await client.mutate(MutationOptions(
            documentNode: gql(mutation.editAccount(
                widget.nickname, widget.describe, widget.email, "", "",avatarUrl))));
      }), builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting)
          return SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        else {
          print(snapshot.data);
          
          return Icon(Icons.check, color: Colors.white);
        }
      });
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() {
    //double initialWidth = _globalKey.currentContext.size.width;
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1).animate(_controller)
      ..addListener(() {
        /*setState(() {
          _width = initialWidth - ((initialWidth - 48) * _animation.value);
        });*/
      });
    _controller.forward();
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 2000), () {
      setState(() {
        _state = 2;
      });
      Timer(Duration(seconds: 2), () {
        setState(() {
          _state = 0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        height: 28,
        key: _globalKey,
        child: RaisedButton(
          padding: EdgeInsets.all(0),
          animationDuration: Duration(milliseconds: 1000),
          onPressed: () {
            setState(() {
              if (_state == 0) {
                animateButton();
              }
            });
          },
          child: setUpChild(),
        ),
      ),
    );
  }
}
