// // // ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, curly_braces_in_flow_control_structures, unnecessary_null_comparison, avoid_print

// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:dicegram/gameIdProblem.dart';
// import 'package:dicegram/helpers/user_service.dart';
// import 'package:dicegram/models/user_model.dart';
// import 'package:dicegram/ui/screens/chat_screen.dart';
// import 'package:dicegram/ui/screens/dashboard.dart';
// import 'package:dicegram/utils/Color.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share/share.dart';
// // import 'one2one/chat_screen.dart';

// class ContactListScreen extends StatefulWidget {
//   const ContactListScreen({Key? key}) : super(key: key);

//   @override
//   State<ContactListScreen> createState() => _ContactsScreenState();
// }

// class _ContactsScreenState extends State<ContactListScreen> {
//   String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//   // PermissionStatus? status;

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     UserModel user = UserModel();
//     return Scaffold(
//         appBar: AppBar(
//           toolbarHeight: 100,
//           iconTheme: const IconThemeData(
//             color: Colors.white, //change your color here
//           ),
//           title: const Text("Users"),
//         ),
//         body: Column(
//           children: [
//             status == PermissionStatus.granted
//                 ? Expanded(
//                     child: FutureBuilder(
//                     future: fetchAllFirebaseContats(),
//                     builder: (context, AsyncSnapshot snap) {
//                       if (snap.hasData || snap.data != null) {
//                         print("snap.data[2]");
//                         print(snap.data);
//                       }
//                       return FutureBuilder<List<Contact>>(
//                           // Doesnt fetch phoneContacts. Only simContacts
//                           future: ContactsService.getContacts(
//                               withThumbnails: false),
//                           builder: (context, AsyncSnapshot snapshot) {
//                             if (snapshot.data == null) {
//                               return const Text('No Contact Found');
//                             }
//                             List<Contact> contactList = snapshot.data!;
//                             print('snapshot.data');
//                             print(snapshot.data);
//                             return FutureBuilder<List<UserModel>>(
//                                 future: UserServices()
//                                     .getFirebaseUsersFromContacts(contactList),
//                                 builder: (BuildContext context,
//                                     AsyncSnapshot<List<UserModel>> snapshot) {
//                                   if (snapshot.hasError) {
//                                     return Text(snapshot.error.toString());
//                                   } else if (snapshot.hasData &&
//                                       snapshot.data != null) {
//                                     if (snapshot.data!.isEmpty) {
//                                       return const Center(
//                                           child: Text('No Contacts found'));
//                                     } else {
//                                       return Container(
//                                         height: 400,
//                                         child: Expanded(
//                                           child: Center(
//                                             child: ListView.builder(
//                                                 itemCount:
//                                                     snapshot.data!.length,
//                                                 itemBuilder: (context, index) {
//                                                   user = snapshot.data![index];
//                                                   if (user.id != userId) {
//                                                     return InkWell(
//                                                       onTap: () async {
//                                                         //! Store in Hive. Index is int.
//                                                         await handleOnClick(
//                                                             snapshot
//                                                                 .data![index]);
//                                                       },
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(8.0),
//                                                         child: Row(
//                                                           children: [
//                                                             SizedBox(
//                                                               width:
//                                                                   width * 0.1,
//                                                               height:
//                                                                   width * 0.1,
//                                                               child: ClipRRect(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(width *
//                                                                             0.1),
//                                                                 child: Image
//                                                                     .network(
//                                                                   //!String imageUrl
//                                                                   user.image
//                                                                       .toString(),
//                                                                   fit: BoxFit
//                                                                       .cover,
//                                                                   errorBuilder:
//                                                                       (context,
//                                                                           error,
//                                                                           stackTrace) {
//                                                                     return Image
//                                                                         .network(
//                                                                             'https://picsum.photos/250?image=9');
//                                                                   },
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             const SizedBox(
//                                                               width: 10,
//                                                             ),
//                                                             SizedBox(
//                                                                 width:
//                                                                     width * 0.7,
//                                                                 child: Text(
//                                                                   user.username,
//                                                                   maxLines: 1,
//                                                                 )),
//                                                             // Checkbox(value: false, onChanged: (bool? value) {  },
//                                                             // )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   } else
//                                                     return Center(
//                                                         child: Text(
//                                                             'No User Found'));
//                                                 }),
//                                           ),
//                                         ),
//                                       );
//                                     }
//                                   }
//                                   return Center(
//                                       child: SpinKitPouringHourGlass(
//                                           color: Colors.red));
//                                 });
//                           });
//                     },
//                     // child:
//                   ))
//                 : Container(
//                     child: Center(
//                       child: Text('Contact Permission Required'),
//                     ),
//                   ),
//             InkWell(
//               onTap: () async {
//                 Share.share(
//                     'hey! check out this new app https://drive.google.com/file/d/18jeA8AoZ_iupNjdc_A4cc7R2FZMJC2MA/view?usp=sharing',
//                     subject: 'Dicegram');
//               },
//               child: Container(
//                   color: Colors1.primary,
//                   child: const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Text(
//                         'Invite',
//                         style: TextStyle(
//                           fontSize: 24,
//                           color: Colors.white,
//                           shadows: <Shadow>[
//                             Shadow(
//                               offset: Offset(0.0, 4.0),
//                               blurRadius: 10.0,
//                               color: Colors.black38,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )),
//             ),
//           ],
//         ));
//   }

//   Future<void> handleOnClick(UserModel senderData) async {
//     String result = await UserServices().getChatroomId(senderData.id);
//     if (result == 'notFound') {
//       DocumentReference ref =
//           await UserServices().createChatRoom([userId, senderData.id]);
//       if (ref != null) {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => ChatSccreen(
//                   chatId: ref.id,
//                   senderName: senderData.username,
//                   userModel: senderData,
//                 )));
//       }
//     } else {
//       Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => ChatSccreen(
//                 chatId: result,
//                 senderName: senderData.username,
//                 userModel: senderData,
//               )));
//     }
//   }
// }

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
                                  // print("name.number ${name.number}");
                                  //todo place for next for loop
                                  for (var j = 0;
                                      j < contactList.length - 1;
                                      j++) {
                                    try {
                                      log(contactList[j]
                                              .phones
                                              ?.first
                                              .value
                                              .toString()[0] ??
                                          '');
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
                                        log(peopleList.length.toString());
                                        if (peopleList.contains(name)) {
                                        } else {
                                          peopleList.add(name);
                                        }
                                      }
                                    } catch (e) {}
                                  }
                                }
                                return SizedBox(
                                  height: 400,
                                  child: Expanded(
                                    child: Center(
                                      child: ListView.builder(
                                          itemCount: peopleList.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                  onTap: () async {
                                                    await handleOnClick(
                                                        peopleList[index]);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                          width: width * 0.1,
                                                          height: width * 0.1,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        width *
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
                                                    ],
                                                  )),
                                            );
                                          }),
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: Text('No Contacts Found'));
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
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Invite',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0.0, 4.0),
                                blurRadius: 10.0,
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