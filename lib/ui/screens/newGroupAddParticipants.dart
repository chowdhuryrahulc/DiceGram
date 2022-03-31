// ignore_for_file: prefer_is_empty, curly_braces_in_flow_control_structures, avoid_function_literals_in_foreach_calls, deprecated_member_use, prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dicegram/gameIdProblem.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/providers/group_provider.dart';
import 'package:dicegram/ui/screens/group/group_chat_screen.dart';
import 'package:dicegram/ui/screens/new_group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chatroom.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ContactsScreen2 extends StatefulWidget {
  @override
  State<ContactsScreen2> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen2> {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final scafolfkey = GlobalKey<ScaffoldState>();
  List<UserModel> usersList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    GroupProvider().dispose1();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GroupProvider watchprovider = context.watch();
    final GroupProvider readprovider = context.read();
    double width = MediaQuery.of(context).size.width;
    List<UserModel> peopleList = [];

    return Scaffold(
      key: scafolfkey,
      appBar: AppBar(
        toolbarHeight: 100,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("New Group"),
            Text(
              "Add Participants",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                    future: ContactsService.getContacts(withThumbnails: false),
                    builder: (context, AsyncSnapshot contactSnapshot) {
                      if (contactSnapshot.data != null) {
                        List<Contact> contactList = contactSnapshot.data!;
                        for (var i = 0;
                            i < firebaseSnapshot.data!.docs.length;
                            i++) {
                          UserModel name = UserModel.fromSnapshot(
                              firebaseSnapshot.data?.docs[i]);
                          //todo place for next for loop
                          for (var j = 0; j < contactList.length - 1; j++) {
                            try {
                              if (name.number ==
                                  contactList[j]
                                      .phones
                                      ?.first
                                      .value
                                      .toString()
                                      .replaceAll(' ', '')) {
                                log(name.username);
                                if (peopleList.contains(name)) {
                                } else {
                                  peopleList.add(name);
                                }
                              }
                            } catch (e) {
                              log('O my god, Error');
                              print(e);
                            }
                          }
                        }
                        return ChangeNotifierProvider(
                            create: (context) => providerTest(),
                            builder: (context, builder) {
                              return Stack(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: Expanded(
                                      child: Center(
                                          child: ListView.builder(
                                              itemCount: peopleList.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                      onTap: () {},
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                              width:
                                                                  width * 0.1,
                                                              height:
                                                                  width * 0.1,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(width *
                                                                            0.1),
                                                                child: Image
                                                                    .network(
                                                                  peopleList[
                                                                          index]
                                                                      .image
                                                                      .toString(),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stacktress) {
                                                                    return Image
                                                                        .network(
                                                                            'https://picsum.photos/250?image=9');
                                                                  },
                                                                ),
                                                              )),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.7,
                                                            child: Text(
                                                              peopleList[index]
                                                                  .username,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: 20,
                                                              child: Consumer(
                                                                builder:
                                                                    (context,
                                                                        value,
                                                                        child) {
                                                                  return Checkbox(
                                                                    value: context
                                                                        .watch<
                                                                            providerTest>()
                                                                        .userModelList
                                                                        .contains(
                                                                            peopleList[index]),
                                                                    onChanged:
                                                                        (bool?
                                                                            value) {
                                                                      if (value ==
                                                                          true) {
                                                                        context
                                                                            .read<providerTest>()
                                                                            .addUserModelToUserModelList(peopleList[index]);
                                                                      } else {
                                                                        context
                                                                            .read<providerTest>()
                                                                            .removeUserModelToUserModelList(peopleList[index]);
                                                                      }
                                                                    },
                                                                  );
                                                                },
                                                              ))
                                                        ],
                                                      )),
                                                );
                                              })),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    right: 20,
                                    child: FloatingActionButton.small(
                                      child: const Icon(Icons.arrow_forward),
                                      onPressed: () {
                                        var x = Provider.of<providerTest>(
                                                context,
                                                listen: false)
                                            .userModelList;
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NewGroupProfile(
                                                      users: x,
                                                    )));
                                      },
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )
                                ],
                              );
                            });
                      } else {
                        return Center(child: Text('No Contacts Found'));
                      }
                    });
              }
            } else {
              return SizedBox();
            }
          }),
    );
  }
}
