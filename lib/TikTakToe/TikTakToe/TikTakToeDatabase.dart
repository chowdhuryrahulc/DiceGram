// import 'dart:html';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class TikTakToeDatabase {
  getTikTakToeData(String chatRoomId) async {
    //TODO COPY OF GETCONVERSATIONMESSAGE
    // Gives stream of database data
    return FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("tikTakToeDynamic")
        // .orderBy("time", descending: false)
        .snapshots();
  }

//TODO messageMap needs to change to the TikTakToe game
  sendTikTakToeData(String chatRoomId, messageMap) {
    //TODO COPY OF addCONVERSATIONMESSAGE
    FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("tikTakToe")
        //todo add or update
        .add(messageMap)
        .catchError((e) {});
  }

//TODO PLAYERLIST DATA
  Future<String> getPlayerListData(String chatRoomId, int id) async {
    print('INSIDE PLAYERS');
    String zeroKata;
    DocumentSnapshot<Map<String, dynamic>> x = await FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("buttonListData")
        // int id.toString()
        .doc(id.toString())
        .get();
    zeroKata = x.data()!["text"];
    return zeroKata;
  }

  sendPlayerListData(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("buttonListData")
        .add(messageMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getButtonData(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("buttonListData")
        .snapshots();
  }

  sendGameButtonData(String chatRoomId, messageMap, int gameId) {
    FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("buttonListData")
        .doc(gameId.toString())
        .set(messageMap)
        .catchError((e) {
      print(e);
    });
  }

  updateGameButtonData(String chatRoomId, messageMap, int gameId) {
    FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("buttonListData")
        .doc(gameId.toString())
        .update(messageMap);
  }

  updateActivePlayerInFirestore(Map<String,String> activePlayerMap, String chatRoomId) {
    // Map<String, dynamic> activePlayerMap = {'activePlayer': activePlayer};
    FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("ActivePlayer")
        .doc('active')
        .update(activePlayerMap);
    // .add(activePlayer);
  }

  saveActivePlayerInFirestore(var activePlayerMap, String chatRoomId) {
    FirebaseFirestore.instance
        .collection("GameRoom")
        .doc(chatRoomId)
        .collection("ActivePlayer")
        .doc('active')
        .set(activePlayerMap);
    // .add(activePlayer);
  }

  getActivePlayerData(String chatRoomId) async {
    String active;
    DocumentSnapshot<Map<String, dynamic>> x = await FirebaseFirestore.instance
        .collection('GameRoom')
        .doc(chatRoomId)
        .collection("ActivePlayer")
        .doc('active')
        .get();

    print(x.data()!['activePlayer']);
    active = x.data()!['activePlayer'];
    return active;
  }

  getStreamOfActivePlayerData(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('GameRoom')
        .doc(chatRoomId)
        .collection("ActivePlayer")
        .doc('active')
        .snapshots();
  }
  

}
