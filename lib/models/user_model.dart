import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';

class UserModel {
  String number = "0";
  String id = "0";
  Timestamp createdAt = Timestamp.now();
  String imageUrl = "";
  bool online = false;
  Timestamp lastSeen = Timestamp.now();
  String username = "";
  bool isEngaged = false;

//  getters
  // String get number => number;
  // String get id => _id;
  // Timestamp get createdAt => _createdAt;
  // String get image => _imageUrl;
  // bool get online => _online;
  // Timestamp get lastSeen => _lastSeen;
  // String get username => _username;
  // bool get isEngaged => _isEngaged;

  UserModel();

  UserModel.fromSnapshot(DocumentSnapshot? snapshot) {
    Map<String, dynamic>? data = snapshot?.data() as Map<String, dynamic>?;
    number = data?[KeyConstants.NUMBER];
    id = data?[KeyConstants.ID];
    createdAt = data?[KeyConstants.CREATED_AT];
    imageUrl = data?[KeyConstants.IMAGE_URL];
    online = data?[KeyConstants.ONLINE];
    lastSeen = data?[KeyConstants.LAST_SEEN];
    username = data?[KeyConstants.USER_NAME];
    isEngaged = data?[KeyConstants.ISENGAGED];
  }
}
