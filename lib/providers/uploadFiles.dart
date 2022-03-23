// ignore_for_file: prefer_const_constructors

/*
selectFiles: 
uploadFiles: 
*/

import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class selectAndUploadFiles extends StatefulWidget {
  const selectAndUploadFiles({Key? key}) : super(key: key);

  @override
  State<selectAndUploadFiles> createState() => _selectAndUploadFilesState();
}

File? file;

class _selectAndUploadFilesState extends State<selectAndUploadFiles> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          fileName,
          style: TextStyle(fontSize: 20),
        ),
        task != null ? buildUploadStatus(task!) : Container()
      ],
    );
  }

  buildUploadStatus(UploadTask task) {
    StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentage = (progress * 100).toStringAsFixed(2);
          return Text(
            '$percentage %',
            style: TextStyle(fontSize: 20),
          );
        } else {
          return Container();
        }
      },
    );
  }

  final fileName = file != null ? basename(file!.path) : 'No File Selected';
  Future selectFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    // Get path of this file
    final path = result.files.single.path!; // Bcoz single file
    setState(() {
      file = File(path);
    });
  }

  UploadTask? task;
  Future uploadFile() async {
    if (file == null) return;
    final String fileName = basename(file!.path);
    final destination = 'files/$fileName';
    // task is the downloadLink
    task = uploadTaskFile(destination, file!);
    setState(
        () {}); // so that UI rebuilds and streambuilder shows upload complete
    if (task == null) return;
    final TaskSnapshot snapshot = await task!
        .whenComplete(() {}); // returns snapshot when download is completed
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');
  }

  static UploadTask? uploadTaskFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadTaskBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
