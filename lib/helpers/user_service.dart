// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/models/room_model.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/utils/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';

class UserServices {
  static String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Future<bool>

  Future<bool> createUser(Map<String, dynamic> values) async {
    String id = values[KeyConstants.ID];
    bool status = false;
    // await FirebaseUtils.getUsersColRef().doc(id).update(values);
    await FirebaseUtils.getUsersColRef().doc(id).set(values).then((value) {
      status = true;
    }).catchError((onError) {
      status = false;
    });
    return status;
  }

  Future<bool> updateUserData(Map<String, dynamic> values) async {
    bool status = false;
    await FirebaseUtils.getUsersColRef()
        .doc(UserServices.userId)
        .update(values)
        .then((value) {
      print('status');
      status = true;
    }).catchError((onError) {
      status = false;
    });
    return status;
  }

  void updateCurrentUserData(Map<String, dynamic> values) {
    FirebaseUtils.getUsersColRef().doc(UserServices.userId).update(values);
  }

  Future<UserModel> getUserById(String id) =>
      FirebaseUtils.getUsersColRef().doc(id).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });

  Stream<QuerySnapshot> getFirebaseUsers() =>
      FirebaseUtils.getUsersColRef().snapshots();

  Future<DocumentReference> createChatRoom(List<String> userIds) async {
    print('creating collection');
    DocumentReference docRef = await FirebaseUtils.getChatListColRef().add(Room(
            adminId: '',
            createdAt: Timestamp.now(),
            groupName: '',
            imageUrl: '',
            isGroup: false,
            userIds: userIds)
        .toMap());
    return docRef;
  }

  Future<String> getChatroomId(String id) async {
    String result = 'notFound';

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseUtils.getChatListColRef()
            .where(KeyConstants.USERS_ARRAY_IN_CHAT, arrayContains: userId)
            .get() as QuerySnapshot<Map<String, dynamic>>;

    for (var doc in snapshot.docs) {
      List<dynamic> users = doc[KeyConstants.USERS_ARRAY_IN_CHAT];
      if (users.contains(id)) {
        result = doc.id;
        return result;
      }
    }

    return result;
  }

  // Future<String> getGroupId(String id) async {
  //   String result = 'notFound';
  //   QuerySnapshot<Map<String, dynamic>> snapshot =
  //       await FirebaseUtils.getGroupListColRef().where(
  //               KeyConstants.USERS_ARRAY_IN_CHAT,
  //               arrayContains: [id, userId]).get()
  //           as QuerySnapshot<Map<String, dynamic>>;

  //   for (var element in snapshot.docs) {
  //     if (element[KeyConstants.IS_GROUP] != true) {
  //       result = element.id;
  //     }
  //   }
  //   return result;
  // }

  void sendMessage({required String message, required String roomId}) {
    Map<String, dynamic> data = {};

    if (userId.isNotEmpty) {
      data[KeyConstants.SENDER_ID] = userId;
      data[KeyConstants.CREATED_AT] = FieldValue.serverTimestamp();
      data[KeyConstants.MESSAGE_TYPE] = 'text';
      data[KeyConstants.MESSAGE] = message;
      data[KeyConstants.SEEN] = false;
      FirebaseUtils.getChatListColRef()
          .doc(roomId)
          .collection(KeyConstants.MESSAGE)
          .add(data);
    }
  }

  Stream<QuerySnapshot> getChat(roomId) => FirebaseUtils.getChatListColRef()
      .doc(roomId)
      .collection(KeyConstants.MESSAGE)
      .orderBy(KeyConstants.CREATED_AT, descending: true)
      .snapshots();

  Stream<QuerySnapshot> getGroupChat(groupId) =>
      FirebaseUtils.getGroupListColRef()
          .doc(groupId)
          .collection(KeyConstants.MESSAGE)
          .orderBy(KeyConstants.CREATED_AT, descending: true)
          .snapshots();

  Stream<QuerySnapshot> getChatList() {
    var v = FirebaseUtils.getChatListColRef()
        .where(KeyConstants.USERS_ARRAY_IN_CHAT, arrayContains: userId)
        .snapshots();
    return v;
  }

  Stream<QuerySnapshot> getUserStreamByUserId(userId) {
    var v = FirebaseUtils.getUsersColRef()
        .where(KeyConstants.ID, isEqualTo: userId)
        .snapshots();
    return v;
  }

  Stream<QuerySnapshot> getLastMessage(chatId, userId) {
    var v = FirebaseUtils.getChatListColRef()
        .doc(chatId)
        .collection(KeyConstants.MESSAGE)
        .orderBy(KeyConstants.CREATED_AT)
        .limitToLast(1)
        .snapshots();
    return v;
  }

  Stream<QuerySnapshot> getUnreadMessageCount(chatId, userId) {
    var v = FirebaseUtils.getChatListColRef()
        .doc(chatId)
        .collection(KeyConstants.MESSAGE)
        .where(KeyConstants.SENDER_ID, isEqualTo: userId)
        .where(KeyConstants.SEEN, isEqualTo: false)
        .snapshots();
    return v;
  }

// int countNumberOfFirebaseUsers(){

// }
  Future<List<UserModel>> getFirebaseUsersFromContacts(
      List<Contact> contactList) async {
    List<UserModel> userList = [];
    List<String> phoneNumberList = [];

// Adding all the phoneNumbers to a phoneNumberList.
    contactList.map((e) {
      if (e.phones != null) {
        String? phoneNumber = ((e.phones!.length) != 0)
            ? (e.phones![0].value.toString().replaceAll(' ', ''))
            : null;
        if (phoneNumber != null) {
          phoneNumberList.add(phoneNumber);
        }
      }
    }).toList();

    //// log(TAG + ' phoneNumberList ${phoneNumberList.length}');

    List<List<String>> subList = [];

    //dividing list of 10 10 contacts
    for (var i = 0; i < phoneNumberList.length; i += 10) {
      subList.add(phoneNumberList.sublist(i,
          i + 10 > phoneNumberList.length ? phoneNumberList.length : i + 10));
    }

    //// log(TAG + ' phoneNumberList splited in ${subList.length}');

    for (var numberList in subList) {
      // print('NUMBER List');
      // print(numberList);
      await FirebaseUtils.getUsersColRef()
          .where(KeyConstants.NUMBER, whereIn: numberList)
          .get()
          .then((value) async {
        print('value');
        print(value.docs.length); // value null
        for (var snapshot in value.docs) {
          UserModel user = UserModel.fromSnapshot(snapshot);
          print('user');
          print(user.username);
          userList.add(user);
        }
      });
    }
    // print('userList');
    // print(userList);
    // log(TAG + 'Contacts Found ${userList.length}');
    return userList;
  }

  Future<void> markMsgRead({required chatId, required messageId}) async {
    await FirebaseUtils.getChatListColRef()
        .doc(chatId)
        .collection(KeyConstants.MESSAGE)
        .doc(messageId)
        .update({KeyConstants.SEEN: true}).catchError((onError) {});
  }

  Future<void> markGroupMsgRead({required chatId, required messageId}) async {
    await FirebaseUtils.getGroupListColRef()
        .doc(chatId)
        .collection(KeyConstants.MESSAGE)
        .doc(messageId)
        .update({KeyConstants.SEEN: true}).catchError((onError) {});
  }

  Future<UserModel> getCurrentUserModel() =>
      FirebaseUtils.getUsersColRef().doc(UserServices.userId).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });
}
