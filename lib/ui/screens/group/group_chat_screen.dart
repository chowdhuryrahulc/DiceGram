// ignore_for_file: prefer_is_empty, prefer_const_constructors, avoid_print, camel_case_types, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/TikTakToe/TikTakToe/TikTakToe.dart';
import 'package:dicegram/chessGame.dart';
import 'package:dicegram/gameIdProblem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:dicegram/TikTakToe/tiktakHome.dart';
// import 'package:dicegram/chess/chessmain.dart';
import 'package:dicegram/helpers/game_service.dart';
import 'package:dicegram/helpers/group_service.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/group_data.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/new_snake_ladder/snake_ladder.dart';
import 'package:dicegram/providers/group_provider.dart';
import 'package:dicegram/ui/screens/dashboard.dart';
import 'package:dicegram/ui/widgets/group/group_chat_bubble.dart';
import 'package:dicegram/utils/Color.dart';
import 'package:dicegram/utils/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../gamemain.dart';
import 'Widgets/addPlayerList.dart';
import 'Widgets/deletePlayerList.dart';

List<String> selectedUsersList = [];
List<String> deletedUsersList = [];
List<String> newAddedUsersList = [];

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({
    Key? key,
    // required this.users,
    required this.adminId,
    required this.chatId,
    required this.groupData,
  }) : super(key: key);
  // final List<String> users;
  final String adminId;
  final String chatId;
  //todo might cause problems in initState function
  final GroupData groupData; //=> gameId

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  // Here we get the uid.
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  bool isShowBox = false;
  bool isGameInitiated = false;
  late GroupData groupData; // Comming from last screen.
  int selectedGame = -1;
  Future<List<String>>? listOfUsername;

  @override
  void initState() {
    // _groupData = widget.groupData;
    // updatePlayerId();
    // print("InitState groupChatScreen ${_groupData.players}");
    // if (_groupData.gameId != '') {
    //   isGameInitiated = true;
    // }
    super.initState();
  }

  // updatePlayerId() async {
  //   await searchIfPlayerIsPresentInAnyGroupAndFetchDocomentIdofThatGroup()
  //       .then((value) {
  //     print("value");
  //     print(value);
  //     if (value != null) {
  //       _groupData.gameId = value;
  //       isGameInitiated = true;
  //     } else {
  //       CircularProgressIndicator();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    TextEditingController newGroupController = TextEditingController();
    TextEditingController textEditingController = TextEditingController();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final _formKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Dashboard();
        })).then((value) {
          return true;
        });
      },
      child: StreamBuilder<DocumentSnapshot>(
          stream: getGroupListInformationFromDocoment(widget.chatId),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              log("Height: ${MediaQuery.of(context).size.height.toString()}");
              log("Width: ${MediaQuery.of(context).size.width.toString()}");
              groupData = GroupData.fromSnapshot(snapshot.data);
              if (groupData.gameId != '') {
                // _groupData.gameId = value;
                isGameInitiated = true;
                log("GameName: ${groupData.gameName}");
                switch (groupData.gameName) {
                  case KeyConstants.SNAKE_LADDER:
                    selectedGame = 0;
                    break;
                  case KeyConstants.TikTakToe:
                    selectedGame = 1;
                    break;
                  case KeyConstants.CHESS:
                    selectedGame = 2;
                    break;
                  default:
                }
              } else {
                isGameInitiated = false;
              }
              return Scaffold(
                  appBar: AppBar(
                    iconTheme: const IconThemeData(
                      color: Colors.white, //change your color here
                    ),
                    title: Text(snapshot.data['groupName']),
                    actions: [
                      snapshot.data['adminId'] == UserServices.userId
                          ? PopupMenuButton(
                              itemBuilder: (popupContext) => [
                                    PopupMenuItem(
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: popupContext,
                                                  builder: (popupContext) {
                                                    return SizedBox(
                                                      height: 100,
                                                      child:
                                                          updateGroupNameDialogBox(
                                                              _formKey,
                                                              newGroupController,
                                                              popupContext),
                                                    );
                                                  });
                                            },
                                            child: Text('Update GroupName'))),
                                    PopupMenuItem(
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    elevation: 16,
                                                    child: addPlayersList(
                                                      groupData: groupData,
                                                      chatId: widget.chatId,
                                                      adminId: snapshot
                                                          .data['adminId'],
                                                      groupName: snapshot
                                                          .data['groupName'],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Text('Add players'))),
                                    PopupMenuItem(
                                        child: TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: popupContext,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    elevation: 16,
                                                    child: SizedBox(
                                                      height: 500,
                                                      child: Column(
                                                        children: [
                                                          const Text(
                                                              'Select Players'),
                                                          deletePlayersList(
                                                              groupData:
                                                                  groupData),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    selectedUsersList
                                                                        .clear;
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      'Cancel')),
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    deleteUserFromGroup(
                                                                        widget
                                                                            .chatId,
                                                                        deletedUsersList);
                                                                    deletedUsersList
                                                                        .clear();
                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child: Text(
                                                                      'Next')),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Text('Remove Players')))
                                  ])
                          : SizedBox()
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: SizedBox(
                      height: height -
                          (MediaQuery.of(context).padding.top + kToolbarHeight),
                      child: Column(
                        children: [
                          Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: GroupService()
                                      .getGroupChat(widget.chatId),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.docs.isNotEmpty) {
                                      if (snapshot.data?.docs.length == 0) {
                                        return const Center(
                                            child: Text('No Messages Here'));
                                      } else {
                                        return ListView.builder(
                                            reverse: true,
                                            itemCount:
                                                snapshot.data?.docs.length,
                                            itemBuilder: (context, index) {
                                              var messageData =
                                                  snapshot.data?.docs[index];
                                              var messageId = messageData?.id;
                                              var messageSenderId =
                                                  messageData?[
                                                      KeyConstants.SENDER_ID];
                                              String? messageSenderName =
                                                  messageData?[
                                                      KeyConstants.SENDER_NAME];
                                              var isSeen = messageData?[
                                                  KeyConstants.SEEN];
                                              if (isSeen != null &&
                                                  isSeen == false &&
                                                  (UserServices.userId !=
                                                      messageSenderId)) {
                                                UserServices().markMsgRead(
                                                    chatId: widget.chatId,
                                                    messageId: messageId);
                                              }
                                              return GroupChatBubble(
                                                message: messageData?[
                                                    KeyConstants.MESSAGE],
                                                time: getTime(messageData?[
                                                    KeyConstants.CREATED_AT]),
                                                isMe: messageData?[KeyConstants
                                                        .SENDER_ID] ==
                                                    userId,
                                                messageSenderName:
                                                    messageSenderName,
                                              );
                                            });
                                      }
                                    } else
                                      return SizedBox();
                                  })),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Container(
                              height: 50.h,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors1.textInputBocColor,
                              ),
                              child: TextFormField(
                                obscureText: false,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                maxLines: 5,
                                minLines: 1,
                                decoration: InputDecoration(
                                    prefixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isShowBox = !isShowBox;
                                          });
                                          if (isShowBox == true) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          } else {
                                            try {
                                              FocusManager.instance.primaryFocus
                                                  ?.nextFocus();
                                            } catch (e) {
                                              log('Error Occured');
                                              print(e);
                                            }
                                          }
                                        },
                                        icon: Image.asset(
                                            "assets/images/game.png")),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          if (textEditingController.text
                                              .trim()
                                              .isNotEmpty) {
                                            GroupService().sendGroupMessage(
                                                message: textEditingController
                                                    .text
                                                    .trim(),
                                                groupId: widget.chatId);
                                            textEditingController.clear();
                                          }
                                        },
                                        icon: Image.asset(
                                            "assets/images/send.png")),
                                    border: InputBorder.none,
                                    hintText: 'Type a message...',
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w200,
                                        color: Colors.grey[400])),
                                controller: textEditingController,
                              ),
                            ),
                          ),
                          isShowBox
                              ? SizedBox(
                                  height: 400.h,
                                  width: double.infinity,
                                  child: isGameInitiated
                                      ? getSelectedGame(groupData, selectedGame)
                                      : GridView.count(
                                          crossAxisCount: 2,
                                          children: [
                                              InkWell(
                                                onTap: () {
                                                  selectedGame =
                                                      AppConstants.snakeLadder;
                                                  setState(() {});
                                                  onGameSelected(
                                                      AppConstants.snakeLadder);
                                                },
                                                child: ClipOval(
                                                  child: SizedBox(
                                                    height: 25.h,
                                                    child: Image.asset(
                                                        "assets/snakeLadder/snake_ladder.png"),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  selectedGame =
                                                      AppConstants.tikTackToe;
                                                  setState(() {});
                                                  onGameSelected(
                                                      AppConstants.tikTackToe);
                                                },
                                                child: ClipOval(
                                                  child: SizedBox(
                                                    height: 25.h,
                                                    child: Image.asset(
                                                        "assets/TikTakToe.png"),
                                                  ),
                                                ),
                                              ),
                                              // InkWell(
                                              //   onTap: () {
                                              //     selectedGame =
                                              //         AppConstants.chess;
                                              //     setState(() {});
                                              //     onGameSelected(
                                              //         AppConstants.chess);
                                              //   },
                                              //   child: ClipOval(
                                              //     child: SizedBox(
                                              //       height: 25.h,
                                              //       child: Image.asset(
                                              //           "assets/TikTakToe.png"),
                                              //     ),
                                              //   ),
                                              // ),
                                            ]))
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ));
            } else {
              return SizedBox();
            }
          }),
    );
  }

  updateGroupNameDialogBox(
    GlobalKey<FormState> _formKey,
    TextEditingController newGroupController,
    context,
  ) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 16,
      title: Text('Enter New Group Name'),
      actions: [
        ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
                updateGroupName(widget.chatId, newGroupController.text);
              }
            },
            child: Text('Submit'))
      ],
      content: Form(
          key: _formKey,
          child: TextFormField(
              validator: (value) =>
                  value!.isNotEmpty ? null : 'GroupName Should Not Be Empty',
              controller: newGroupController,
              decoration: InputDecoration())),
    );
  }

  void onGameSelected(int selectedGame) {
    log("onGameSelected: ${selectedGame.toString()}");
    String? keyConstraints;
    int minimumPlayers = 0;
    switch (selectedGame) {
      case 0:
        keyConstraints = KeyConstants.SNAKE_LADDER;
        minimumPlayers = 2;
        break;
      case 1:
        keyConstraints = KeyConstants.TikTakToe;
        minimumPlayers = 2;
        break;
      case 2:
        keyConstraints = KeyConstants.CHESS;
        minimumPlayers = 2;
        break;
      default:
    }
    //! this Dialog is for when the user clicks on the ElevatedButton for SnakeLadder etc..
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 16,
          child: SizedBox(
            height: 500.h,
            child: Column(
              children: [
                const Text('Select Players'),
                //! Where users is selected. Only 2 users for TikTakToe
                playersList(
                    users: groupData.users, minimumPlayers: minimumPlayers),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          selectedUsersList.clear;
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () async {
                          if (selectedUsersList.length == 1) {
                            Navigator.pop(context);
                            String gameId = await GameService().createGameRoom(
                                groupId: widget.chatId,
                                userIds: selectedUsersList,
                                game: keyConstraints!);
                            groupData.gameId = gameId;
                            groupData.players = selectedUsersList;
                            setState(() {
                              isGameInitiated = true;
                            });
                            selectedUsersList = [];
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Game needs $minimumPlayers players'),
                                duration: Duration(milliseconds: 500)));
                          }
                        },
                        child: Text('Next')),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getSelectedGame(GroupData groupData, int selectedGame,
      {String? gameId}) {
    log(selectedGame.toString());
    Widget game = SizedBox();
    print("reached isSelectedGame");
    switch (selectedGame) {
      case AppConstants.snakeLadder:
        game = SnakeLadder(
          onEnd: () {
            setState(() {
              isGameInitiated = false;
            });
          },
          gameId: groupData.gameId, //=> GameRoom => doc()
          players: groupData.players,
          // send userNameList
          isGameInitiated: isGameInitiated,
          playersName: [],
          chatId: widget.chatId,
          // isGameInitiated: isGameInitiated,
        );
        break;
      case AppConstants.tikTackToe:
        game = TikTakToe(
          gameId: groupData.gameId,
          players: groupData.players,
          playersName: [],
          chatId: widget.chatId,
          onEnd: () {
            setState(() {
              isGameInitiated = false;
            });
          },
        );
        break;
      case AppConstants.chess:
        game = ChessGame(
          gameId: groupData.gameId,
          players: groupData.players,
          playersName: [],
          chatId: widget.chatId,
          isGameInitiated: isGameInitiated,
          onEnd: () {
            setState(() {
              isGameInitiated = false;
            });
          },
        );
        break;
        // SnakeLadder(
        //   onEnd: () {
        //     setState(() {
        //       isGameInitiated = false;
        //     });
        //   },
        //   gameId: _groupData.gameId,
        //   players: _groupData.players,
        //   playersName: [],
        //   chatId: widget.chatId,
        // );
        break;
      // case AppConstants.chess:
      //   game = GameBoardStateLess({"name": 'Chess'}, widget.chatId, this.userId,
      //       groupData.players, groupData.players);
      //   selectedUsersList = [];
      //   break;
    }

    return game;
  }

  String getTime(var time) {
    if (time != null) {
      DateTime dateTime = time.toDate();
      String formatDate = DateFormat("hh:mm").format(dateTime);
      return formatDate;
    }
    return '';
  }
}

class playersList extends StatefulWidget {
  const playersList(
      {Key? key, required this.users, required int minimumPlayers})
      : super(key: key);
  final List<String> users;

  @override
  State<playersList> createState() => _playersListState();
}

class _playersListState extends State<playersList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: UserServices().getFirebaseUsers(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data?.docs.length == 0) {
              return const Center(child: Text('No Contacts found'));
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      // print(snapshot.data?.docs[0]['isEngaged']);
                      UserModel users =
                          UserModel.fromSnapshot(snapshot.data?.docs[index]);
                      if (widget.users.contains(users.id) &&
                          UserServices.userId != users.id &&
                          snapshot.data?.docs[index]['isEngaged'] == false) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    users.imageUrl.toString(),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                          'https://picsum.photos/250?image=9');
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              // Player name, to be send to next screen
                              Expanded(
                                  child: Text(
                                users.username.toString(),
                                maxLines: 1,
                              )),
                              // CheckBox
                              SizedBox(
                                width: 20,
                                child: Checkbox(
                                  value: selectedUsersList.contains(users.id),
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      setState(() {
                                        //! The list where the users who will play are added.
                                        if (selectedUsersList
                                            .contains(users.id)) {
                                        } else {
                                          selectedUsersList.add(users.id);
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        selectedUsersList.remove(users.id);
                                      });
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      } else
                        return const SizedBox();
                    }),
              );
            }
          }
          return Text(snapshot.data?.docs.length.toString() ?? '');
        });
  }
}
