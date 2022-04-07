// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:demoji/demoji.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarPlayer extends StatelessWidget {
  const AvatarPlayer({Key? key, required this.player, required this.size}) : super(key: key);
  final int player;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Used to differenciate btw 2 images.
      padding: EdgeInsets.all(size.sp),
      child: SizedBox(
        height: 30.h,
        width: 30.w,
        child: player == 1
            ? Text(
                Demoji.running_woman,
                style: TextStyle(fontSize: 18.sp),
              )
            : Text(Demoji.running_man, style: TextStyle(fontSize: 18.sp)),
      ),
    );
  }
}
