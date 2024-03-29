// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/gameIdProblem.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/utils/firebase_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class ProfileProvider extends ChangeNotifier {
//fireabse
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestoreCloud = FirebaseFirestore.instance;
  final String collectionname = 'profileimage';
  final String docname = 'user1';
//
  static const Color buttoncolor = Color(0xffFF7043);
  final imagePicker = ImagePicker();
  File? imageprofile;
  String? username;

  void showDialogToFetchProfilePic(BuildContext context) {
    bool x =
        Provider.of<circularProgressIndicatorController>(context, listen: false)
            .showProgressIndicator;
    showDialog(
        context: context,
        builder: (context) => Provider.of<circularProgressIndicatorController>(
                    context,
                    listen: false)
                .showProgressIndicator
            ? Center(child: CircularProgressIndicator())
            : AlertDialog(
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            context
                                .read<circularProgressIndicatorController>()
                                .updateCircularProgressIndictor(true);
                            XFile? image = await imagePicker.pickImage(
                                source: ImageSource.camera,
                                imageQuality: 50,
                                preferredCameraDevice: CameraDevice.front);
                            if (image != null) {
                              _cropImage(image.path, context);
                            } else {
                            }
                          },
                          child: const Text('Pick From Camera')),
                      TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            context
                                .read<circularProgressIndicatorController>()
                                .updateCircularProgressIndictor(true);
                            XFile? image = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 50,
                            );
                            if (image != null) {
                              _cropImage(image.path, context);
                            } else {
                            }
                          },
                          child: const Text('Pick From Gallery'))
                    ],
                  )
                ],
              )).then((value) {});
  }

  void _cropImage(filePath, BuildContext context) async {
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      // maxWidth: 1080,
      // maxHeight: 1080,
    );
    if (croppedImage != null) {
      imageprofile = croppedImage;
      await uploadPic(imageprofile!).then((value) {
        print('Started Uploading');
      });
      notifyListeners();
      print('Upper crop Image');
    } else {
    }
  }

  Future<String> uploadPic(File imagefi) async {
    final destination = UserServices.userId;
    final reference = FirebaseStorage.instance.ref(destination);
    final UploadTask uploadTask = reference.putFile(imagefi);
    final TaskSnapshot location = await uploadTask.whenComplete(() {});
    final String url = await location.ref.getDownloadURL();
    uploadToCLoudstorege(url);
    return url;
  }

//
  Future uploadToCLoudstorege(String url) async {
    await _firestoreCloud
        .collection(KeyConstants.USERS)
        .doc(UserServices.userId)
        .update({KeyConstants.IMAGE_URL: url});
  }

  Future<UserModel> getCurrentUserModel() =>
      FirebaseUtils.getUsersColRef().doc(UserServices.userId).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });

  //Edit BUtton
  void handleEditButton(
    BuildContext context,
    TextEditingController controller,
  ) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 50,
          backgroundColor: Colors.transparent,
          actions: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20),
                          border: InputBorder.none)),
                ),
                Positioned(
                  top: 0,
                  left: 200,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      username = controller.text.trim();
                      UserServices().updateCurrentUserData(
                          {KeyConstants.USER_NAME: username});
                      notifyListeners();
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: MediaQuery.removePadding(
                        context: context,
                        child: Container(
                          height: 54,
                          width: 66,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: buttoncolor,
                          ),
                          child: const Center(
                              child: Text(
                            'Save',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
