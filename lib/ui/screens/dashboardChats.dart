import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/ui/screens/chat_screen.dart';
import 'package:dicegram/ui/screens/chatroom.dart';
import 'package:dicegram/ui/widgets/one_to_one/chat_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardChats extends StatefulWidget {
  const DashboardChats({Key? key}) : super(key: key);

  @override
  State<DashboardChats> createState() => _DashboardChatsState();
}
/*
Stream1: UserServices().getChatList()
Stream2: UserServices().getUserStreamByUserId(userId),
Stream3: UserServices().getLastMessage(chatId, userId),
*/

class _DashboardChatsState extends State<DashboardChats> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: UserServices().getChatList(),
        builder: (context, chatListSnapshot) {
          if (!chatListSnapshot.hasData ||
              chatListSnapshot.data?.docs.length == 0) {
            return const SizedBox(); //no chat found
          }
          return ListView.builder(
              itemCount: chatListSnapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var chatId = chatListSnapshot.data?.docs[index].id;
                String? senderId = (chatListSnapshot.data?.docs[index]['users']
                            [0] ==
                        FirebaseAuth.instance.currentUser!.uid)
                    ? chatListSnapshot.data?.docs[index]['users'][1]
                    : chatListSnapshot.data?.docs[index]['users'][0];
                //! do something so that if one msg is not there, it should not show.
                return ChatCard1(
                  userId: senderId.toString(),
                  chatId: chatId.toString(),
                );
              });
        });
  }
}
