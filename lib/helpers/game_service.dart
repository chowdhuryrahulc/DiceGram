import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/utils/firebase_utils.dart';

class GameService {
  Future<String> createGameRoom(
      {required List<String> userIds,
      required String game,
      required String groupId}) async {
    userIds.add(UserServices.userId);
    DocumentReference docRef = await FirebaseUtils.getGameColRef().add({
      'players': userIds,
      // Game Changed
      KeyConstants.GAME: game,
      KeyConstants.CREATED_AT: Timestamp.now()
    });
    FirebaseUtils.getGroupListColRef().doc(groupId).update({
      'players': userIds,
      // CHANGED
      'gameName': game,
      'gameId': docRef.id
    });
    return docRef.id;
  }

  void deleteGame(String gameId, String chatId) {
    FirebaseUtils.getGroupListColRef()
        .doc(chatId)
        .update({'gameId': '', 'players': [], 'gameName': ''});
    FirebaseUtils.getGameColRef().doc(gameId).delete();
  }
}
