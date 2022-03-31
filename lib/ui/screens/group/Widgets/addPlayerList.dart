import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/group_data.dart';
import 'package:dicegram/ui/screens/group/group_chat_screen.dart';
import 'package:flutter/material.dart';

import '../../../../models/user_model.dart';

class addPlayersList extends StatefulWidget {
  addPlayersList({Key? key, required this.groupData}) : super(key: key);
  GroupData groupData;

  @override
  State<addPlayersList> createState() => _addPlayersListState();
}

class _addPlayersListState extends State<addPlayersList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        //todo add filteration
        stream: UserServices().getFirebaseUsers(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      UserModel users =
                          UserModel.fromSnapshot(snapshot.data?.docs[index]);
                      //todo the people already in the group should not appear.
                      if (!widget.groupData.users.contains(users.id) &&
                          UserServices.userId != users.id) {
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
                                    users.image.toString(),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
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
                                  value: newAddedUsersList.contains(users.id),
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      setState(() {
                                        //! The list where the users who will play are added.
                                        if (newAddedUsersList
                                            .contains(users.id)) {
                                        } else {
                                          newAddedUsersList.add(users.id);
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        newAddedUsersList.remove(users.id);
                                      });
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      } else
                        return const SizedBox();
                    }),
              );
            }
          }
          return Text(snapshot.data?.docs.length.toString() ?? '');
        });
  }
}
