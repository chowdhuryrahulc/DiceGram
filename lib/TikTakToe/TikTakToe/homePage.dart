// // ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print

// import 'dart:math';
// import 'package:dicegram/TikTakToe/TikTakToe/TikTakToeDatabase.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'customDialog.dart';
// import 'gameButton.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key, required this.gameRoomId}) : super(key: key);
//   final String gameRoomId;

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<GameButton>? buttonsList;
//   List<int> player1 = [];
//   List<int> player2 = [];
//   // String activePlayer = firstName!;
//   TikTakToeDatabase tikTakToeDatabase = TikTakToeDatabase();
//   Stream? getTikTakToeDataStream;

//   @override
//   void initState() {
//     buttonsList = doInit();
//     super.initState();
//   }


//   doInit() {
//     // String activePlayer = firstName!;

//     List<GameButton> gameButtons = [
//       GameButton(id: 1),
//       GameButton(id: 2),
//       GameButton(id: 3),
//       GameButton(id: 4),
//       GameButton(id: 5),
//       GameButton(id: 6),
//       GameButton(id: 7),
//       GameButton(id: 8),
//       GameButton(id: 9),
//     ];
//     // Map<String, dynamic> activePlayerMap = {'activePlayer': activePlayer};
//     // tikTakToeDatabase.saveActivePlayerInFirestore(
//     //     activePlayerMap, widget.gameRoomId);

//     String text = '';
//     String bg = 'grey';
//     bool enabled = false;

//     for (var id = 1; id < 10; id++) {
//       Map<String, dynamic> gameMap = {
//         'id': id,
//         'text': text,
//         'background': bg,
//         'enabled': enabled
//       };
//       tikTakToeDatabase.sendGameButtonData(widget.gameRoomId, gameMap, id);
//     }

//     tikTakToeDatabase.getButtonData(widget.gameRoomId).then((value) {
//       setState(() {
//         getTikTakToeDataStream = value;
//       });
//     });

//     return gameButtons;
//   }

//   void playGame(GameButton gameButton, int id) async {
//     var taju = await tikTakToeDatabase.getActivePlayerData(widget.gameRoomId);
//     // activePlayer = taju;
//     setState(() {
//       if (activePlayer == Constants.myName) {
//         Map<String, dynamic> updateButtonDataMap = activePlayer == firstName
//             ? {
//                 'id': id,
//                 'text': "X",
//                 'background': 'red',
//                 'enabled': gameButton.enabled
//               }
//             : {
//                 'id': id,
//                 'text': "O",
//                 'background': 'black',
//                 'enabled': gameButton.enabled
//               };
//         tikTakToeDatabase.updateGameButtonData(
//             widget.gameRoomId, updateButtonDataMap, gameButton.id);

//         Map<String, List> playersListMap = {
//           activePlayer.toString(): player1,
//         };
//         tikTakToeDatabase.sendTikTakToeData(widget.gameRoomId, playersListMap);

//         activePlayer = Provider.of<recieverNameProvider>(context, listen: false)
//             .recieverName;
//         tikTakToeDatabase.updateActivePlayerInFirestore(
//             activePlayer, widget.gameRoomId);

//         checkWinner().then((value) {
//           print('WINNERS');
//           print(value);
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Tic Tac Toe"),
//         ),
//         body: StreamBuilder(
//             stream: getTikTakToeDataStream,
//             builder: (context, AsyncSnapshot snapshot) {
//               if (snapshot.hasData) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: <Widget>[
//                     Expanded(
//                       child: GridView.builder(
//                           padding: const EdgeInsets.all(10.0),
//                           // GriDelegate controlls the layout of GridView
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                   //TO Change Size here
//                                   crossAxisCount: 3,
//                                   childAspectRatio: 1.0,
//                                   crossAxisSpacing: 9.0,
//                                   mainAxisSpacing: 9.0),
//                           itemCount: snapshot.data.docs.length, // 9 buttons
//                           itemBuilder: (context, i) {
//                             var taju = tikTakToeDatabase
//                                 .getActivePlayerData(widget.gameRoomId);
//                             return SizedBox(
//                               width: 100.0,
//                               height: 100.0,
//                               child: RaisedButton(
//                                 padding: const EdgeInsets.all(8.0),
//                                 // if enabled, call a function
//                                 onPressed:
//                                     snapshot.data.docs[i].data()['enabled'] ==
//                                             false
//                                         ? () {
//                                             playGame(buttonsList![i], i);
//                                           }
//                                         : null,
//                                 child: Text(
//                                   snapshot.data.docs[i].data()['text'],
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 20.0),
//                                 ),
//                                 // Innitially grey
//                                 color: snapshot.data.docs[i]
//                                             .data()['background'] ==
//                                         'grey'
//                                     ? Colors.grey
//                                     : snapshot.data.docs[i]
//                                                 .data()['background'] ==
//                                             'red'
//                                         ? Colors.red
//                                         : Colors.black,
//                                 disabledColor: snapshot.data.docs[i]
//                                             .data()['background'] ==
//                                         'grey'
//                                     ? Colors.grey
//                                     : snapshot.data.docs[i]
//                                                 .data()['background'] ==
//                                             'red'
//                                         ? Colors.red
//                                         : Colors.black,
//                               ),
//                             );
//                           }),
//                     ),
//                     RaisedButton(
//                       child: Text(
//                         "Reset",
//                         style: TextStyle(color: Colors.white, fontSize: 20.0),
//                       ),
//                       color: Colors.red,
//                       padding: const EdgeInsets.all(20.0),
//                       onPressed: resetGame,
//                     )
//                   ],
//                 );
//               } else
//                 return Container();
//             }));
//   }

//   Future<String> getPlayerListData(int id) async {
//     var g = await tikTakToeDatabase.getPlayerListData(widget.gameRoomId, id);
//     return g;
//   }

// // Simple
//   Future<int> checkWinner() async {
//     var winner = -1;
//     var id1 = await getPlayerListData(1);
//     var id2 = await getPlayerListData(2);
//     var id3 = await getPlayerListData(3);
//     var id4 = await getPlayerListData(4);
//     var id5 = await getPlayerListData(5);
//     var id6 = await getPlayerListData(6);
//     var id7 = await getPlayerListData(7);
//     var id8 = await getPlayerListData(8);
//     var id9 = await getPlayerListData(9);

//     if (id1 == 'O' &&
//         id2 == 'O' &&
//         id3 == 'O') {
//       winner = 1;
//     }
//     if (id1 == 'X' &&
//         id2 == 'X' &&
//         id3 == 'X') {
//       winner = 2;
//     }

//     // row 2
//     if (id4 == 'O' &&
//         id5 == 'O' &&
//         id6 == 'O') {
//       winner = 1;
//     }
//     if (id4 == 'X' &&
//         id5 == 'X' &&
//         id6 == 'X') {
//       winner = 2;
//     }
// //ROW 3
// if (id7 == 'O' &&
//         id8 == 'O' &&
//         id9 == 'O') {
//       winner = 1;
//     }
//     if (id7 == 'X' &&
//         id8 == 'X' &&
//         id9 == 'X') {
//       winner = 2;
//     }

// // Column 1
//     if (id1 == 'O' &&
//         id4 == 'O' &&
//         id7 == 'O') {
//       winner = 1;
//     }
//     if (id1 == 'X' &&
//         id4 == 'X' &&
//         id7 == 'X') {
//       winner = 2;
//     }

//     // column 2
//     if (id2 == 'O' &&
//         id5 == 'O' &&
//         id8 == 'O') {
//       winner = 1;
//     }
//     if (id2 == 'X' &&
//         id5 == 'X' &&
//         id8 == 'X') {
//       winner = 2;
//     }
// //column 3
//     if (id3 == 'O' &&
//         id6 == 'O' &&
//         id9 == 'O') {
//       winner = 1;
//     }
//     if (id3 == 'X' &&
//         id6 == 'X' &&
//         id9 == 'X') {
//       winner = 2;
//     }

// // Digonal
//     if (id1 == 'O' &&
//         id5 == 'O' &&
//         id9 == 'O') {
//       winner = 1;
//     }
//     if (id1 == 'X' &&
//         id5 == 'X' &&
//         id9 == 'X') {
//       winner = 2;
//     }
// //digonal 2
//     if (id3 == 'O' &&
//         id5 == 'O' &&
//         id7 == 'O') {
//       winner = 1;
//     }
//     if (id3 == 'X' &&
//         id5 == 'X' &&
//         id7 == 'X') {
//       winner = 2;
//     }

//     if (winner != -1) {
//       if (winner == 1) {
//         showDialog(
//             context: context,
//             builder: (_) => CustomDialog("Player 1 Won",
//                 "Press the reset button to start again.", resetGame));
//       } else {
//         showDialog(
//             context: context,
//             builder: (_) => CustomDialog("Player 2 Won",
//                 "Press the reset button to start again.", resetGame));
//       }
//     }
//     return winner;
//   }

//   void resetGame() {
//     buttonsList = doInit();
//     Navigator.pop(context);
//   }
// }
