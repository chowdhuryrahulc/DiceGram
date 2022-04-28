// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/providers/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'group/group_chat_screen.dart';

class NewGroupProfile extends StatefulWidget {
  static const Color bagroundColor = Color(0xffFA3E0E);
  final List<UserModel> users;

  NewGroupProfile({Key? key, required this.users}) : super(key: key);

  @override
  State<NewGroupProfile> createState() => _NewGroupProfileState();
}

class _NewGroupProfileState extends State<NewGroupProfile> {
  final _formKey = GlobalKey<FormState>();
  final focusl = FocusNode();
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final GroupProvider watchprovider = context.watch();
    final GroupProvider readprovider = context.read();
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        child: const Icon(Icons.arrow_forward),
        onPressed: () {
          if (controller.text.characters.length < 3) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add valid Group name')));
          } else {
            readprovider.updateGroupName(controller.text);
            readprovider.createGroup(widget.users, context);
          }
        },
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0.h,
              left: 0.w,
              right: 0.w,
              child: Container(
                height: 150.h,
                width: double.infinity,
                decoration:
                    const BoxDecoration(color: NewGroupProfile.bagroundColor),
              )),
          Positioned(
            top: 50.h,
            left: 5.w,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          Positioned(
            top: 65.h,
            left: 55.w,
            child: Text(
              'New Group',
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Positioned(
              top: 125.h,
              left: 115.w,
              child: SizedBox(
                height: 100.h,
                width: 110.w,
                child: watchprovider.imageprofile != null
                    ? Image.file(
                        watchprovider.imageprofile!,
                        fit: BoxFit.fitHeight,
                        // alignment: FractionalOffset.topCenter,
                      )
                    : Container(
                        height: 110.h,
                        width: 110.w,
                        color: Colors.grey[300],
                      ),
              )),
          Positioned(
              top: 205.h,
              right: 135.w,
              child: GestureDetector(
                  onTap: () async {
                    //todo sending image
                    readprovider.handleURLButtonPress(
                      context,
                    );
                  },
                  child: Image.asset('assets/images/camera.png'))),
          Positioned(
            left: 0,
            right: 0,
            top: 160.h,
            child: Column(
              children: [
                SizedBox(
                  height: 90.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black38.withOpacity(0.2),
                            blurRadius: 2,
                            spreadRadius: 2)
                      ],
                      color: const Color(0xffE7EBF0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    //todo TextFormField validator
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                          focusNode: focusl,
                          controller: controller,
                          decoration: InputDecoration(
                              label: Text('Group Name'),
                              contentPadding: EdgeInsets.only(left: 20.w),
                              border: InputBorder.none)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 310.h,
              left: 15.w,
              child: Text(
                'Players : ${widget.users.length}',
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
          Positioned(
              top: 300.h,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 400.h,
                child: ListView.builder(
                    itemCount: widget.users.length,
                    itemBuilder: (context, index) {
                      final data = widget.users[index];
                      // usersList.add(users);
                      // if (users.id != userId)
                      {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width.w * 0.1,
                                  height: width.w * 0.1,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(width.w * 0.1),
                                    child: Image.network(
                                      data.imageUrl.toString(),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.network(
                                            'https://picsum.photos/250?image=9');
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                SizedBox(
                                    width: width.w * 0.7,
                                    child: Text(
                                      data.username.toString(),
                                      maxLines: 1,
                                    )),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
              ))
        ],
      ),
    );
  }
}
