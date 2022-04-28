// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/utils/firebase_utils.dart';

class GameService {
  Future<String> createGameRoom(
      {required List<String> userIds,
      required String game,
      required String groupId //=> put in groupList.doc
      }) async {
    // print('userIds');
    // print(userIds); // [SZZzDRzMdEf2TlnoFdaY3s8W43f1] or [z0a5E7N4P3d5NXAyHVexXbZn9xB2, SZZzDRzMdEf2TlnoFdaY3s8W43f1]
    // print('game');
    // print(game); // snakeLadder
    // print('groupId');
    // print(groupId); // JUsrs6mPF0G05PMYcBaz
    // print(UserServices.userId); // SZZzDRzMdEf2TlnoFdaY3s8W43f1
    if (userIds.contains(UserServices.userId)) {
    } else {
      userIds.add(UserServices
          .userId);
    }
    //! Saves in Games. Why we use games folder?
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection(KeyConstants.GAME).add({
      'players': userIds,
      // Game Changed
      KeyConstants.GAME: game,
      KeyConstants.CREATED_AT: Timestamp.now()
    });
    //!
    FirebaseUtils.getGroupListColRef()
        .doc(groupId)
        .update({'players': userIds, 'gameName': game, 'gameId': docRef.id});
    return docRef.id;
  }

  void updateGame(String gameName, String groupId) {
    FirebaseUtils.getGroupListColRef().doc(groupId).update({
      // 'players': userIds,
      // CHANGED
      'gameName': gameName,
      // 'gameId': docRef.id
    });
  }

  void deleteGame(String gameId, String chatId) {
    FirebaseUtils.getGroupListColRef()
        .doc(chatId)
        .update({'gameId': '', 'players': [], 'gameName': ''});
    FirebaseUtils.getGameColRef().doc(gameId).delete();
  }
}
