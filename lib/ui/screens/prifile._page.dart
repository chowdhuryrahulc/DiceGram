// ignore_for_file: prefer_const_constructors

import 'package:dicegram/main.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/providers/profile_provider.dart';
import 'package:flutter/material.dart';
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
    final ProfileProvider watchprovider = context.watch<ProfileProvider>();
    final ProfileProvider readprovider = context.read<ProfileProvider>();

    func() {
      setState(() {});
    }

    ;
    UserModel? userModel;
    return StreamBuilder<UserModel>(
        stream: watchprovider.getCurrentUserModel().asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          userModel = snapshot.data;
          print('userModel?.image');
          print(userModel?.image);
          // context.read<profilePicProvider>().updateProfilePic(userModel?.image);
          // profilePicProvider()
          return Scaffold(
            body: Stack(
              children: [
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration:
                          const BoxDecoration(color: ProfilePage.bagroundColor),
                    )),
                Positioned(
                  top: 50,
                  left: 5,
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
                const Positioned(
                  top: 65,
                  left: 55,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Positioned(
                    top: 125,
                    left: 115,
                    child: SizedBox(
                        height: 100,
                        width: 110,
                        child: Image.network(
                          userModel?.image ?? '',
                          errorBuilder: (context, error, stackTrace) {
                            print('Extra ${userModel?.image.toString()}');
                            return Image.asset('assets/images/person.png');
                          },
                        ))),
                Positioned(
                    top: 205,
                    right: 135,
                    child: GestureDetector(
                        onTap: () async {
                          // This opens the showDialog.
                          watchprovider.showDialogToFetchProfilePic(
                              context, func());
                          //! need SetState
                          // setState(() {});
                        },
                        child: Image.asset('assets/images/camera.png'))),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 160,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userModel?.username ?? 'UserName',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(
                            width: 5,
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
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${userModel?.number}',
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
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
