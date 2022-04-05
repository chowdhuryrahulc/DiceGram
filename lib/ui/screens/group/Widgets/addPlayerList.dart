import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dicegram/gameIdProblem.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/group_data.dart';
import 'package:dicegram/ui/screens/group/group_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/user_model.dart';

class addPlayersList extends StatefulWidget {
  addPlayersList(
      {Key? key,
      required this.groupData,
      required this.chatId,
      required this.adminId,
      required this.groupName})
      : super(key: key);
  final String adminId;
  final String groupName;
  GroupData groupData;
  String chatId;

  @override
  State<addPlayersList> createState() => _addPlayersListState();
}

class _addPlayersListState extends State<addPlayersList> {
  List<UserModel> peopleList = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
                  builder: (context, contactSnapshot) {
                    if (contactSnapshot.data != null) {
                      List<Contact> contactList = contactSnapshot.data!;
                      for (var i = 0;
                          i < firebaseSnapshot.data!.docs.length;
                          i++) {
                        UserModel name = UserModel.fromSnapshot(
                            firebaseSnapshot.data?.docs[i]);
                        for (var j = 0; j < contactList.length - 1; j++) {
                          try {
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
                          } catch (e) {
                            print('Error in addPlayersList');
                          }
                        }
                      }
                      return ChangeNotifierProvider(
                        create: (context) => addPlayerProvider(),
                        builder: (context, builder) {
                          return Column(
                            children: [
                              const Text('Select Players'),
                              Expanded(
                                  child: ListView.builder(
                                      itemCount: peopleList.length,
                                      itemBuilder: (context, index) {
                                        if (!widget.groupData.users
                                            .contains(peopleList[index].id)) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Image.network(
                                                      peopleList[index]
                                                          .imageUrl
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Image.network(
                                                            'https://picsum.photos/250?image=9');
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  peopleList[index].username,
                                                  maxLines: 1,
                                                )),
                                                SizedBox(
                                                  width: 20,
                                                  child: Checkbox(
                                                    value: context
                                                        .watch<
                                                            addPlayerProvider>()
                                                        .userModelList
                                                        .contains(
                                                            peopleList[index]
                                                                .id),
                                                    onChanged: (bool? value) {
                                                      if (value == true) {
                                                        context
                                                            .read<
                                                                addPlayerProvider>()
                                                            .addUserModelToUserModelList(
                                                                peopleList[
                                                                        index]
                                                                    .id);
                                                      } else {
                                                        context
                                                            .read<
                                                                addPlayerProvider>()
                                                            .removeUserModelToUserModelList(
                                                                peopleList[
                                                                        index]
                                                                    .id);
                                                      }
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      })),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        newAddedUsersList.clear;
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel')),
                                  ElevatedButton(
                                      onPressed: () {
                                        List<String> x =
                                            Provider.of<addPlayerProvider>(
                                                    context,
                                                    listen: false)
                                                .userModelList;
                                        addUsersInGroup(widget.chatId, x);
                                        newAddedUsersList.clear();
                                        Navigator.pop(context);
                                        //todo change
                                        GroupData groupData =
                                            GroupData.addUsers(x);
                                        // Navigator.pushReplacement(context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) {
                                        //   return GroupChatScreen(
                                        //     adminId: widget.adminId,
                                        //     chatId: widget.chatId,
                                        //     groupData: groupData,
                                        //   );
                                        // }));
                                      },
                                      child: Text('Next')),
                                ],
                              )
                            ],
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('No Contacts Found'));
                    }
                  });
            }
          }
          return Text(firebaseSnapshot.data?.docs.length.toString() ?? '');
        });
  }
}
