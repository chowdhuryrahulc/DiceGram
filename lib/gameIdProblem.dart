// ignore_for_file: avoid_print, camel_case_types

/*
Q1) How do we get the same gameId in both the devices?
  we store the gameId in the GameRoom.gameId and use the same gameId as a doc in GameRoom.
  So each group has a unique gameId.
  But gameId can be multiple ri8? Bcoz 2 or more players might be playing the game.

Reason it was not working:
  bcoz when we click on next, a new gameId is created. Then the old player cant play, bcoz he has the old gameId.
  Remidy is there, to show the client. but not work in real app.
*/

/*
Solution:
  use a array of gameIds. Means GameRoom.gameId [Player1idPlayer2idGameid, ..., ...,]. 
    if already existed, then just update. Otherwise add. 
    Gameroom=> uid1uid2gameid=> sl, tik
  Then how will we match? Bcoz currently it is stored in gameId. We can do it. 
  Make groupId gameId. thatway it becomes unique. Not getting generated everytime. 
    Where? in groupChatScreen lineNo334. 
  //Delete when player leaves the game. If not found, show player has left.
  // Retrieve: search in GameRoom=> doc(user1user2groupid)
  //   Search in doc() using ...
  Retrieve: FirebaseFirestore.instance.collection("users").doc(uid1uid2groupid) => hardcoaded
  
  Problem: How will it ser


*/

/*
LOGIC:
Store in GameRoom => gameID => Game/ User1, User2 : 
             // in snakeLadderDatabase and snake_ladder
2nd player screen: ifEngaged => search GameRoom /users. Else show 3 buttons. isInitilized = true.
inUsers, store isEngaged = true/false. Whenever player added, isEngaged = true.
If player leaves, isEngaged = false.
Whenever the player clicks on end button, the Game/userId should be deleted. Then check if the user list is empty, then delete the id.

Q1) How do we get the same gameId in both the devices?
Sol: by searching the database. GameRoom /users.
Q2) What all methords do we need?

*/

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/group_data.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/ui/screens/group/group_chat_screen.dart';
import 'package:dicegram/utils/firebase_utils.dart';
import 'package:flutter/material.dart';

/*
Logic:
  showing: 
  select and delete.
*/

/*
Problem: How it is working in groupChat, 
  but not in singleChat?
  In groupChat, we used to search if the user is present in GameRoom and then use that gameId. 
  In ChatScreen, we use chatId as gameId. 

*/

//! Another problem is, that widget.players[2]=> changes if the user presses the endButton.

/*
gameId changes but chatId doesnt.
put in chatList, isPlaying.
  End: not playing
Play with just 1 Id. update everytime.
Methords needed:
    getChatRoomIsPlayingData in chat_screen. If yes, gameInnitilized is true, else false.
    setIsPlaying(){} => true while creating game(getSelectedGame). false in EndButton


this will cause the game to start. Now what data do we send in SnakeLadder?
And what methords are not needed?
Problem: usersList might keep on adding chatroomIds. And do we even need that? No we dont, we already have it.

AdminEnd: Starts game, isPlaying(in Chat_List) set to true, isEngaged set to true (in addFieldsofUsersInGameRoom)
CustomerEnd: 
*/

class circularProgressIndicatorController extends ChangeNotifier {
  bool showProgressIndicator = false;
  updateCircularProgressIndictor(bool b) {
    showProgressIndicator = b;
    print('showProgressIndicator updated ${showProgressIndicator}');
    notifyListeners();
  }
}

class addPlayerProvider extends ChangeNotifier {
  List<String> userModelList = [];
  addUserModelToUserModelList(String y) {
    userModelList.add(y);
    notifyListeners();
  }

  removeUserModelToUserModelList(String y) {
    userModelList.remove(y);
    notifyListeners();
  }
}

class updateGroup extends ChangeNotifier {
  String? newName;
  update(String x) {
    newName = x;
    // log('NewName');
    log(newName!);
    notifyListeners();
  }
}

class providerTest extends ChangeNotifier {
  List<UserModel> userModelList = [];
  addUserModelToUserModelList(UserModel y) {
    userModelList.add(y);
    notifyListeners();
  }

  removeUserModelToUserModelList(UserModel y) {
    userModelList.remove(y);
    notifyListeners();
  }
}

//Working
setIsPlaying({required String chatDocId, required bool boolToSet}) {
  try {
    FirebaseFirestore.instance
        .collection('Chat List')
        .doc(chatDocId)
        .update({'isPlaying': boolToSet});
  } catch (e) {}
  log('Errors');
  // print(e);
}

streamToGetSnapshotOfChatListUserData(String chatId) {
  return FirebaseFirestore.instance
      .collection('Chat List')
      .doc(chatId)
      .snapshots();
}

updateGroupName(String docId, String newGroupName) {
  FirebaseFirestore.instance
      .collection('Group List')
      .doc(docId)
      .update({'groupName': newGroupName});
}

// Working
Future<List<String>> returnUserNameFromUserId(List<String> listOfUsers) async {
  List<String> userNameList = [];
  try {
    for (var i = 0; i < listOfUsers.length; i++) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(listOfUsers[i])
          .get()
          .then((value) {
        // print(value['username']);
        userNameList.add(value['username']);
      });
    }
  } catch (e) {}
  return userNameList;
}

// Working
deleteUserFromGroup(String groupId, List<String> idOfPlayer) async {
  try {
    await FirebaseFirestore.instance
        .collection('Group List')
        .doc(groupId)
        .update({'users': FieldValue.arrayRemove(idOfPlayer)}).whenComplete(() {
      print('Compleated');
    });
  } catch (e) {
    print(e);
  }
}

// Working
addUsersInGroup(String groupId, List<String> idOfNewPlayer) async {
  try {
    await FirebaseFirestore.instance
        .collection('Group List')
        .doc(groupId)
        .update({'users': FieldValue.arrayUnion(idOfNewPlayer)}).whenComplete(
            () {
      print('Compleated');
    });
  } catch (e) {
    print(e);
  }
}

//! join the player in the existing game?
//! pull the docomentId and put it in the gameId in SnakeLadder game. It will work.

// put docId inside players. InNextButton,
// fetch is done.

/*
if the other person quits, isEngaged of other person changes to false.
if it does, show dialog. To be done in snakeLadder.dart. Use streamBuilder. 
*/

// showDialog(context: (context), builder: (ctx){
//             return AlertDialog(
//             title: Text(
//               'nameOfWinner Has left the game. Do you want to end the game?',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.black54),
//             ),
//             backgroundColor: Colors.orange[100],
//             elevation: 10,
//             actions: [
//               TextButton(
//                   onPressed: () => {
//                         Navigator.of(context).pop(),
//                       },
//                   child: Text(
//                     "No",
//                     style: TextStyle(color: Colors.black),
//                   )),
//               TextButton(
//                   onPressed: () => {
//                         Navigator.of(context).pop(),
//                         initFunc() // this
//                       },
//                   child: Text(
//                     "Yes",
//                     style: TextStyle(color: Colors.black),
//                   )),
//             ],
//           );
//           })

// print(x);

// Stream
knowIfOtherPersonHasLoggedOut() {
  var x = FirebaseFirestore.instance
      .collection('GameRoom')
      .where("players",
          arrayContains: UserServices.userId // user1 id in place of a
          )
      .snapshots();
  print('aaaaaaaaaaaaaaaaaa');
  print(x);
}

futuretoSearchIfPlayerIsPresentInAnyGroupAndFetchDocomentIdofThatGroup() async {
  return await FirebaseFirestore.instance
      .collection('GameRoom')
      .where("players",
          arrayContains: UserServices.userId // user1 id in place of a
          )
      .get();
}

//Working: put in
//! INTEGRATED
Future<String?>
    searchIfPlayerIsPresentInAnyGroupAndFetchDocomentIdofThatGroup() async {
  QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance
      .collection('GameRoom')
      .where("players",
          arrayContains: UserServices.userId // user1 id in place of a
          )
      .get()
      .whenComplete(() {});
  if (result.docs.isEmpty) {
    log('isEmpty');
  } else {
    try {
      return result.docs[0]['players'][2];
    } catch (e) {
      return null;
    }
  }
  // try {
  //   print('players');
  //   print("resultDocLength ${result.docs.length}");
  //   print('Result $result');
  //   print("players2: ${result.docs[0]['players'][0]}");
  //   return result.docs[0]['players'][0];
  // } catch (e) {
  //   log('User is not present in GameRoom, null returned.');
  //   print(e);
  //   return null;
  // }
}

//Working: when the first person plays.
//! INTEGRATED
addFieldsofUsersInGameRoom(List<String> playerList, String gameId) {
  for (var i = 0; i < playerList.length; i++) {
    setIsEngagedToTrue(playerDocId: playerList[i], boolToSet: true);
  }
  if (playerList.contains(gameId)) {
  } else {
    playerList.add(gameId);
  }
  // playerList.reversed;

  FirebaseFirestore.instance.collection("GameRoom").doc(gameId).set({
    'players': playerList,
  }).whenComplete(() {
    //todo commented 8pm 31 March
    // playerList.remove(gameId);
  });
}

//Working, to be placed in Exit button.
//! INTEGRATED
deletePresentUserFromGameRoom(String gameId) async {
  try {
    await FirebaseFirestore.instance.collection('GameRoom').doc(gameId).update({
      'players': FieldValue.arrayRemove([UserServices.userId])
    }).whenComplete(() {
      print('Compleated');
    });
    setIsEngagedToTrue(playerDocId: UserServices.userId, boolToSet: false);
  } catch (e) {
    log('This Is ErrorZone');
    print(e);
  }
//  await FirebaseFirestore.instance.collection('GamesRoom').doc(gameId).update({
//     'players': FieldValue.arrayRemove([UserServices.userId])
//   }).whenComplete(() {
//     print('Compleated');
//   });
}

// // Working, after checking if the number of users in null
// removeGameIdDocomentWhenUsersisEmpty() {
//   FirebaseFirestore.instance.collection('Games').doc('0rDGug1Cq2fRrwGqb7XI').delete();
// }
// //
// checkNumberOfUsersinDatabase() {
//   // FirebaseFirestore.instance.collection('Games').doc('0rDGug1Cq2fRrwGqb7XI').c
// }
// DONE
addAllIsEngagedtoFalse() {} // add in model and also in firebase manually

//! get in next working. Set, Where?
// selectedList.
// Working
setIsEngagedToTrue({required String playerDocId, required bool boolToSet}) {
  FirebaseFirestore.instance
      .collection('users')
      .doc(playerDocId)
      .update({'isEngaged': boolToSet});
}

// Working
// searchIsEngagedTrueorFalse() {
//   FirebaseFirestore.instance
//       .collection('users')
//       .doc('8ffhjaxUjgd2ZmYtcFjVaqZuaix1')
//       .get()
//       .then((value) {
//     return value.data()!['online'];
//   });

//     .update({
//   'players': FieldValue.arrayRemove(['SZZzDRzMdEf2TlnoFdaY3s8W43f1'])
// }).whenComplete(() {
//   print('Compleated');
// });
// }

// playerStatus 0/1
// Winners:

fetchAllFirebaseContats() {
  return FirebaseUtils.getUsersColRef().get();
}
