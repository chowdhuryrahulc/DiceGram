import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/ui/screens/chat_screen.dart';
import 'package:dicegram/ui/widgets/one_to_one/chat_row.dart';
import 'package:flutter/material.dart';

class ChatCard1 extends StatelessWidget {
  final String userId;
  final String chatId;

  const ChatCard1({
    required this.userId,
    required this.chatId,
  }) : super();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream: UserServices().getUserStreamByUserId(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
          return const SizedBox();
        }
        var userData = UserModel.fromSnapshot(snapshot.data?.docs[0]);
        // var userData = snapshot.data?.docs[0];
        if (userData == null) {
          return const SizedBox();
        }
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatSccreen(
                      chatId: chatId,
                      senderName: userData.username,
                      userModel: userData,
                    )));
          },
          child: ChatRow(
              width: width,
              imageUrl: userData.imageUrl,
              isOnline: userData.online,
              username: userData.username,
              userId: userId,
              chatId: chatId),
        );
      },
    );
  }
}
