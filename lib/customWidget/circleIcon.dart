import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:get/get.dart';

class CircleIcon extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Function onTap;
  CircleIcon({@required this.icon, this.iconColor, this.iconSize = 20,@required this.onTap});

  @override
  _CircleIconState createState() => _CircleIconState();
}

class _CircleIconState extends State<CircleIcon> {
  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      type: MaterialType.circle,
      child: IconButton(
        icon: Icon(widget.icon,color: widget.iconColor,),
        onPressed: () {
          return widget.onTap();
        },
        color: widget.iconColor == null ? Get.isDarkMode ? Colors.white : Colors.black : widget.iconColor,
        iconSize: widget.iconSize,
      ),
    );
  }
}
