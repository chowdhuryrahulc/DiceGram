import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/group_service.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/ui/widgets/group/group_unread_message_count.dart';
import 'package:dicegram/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupChatRow extends StatelessWidget {
  const GroupChatRow({
    Key? key,
    required this.imageUrl,
    required this.isOnline,
    required this.username,
    required this.groupId,
  }) : super(key: key);

  final String imageUrl;
  final bool isOnline;
  final String username;
  final String groupId;

  @override
  Widget build(BuildContext context) {
    String lastMessage;
    String lastMessageTime;

    return StreamBuilder<QuerySnapshot>(
      stream: GroupService().getGroupLastMessage(groupId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
          return const SizedBox();
        }
        var totalMessage = snapshot.data?.docs.length;
        if (totalMessage == null) {
          return const Text('No msg found');
        }

        var lastMsgData = (totalMessage > 0) ? snapshot.data?.docs[0] : null;
        if (lastMsgData != null) {
          lastMessage = lastMsgData[KeyConstants.MESSAGE];
          lastMessageTime = Utils.getDateFromTimestamp(
              lastMsgData[KeyConstants.CREATED_AT], 'MMM dd');
        } else {
          lastMessage = "No messages";
          lastMessageTime = "";
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width.w * 0.16,
                height: MediaQuery.of(context).size.width.w * 0.16,
                child: Stack(fit: StackFit.expand, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                            'https://picsum.photos/250?image=9');
                      },
                    ),
                  ),
                ]),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width.w * 0.04,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width.w * 0.16,
                width: MediaQuery.of(context).size.width.w * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      maxLines: 1,
                    ),
                    Text(
                      lastMessage,
                      maxLines: 1,
                      style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width).w * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lastMessageTime.toString(),
                        style: const TextStyle(color: Colors.black45),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      GroupUnreadMessageCount(groupId: groupId),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
