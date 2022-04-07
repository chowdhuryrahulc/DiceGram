// ignore_for_file: prefer_const_constructors

import 'package:dicegram/main.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static const Color bagroundColor = Color(0xffFA3E0E);
  static const Color subtextcolor = Color(0xff979797);

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    ProfileProvider watchprovider = context.watch<ProfileProvider>();
    ProfileProvider readprovider = context.read<ProfileProvider>();
    UserModel? userModel;
    return FutureBuilder<UserModel>(
        future: watchprovider.getCurrentUserModel(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          userModel = snapshot.data;
          return Scaffold(
            body: Stack(
              children: [
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 150.h,
                      width: double.infinity,
                      decoration:
                          const BoxDecoration(color: ProfilePage.bagroundColor),
                    )),
                Positioned(
                  top: 50.h,
                  left: 5.w,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
                Positioned(
                  top: 65.h,
                  left: 55.w,
                  child: Text(
                    'Profile',
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
                        child: Image.network(
                          userModel?.imageUrl ?? '',
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/person.png');
                          },
                        ))),
                Positioned(
                    top: 205.h,
                    right: 135.w,
                    child: GestureDetector(
                        onTap: () async {
                          // This opens the showDialog.
                          watchprovider.showDialogToFetchProfilePic(context);
                        },
                        child: Image.asset('assets/images/camera.png'))),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 160.h,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userModel?.username ?? 'UserName',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.sp),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          GestureDetector(
                            onTap: () => readprovider.handleEditButton(
                              context,
                              controller,
                            ),
                            child: Image.asset('assets/images/edit.png'),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        '${userModel?.number}',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16.sp,
                            color: ProfilePage.subtextcolor),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
