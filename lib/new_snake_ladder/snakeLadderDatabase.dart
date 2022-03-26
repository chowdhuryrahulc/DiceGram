// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/firebase_utils.dart';

class snakeLadderDatabase {
  sendSnakeLadderPositionData(String gameRoomId, positionAndActivePlayerMap) {
    FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(gameRoomId)
        .collection("SnakeLadder")
        .doc(gameRoomId)
        .set(positionAndActivePlayerMap)
        .catchError((e) {
      print(e);
    });
  }

  getSnakeLadderPositionData(String gameRoomId) {
    return FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(gameRoomId)
        .collection("SnakeLadder")
        .doc(gameRoomId)
        .snapshots();
  }

  updateSnakeLadderPositionData(String gameRoomId, positionAndActivePlayerMap) {
    FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(gameRoomId)
        .collection("SnakeLadder")
        .doc(gameRoomId)
        .update(positionAndActivePlayerMap)
        .catchError((e) {
      print(e);
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>
      searchUserNamefromIdAndShowInSnakeLadderGame(String playerId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(playerId)
        .get();
    // return await x['username'];
  }

  Future<String?> searchUserNamefromIdAndShowWinner(String playerId) async {
    String x = await FirebaseFirestore.instance
        .collection("users")
        .doc(playerId)
        .get()
        .then((value) {
      return value.data()!['username'];
      // }
    });
    return x;
  }

//   getActivePlayerData(String gameRoomId) async {
//   String active;
//   QuerySnapshot<Map<String, dynamic>> x = await FirebaseFirestore.instance
//       .collection('GameRoom')
//       .doc(gameRoomId)
//       .collection("SnakeLadder")
//       .get();
//       //! return only active player data.
//   // .doc('active')
//   // .get();

//   // print(x.data()!['activePlayer']);
//   // active = x.data()!['activePlayer'];
//   // return active;
// }

}

storeDataInFirebase(String gameId, Map<String, int> updatePositionData) {
  FirebaseUtils.getGameColRef()
      .doc(gameId)
      .collection('game')
      .doc(gameId)
      .update(updatePositionData);
}
