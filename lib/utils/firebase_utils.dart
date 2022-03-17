import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/utils/utils.dart';

class FirebaseUtils extends Utils {
// Called
  static CollectionReference getUsersColRef() {
    return FirebaseFirestore.instance.collection(KeyConstants.USERS);
  }

  static CollectionReference getChatListColRef() {
    return FirebaseFirestore.instance.collection(KeyConstants.CHAT_LIST);
  }

// Called
  static CollectionReference getGroupListColRef() {
    return FirebaseFirestore.instance.collection(KeyConstants.GROUP_LIST);
  }

// used in SnakeLadder.dart
  static CollectionReference getGameColRef() {
    return FirebaseFirestore.instance.collection(KeyConstants.GAME);
  }
}
