import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/group_service.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/group_data.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/ui/screens/group/group_chat_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class GroupProvider extends ChangeNotifier {
  List<String> _grouppeople = [];
  List<String> get models => _grouppeople;
  String _groupname = 'Group Name';
  String get groupName => _groupname;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestoreCloud = FirebaseFirestore.instance;
  final String collectionname = 'groupimage';
  final String docname = 'user1';
  static const Color buttoncolor = Color(0xffFF7043);
  final imagePicker = ImagePicker();
  String _imageUrl = '';
  String get imageUrl => _imageUrl;
  File? imageprofile;
  String? username;

//v

  void updateGroupName(String name) {
    _groupname = name;
    notifyListeners();
  }

  void addList(String id) {
    _grouppeople.add(id);
    notifyListeners();
  }

  void remove(String id) {
    _grouppeople.remove(id);
    notifyListeners();
  }

  void dispose1() {
    _grouppeople = [];
    notifyListeners();
  }

  void createGroup(List<UserModel> users, BuildContext context) {
    List<String> userIds = [];
    users.forEach((element) {
      userIds.add(element.id);
    });
    userIds.add(UserServices.userId);

    GroupService()
        .createGroup(
            groupData: GroupData(
      adminId: UserServices.userId,
      users: userIds,
      groupName: groupName,
      imageUrl: imageUrl,
      createdAt: Timestamp.now(),
      players: [],
      gameId: '',
      gameName: '',
      isGroup: true,
    ))
        .then((value) {
      GroupService().sendGroupMessage(
          message: 'New Group Created',
          groupId: value.id,
          msgType: KeyConstants.GROUPCREATED);

//todo uploadPic
      if (imageprofile != null) {
        uploadPic(imageprofile!, value.id);
      }

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GroupChatScreen(
                //! might break?
                adminId: UserServices.userId,
                groupData: GroupData(
                  adminId: UserServices.userId,
                  users: userIds,
                  groupName: groupName,
                  imageUrl: imageUrl,
                  createdAt: Timestamp.now(),
                  players: [],
                  gameId: '',
                  gameName: '',
                  isGroup: true,
                ),
                chatId: value.id,
              )));
    }).onError((error, stackTrace) {});
  }

  void handleURLButtonPress(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          XFile? image = await imagePicker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 50,
                              preferredCameraDevice: CameraDevice.front);
                          if (image != null) {
                            _cropImage(image.path, context);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Pick From Camera')),

                    TextButton(
                        onPressed: () async {
                          XFile? image = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 50,
                          );
                          if (image != null) {
                            _cropImage(image.path, context);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Pick From Gallery'))
                    // : const Text('Pick From Gallery')),
                  ],
                )
              ],
            ));
  }

  void _cropImage(filePath, BuildContext context) async {
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      // maxWidth: 1080,
      // maxHeight: 1080,
    );
    if (croppedImage != null) {
      imageprofile = croppedImage;
      print("Image Profile ${imageprofile}");
      notifyListeners();

      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }
  }
  //!firebase upload

//todo match this with profileProvider uploadpic.
  Future<String> uploadPic(File imagefi, String groupDocomentId) async {
    final destination = groupDocomentId;
    final reference = FirebaseStorage.instance.ref(destination);
    final UploadTask uploadTask = reference.putFile(imagefi);
    final TaskSnapshot location = await uploadTask.whenComplete(() {});
    final String url = await location.ref.getDownloadURL();
    _imageUrl = url;
    notifyListeners();
    uploadToCLoudstorege(url, groupDocomentId);
    return url;
  }

//
  Future uploadToCLoudstorege(String url, String groupDocomentId) async {
    //todo save in the imageUrl.
    FirebaseFirestore.instance
        .collection('Group List')
        .doc(groupDocomentId)
        .update({'imageUrl': url});
  }
}
