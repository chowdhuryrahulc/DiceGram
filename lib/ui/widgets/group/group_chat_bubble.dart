import 'package:dicegram/utils/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final String? messageSenderName;
  GroupChatBubble(
      {required this.message,
      required this.isMe,
      required this.time,
      required this.messageSenderName});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: SizedBox(
        width: width * 0.7.w,
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    color: isMe ? Colors1.primary : Colors.black12,
                    borderRadius: isMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(10.sp),
                            topRight: Radius.circular(10.sp),
                            bottomLeft: Radius.circular(10.sp))
                        : BorderRadius.only(
                            topLeft: Radius.circular(10.sp),
                            topRight: Radius.circular(10.sp),
                            bottomRight: Radius.circular(10.sp))),
                padding: EdgeInsets.all(8.sp),
                child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      isMe
                          ? SizedBox()
                          : Text(messageSenderName ?? '',
                              style: TextStyle(
                                  color: Colors.cyan,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold)),
                      Text(message,
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black54,
                              fontSize: 12)),
                    ])),
            Text(time, style: TextStyle(color: Colors.black54, fontSize: 10.sp))
          ],
        ),
      ),
    );
  }
}
