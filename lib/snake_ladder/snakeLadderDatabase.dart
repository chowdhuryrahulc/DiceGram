import '../utils/firebase_utils.dart';

storeDataInFirebase(String gameId, Map<String, int> updatePositionData){
  FirebaseUtils.getGameColRef()
        .doc(gameId)
        .collection('game')
        .doc(gameId).update(updatePositionData)
      //   .listen((event) {
      // if (event.docs.isNotEmpty) {
      //   _currentDiceOne = event.docs[0]["currentDiceOne"];
      //   _totalPlayerOne = event.docs[0][p1];
      //   _currentPlayer = event.docs[0]["currentPlayer"] == p1 ? 1 : 2;
      //   _totalPlayerTwo = event.docs[0][p2];
      // }
    // }
    // )
    ;
}