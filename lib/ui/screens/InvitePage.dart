// ignore_for_file: use_key_in_widget_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/utils/Color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share/share.dart';
import 'chat_screen.dart';
import 'chatroom.dart';

class InvitePage extends StatefulWidget {
  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  List<UserModel> peopleList = [];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    UserModel user = UserModel();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text("Users"),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: UserServices().getFirebaseUsers(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> firebaseSnapshot) {
                    if (firebaseSnapshot.hasError) {
                      return Text(firebaseSnapshot.error.toString());
                    } else if (firebaseSnapshot.hasData &&
                        firebaseSnapshot.data != null) {
                      if (firebaseSnapshot.data?.docs.length == 0) {
                        return const Center(child: Text('No Contacts found'));
                      } else {
                        return FutureBuilder<List<Contact>>(
                            future: ContactsService.getContacts(
                                withThumbnails: false),
                            builder: (context, AsyncSnapshot contactSnapshot) {
                              if (contactSnapshot.data != null) {
                                List<Contact> contactList =
                                    contactSnapshot.data!;
                                //todo first for loop for all firebase docs
                                for (var i = 0;
                                    i < firebaseSnapshot.data!.docs.length;
                                    i++) {
                                  UserModel name = UserModel.fromSnapshot(
                                      firebaseSnapshot.data?.docs[i]);
                                  //todo place for next for loop
                                  for (var j = 0;
                                      j < contactList.length - 1;
                                      j++) {
                                    try {
                                      if (contactList[j]
                                              .phones
                                              ?.first
                                              .value?[0] !=
                                          '+') {
                                        contactList[j].phones?.first.value =
                                            '+91' +
                                                contactList[j]
                                                    .phones!
                                                    .first
                                                    .value!;
                                      }
                                      if (name.number ==
                                          contactList[j]
                                              .phones
                                              ?.first
                                              .value
                                              .toString()
                                              .replaceAll(' ', '')) {
                                        if (peopleList.contains(name)) {
                                        } else {
                                          peopleList.add(name);
                                        }
                                      }
                                    } catch (e) {}
                                  }
                                }
                                return SizedBox(
                                  height: 400.h,
                                  child: Expanded(
                                    child: Center(
                                      child: ListView.builder(
                                          itemCount: peopleList.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.all(8.sp),
                                              child: InkWell(
                                                  onTap: () async {
                                                    await handleOnClick(
                                                        peopleList[index]);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                          width: width.w * 0.1,
                                                          height: width.w * 0.1,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        width.w *
                                                                            0.1),
                                                            child:
                                                                Image.network(
                                                              peopleList[index]
                                                                  .imageUrl
                                                                  .toString(),
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stacktress) {
                                                                log(error
                                                                    .toString());
                                                                return Image
                                                                    .network(
                                                                        'https://picsum.photos/250?image=9');
                                                              },
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      SizedBox(
                                                        width: width.w * 0.7,
                                                        child: Text(
                                                          peopleList[index]
                                                              .username,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            );
                                          }),
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                      child: SpinKitPouringHourGlass(
                                          color: Colors.red));
                              }
                            });
                      }
                    } else {
                      return const SizedBox();
                    }
                  }),
            ),
            InkWell(
                onTap: () {
                  Share.share(
                      'hey! check out this new app https://play.google.com/store/apps/details?id=com.dicegram.user.dicegram',
                      subject: 'Dicegram');
                },
                child: Container(
                  color: Colors1.primary,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Text('Invite',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0.0.sp, 4.0.sp),
                                blurRadius: 10.0.r,
                                color: Colors.black38,
                              ),
                            ],
                          )),
                    ),
                  ),
                ))
          ],
        ));
  }

  Future<void> handleOnClick(UserModel senderData) async {
    String result = await UserServices().getChatroomId(senderData.id);
    if (result == 'notFound') {
      //! Should not create chatroom ontap. only when 1 msg is present.
      DocumentReference ref =
          await UserServices().createChatRoom([userId, senderData.id]);
      if (ref != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatSccreen(
                  chatId: ref.id,
                  senderName: senderData.username,
                  userModel: senderData,
                )));
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatSccreen(
                chatId: result,
                senderName: senderData.username,
                userModel: senderData,
              )));
    }
  }
}
