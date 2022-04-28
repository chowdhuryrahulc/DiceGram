import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/group_data.dart';
import 'package:dicegram/ui/screens/group/group_chat_screen.dart';
import 'package:flutter/material.dart';

import '../../../../models/user_model.dart';

class deletePlayersList extends StatefulWidget {
  deletePlayersList({Key? key, required this.groupData}) : super(key: key);
  GroupData groupData;
  @override
  State<deletePlayersList> createState() => _deletePlayersListState();
}

class _deletePlayersListState extends State<deletePlayersList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: UserServices().getFirebaseUsers(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data?.docs.length == 0) {
              return const Center(child: Text('No Contacts found'));
            } else {
              return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        // users is all firebase users.
                        // groupData doesnt have list of names. thats why we print here users.username
// otherwise we could have used just printed userdata and no need of "contains"
                        UserModel users =
                            UserModel.fromSnapshot(snapshot.data?.docs[index]);
                        //todo Problem: groupdata not updating.
                        log('GroupId.users ${widget.groupData.users}');
                        log('User,id ${users.username}');
                        if (widget.groupData.users.contains(users.id) &&
                            users.id != UserServices.userId) {
                          print(users.username.toString());
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      users.imageUrl.toString(),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.network(
                                            'https://picsum.photos/250?image=9');
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                // Player name, to be send to next screen
                                Expanded(
                                    child: Text(
                                  users.username.toString(),
                                  maxLines: 1,
                                )),
                                // CheckBox
                                SizedBox(
                                  width: 20,
                                  child: Checkbox(
                                    value: deletedUsersList.contains(users.id),
                                    onChanged: (bool? value) {
                                      print(deletedUsersList);
                                      if (value == true) {
                                        setState(() {
                                          //! The list where the users who will play are added.
                                          if (deletedUsersList
                                              .contains(users.id)) {
                                          } else {
                                            deletedUsersList.add(users.id);
                                          }
                                        });
                                      } else {
                                        setState(() {
                                          deletedUsersList.remove(users.id);
                                        });
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                          ;
                        }
                        return Container();
                      }));
            }
          } else {
            return SizedBox();
          }
        });
  }
}
