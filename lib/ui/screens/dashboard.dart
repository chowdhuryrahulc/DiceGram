// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/gameIdProblem.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/ui/screens/chatroom.dart';
import 'package:dicegram/ui/screens/newGroupAddParticipants.dart';
import 'package:dicegram/ui/screens/InvitePage.dart';
import 'package:dicegram/ui/screens/group/create_group_screen.dart';
import 'package:dicegram/ui/screens/group/dashboardGroups.dart';
import 'package:dicegram/ui/widgets/nav_drawer.dart';
import 'package:dicegram/utils/app_constants.dart';
import 'package:dicegram/utils/dimensions.dart';
import 'package:dicegram/utils/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
import 'dashboardChats.dart';

var status;

checkPhoneNumberinFirebaseCollectionandReturnBool(
    {required String phoneNumber,
    required String username,
    required Map<String, dynamic> values,
    required BuildContext context}) async {
  bool isPresent = false;
  var x = await FirebaseFirestore.instance
      .collection(KeyConstants.USERS)
      .where('number', isEqualTo: phoneNumber)
      .get();
  if (x.size > 0) {
    isPresent = true;

    UserServices().updateUserData({'username': username}).then((val) {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const Dashboard(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    });
  } else {
    UserServices().createUser(values).then((val) {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const Dashboard(),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    });
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  bool isChatSelected = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setOnline(true);
    } else {
      setOnline(false);
    }
  }

  void setOnline(bool isOnline) async {
    try {
      await FirebaseUtils.getUsersColRef()
          .doc(UserServices.userId)
          .update({KeyConstants.ONLINE: isOnline});
    } catch (e) {
      print(e);
    }
  }

//! permission error
  permissionContacts() async {
    status = await Permission.contacts.request();
    print(status);
    // UserServices()
    // checkPhoneNumberinFirebaseCollectionandReturnBool('+917020687305');

    // if (status?.isDenied) {
    //   print('Status Denied');
    // } else if (status!.isGranted) {
    //   print('Status Granted');
    // }
  }

  @override
  void initState() {
    super.initState();
    permissionContacts();
    WidgetsBinding.instance?.addObserver(this);
    fetchAllFirebaseContats();
    setOnline(true);
  }

  @override
  Widget build(BuildContext context) {
    String? h = context.watch<updateGroup>().newName;
    String userName = 'User Name';
    String? profileImage;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: FutureBuilder<UserModel>(
        // userID is uid from Firebase.
        future: UserServices().getUserById(UserServices.userId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data?.username != null) {
            userName = snapshot.data!.username;
          }
          profileImage = snapshot.data?.imageUrl;
          return Scaffold(
            drawer: NavDrawer(),
            appBar: AppBar(
              shadowColor: Colors.transparent,
              leading: Builder(builder: (context) {
                return InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: profileImage != null
                            ? Image.network(
                                profileImage!,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      'assets/images/person.png');
                                },
                              )
                            : Image.asset('assets/images/person.png')),
                  ),
                );
              }),
              title: Text(
                userName,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              actions: [
                InkWell(onTap: () {}, child: const Icon(Icons.search)),
                // PopupMenuButton(
                //   icon: const Icon(Icons.more_vert),
                //   onSelected: (value) {
                //     if (value == 3) {
                //       Navigator.of(context).push(MaterialPageRoute(
                //           builder: (context) =>
                //               const ChatRooms(roomId: 'result')));
                //     }
                //   },
                //   itemBuilder: (context) => [
                //     PopupMenuItem(
                //       child: TextButton(
                //         onPressed: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => CreateGroupScreen()));
                //         },
                //         child: const Text('Contacts'),
                //       ),
                //     ),
                //     // const PopupMenuItem(
                //     //   value: 2,
                //     //   child: Text("What"),
                //     // ),
                //     // const PopupMenuItem(
                //     //   value: 3,
                //     //   child: Text("You Want?"),
                //     // ),
                //   ],
                // ),

                SizedBox(
                  width: 8.w,
                )
              ],
            ),
            body: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: TabBar(
                    indicatorColor: Colors.white,
                    indicatorPadding: EdgeInsets.zero,
                    indicatorWeight: 10,
                    padding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (index) {
                      setState(() {
                        isChatSelected = (index == 0);
                      });
                    },
                    tabs: const [
                      Tab(
                        child: Text(
                          AppConstants.chats,
                          style: TextStyle(
                              fontSize: Dimen.fontXL,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppConstants.groups,
                          style: TextStyle(
                              fontSize: Dimen.fontXL,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                body: const TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    DashboardChats(),
                    DashboardGroups(),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    if (status == PermissionStatus.granted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => isChatSelected
                                  ? InvitePage()
                                  : NewGroupAddParticipants())); // Create group
                    } else {
                      var snackBar = SnackBar(
                          content: Text('Contacts Permission Required'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: isChatSelected
                      ? const Icon(Icons.chat)
                      : const Icon(Icons.add),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
