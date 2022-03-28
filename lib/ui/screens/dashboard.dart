// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/gameIdProblem.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/ui/screens/chatroom.dart';
import 'package:dicegram/ui/screens/newGroupAddParticipants.dart';
import 'package:dicegram/ui/screens/contacts.dart';
import 'package:dicegram/ui/screens/group/create_group_screen.dart';
import 'package:dicegram/ui/screens/group/group_list.dart';
import 'package:dicegram/ui/widgets/nav_drawer.dart';
import 'package:dicegram/utils/app_constants.dart';
import 'package:dicegram/utils/dimensions.dart';
import 'package:dicegram/utils/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
import 'chat_list2.dart';

var status;

checkPhoneNumberinFirebaseCollectionandReturnBool(
    {required String phoneNumber,
    required Map<String, dynamic> values,
    required BuildContext context}) async {
  print('OOOOOOOOOOOOOOOOOOOOOOOOOO');
  print(values['isEngaged']); //! Showing null
  print(values['username']);
  bool isPresent = false;
  var x = await FirebaseFirestore.instance
      .collection(KeyConstants.USERS)
      .where('number', isEqualTo: phoneNumber)
      .get();
  if (x.size > 0) {
    isPresent = true;

    UserServices().updateUserData(values).then((val) {
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
    setOnline(true);
  }

  @override
  Widget build(BuildContext context) {
    String userName = 'User Name';
    String? profileImage;
    // showDialogIfOtherPersonsEngagedIsFalse();
    // setIsEngagedToTrue();
    // knowIfOtherPersonHasLoggedOut();
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
          // we are getting this data from:
          // users=> imageURL
          // Setting this data in NavDrawer=> ProfilePage
          profileImage = snapshot.data?.image;
          return Scaffold(
            drawer: NavDrawer(),
            appBar: AppBar(
              shadowColor: Colors.transparent,
              leading: Builder(builder: (context) {
                return InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: profileImage != null
                            // Image not picking up.
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
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      // showDialogIfOtherPersonsEngagedIsFalse();
                    },
                    child: const Icon(Icons.search)),
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

                const SizedBox(
                  width: 8,
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
                    ChatList2(),
                    GroupList(),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    if (status == PermissionStatus.granted
                        // status.isGranted
                        ) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => isChatSelected
                                  ? ContactListScreen() // Create one to one chat.
                                  : ContactsScreen2())); // Create group
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
