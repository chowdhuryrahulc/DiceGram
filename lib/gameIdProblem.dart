// ignore_for_file: avoid_print

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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:flutter/material.dart';

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
  try {
    print('players');
    print(result.docs.length);
    print(result.docs[0]['players'][2]);
    return result.docs[0]['players'][2];
  } catch (e) {
    return null;
  }
}

//Working: when the first person plays.
// playerList: uid1, uid2, gameID
//! INTEGRATED
addFieldsofUsersInGameRoom(List<String> playerList, String gameId) {
  for (var i = 0; i < playerList.length; i++) {
    setIsEngagedToTrue(playerDocId: playerList[i], boolToSet: true);
  }
  // print("playerList.length");
  // print(playerList.length);
  playerList.add(gameId);

  FirebaseFirestore.instance.collection("GameRoom").doc(gameId).set({
    'players': playerList,
  }).whenComplete(() {
    // print('cleared');
    playerList.remove(gameId);
    // playerList.remove(UserServices.userId);
  });
}

//Working, to be placed in Exit button.
//! INTEGRATED
deletePresentUserFromGameRoom(String gameId) async {
  // print(gameId);
  // print(UserServices.userId);
  try {
    await FirebaseFirestore.instance.collection('GameRoom').doc(gameId).update({
      'players': FieldValue.arrayRemove([UserServices.userId])
    }).whenComplete(() {
      print('Compleated');
    });
  } catch (e) {
    print(e);
  }
  setIsEngagedToTrue(playerDocId: UserServices.userId, boolToSet: false);
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
  print("playerDocId");
  print(playerDocId);
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
