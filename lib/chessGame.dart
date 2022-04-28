import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/gameIdProblem.dart';
import 'package:dicegram/helpers/game_service.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/new_snake_ladder/snakeLadderDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChessGame extends StatefulWidget {
  ChessGame({
    Key? key,
    required this.gameId,
    required this.players,
    required this.playersName,
    required this.chatId,
    required this.onEnd,
    required this.isGameInitiated,
  }) : super(key: key);
  final String gameId;
  bool isGameInitiated;
  final String chatId;
  final List<String> players;
  final List<String> playersName;
  final VoidCallback onEnd;

  @override
  State<ChessGame> createState() => _ChessGameState();
}

class _ChessGameState extends State<ChessGame> {
  @override
  void initState() {
    initFunc();
    super.initState();
  }

  //todo isEngaged not done yet.

  String fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  initFunc() async {
    fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
    ChessGameDatabase().storeFen(
        {'fen': fen, 'activePlayer': widget.players[0]}, widget.gameId);
  }

  String? otherPlayerUserId;
/*
Loadfen might cause a problem. 
We are not using no StreamBuilderData until now.

*/

  @override
  Widget build(BuildContext context) {
    bool isCheck = false;
    bool isCheckMate = false;
    bool isStaleMate = false;
    bool isDraw = false;

    return StreamBuilder(
        stream: ChessGameDatabase().getFen(widget.gameId),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (widget.players[0] == UserServices.userId) {
            otherPlayerUserId = widget.players[1];
          }
          if (widget.players[1] == UserServices.userId) {
            otherPlayerUserId = widget.players[0];
          }
          if (snapshot.hasData) {
            ChessBoardController chessBoardController =
                ChessBoardController.fromFEN(snapshot.data!['fen']);

            log(chessBoardController.getFen());
            // log(snapshot.data!['fen']);
            // log(snapshot.data!['activePlayer']);
            chessBoardController.loadFen(snapshot.data!['fen']);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300.h,
                  width: 300.w,
                  child: ChessBoard(
                    controller: chessBoardController,
                    size: MediaQuery.of(context).size.width,
                    enableUserMoves:
                        snapshot.data!['activePlayer'] == UserServices.userId
                            ? true
                            : false,
                    boardColor: BoardColor.green,
                    onMove: () {
                      isCheck = chessBoardController.isInCheck();
                      isCheckMate = chessBoardController.isCheckMate();
                      isStaleMate = chessBoardController.isStaleMate();
                      isDraw = chessBoardController.isDraw();
                      fen = chessBoardController.getFen();
                      ChessGameDatabase().storeFen(
                          {'fen': fen, 'activePlayer': otherPlayerUserId},
                          widget.gameId);
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            FutureBuilder(
                                future: snakeLadderDatabase()
                                    .searchUserNamefromIdAndShowInSnakeLadderGame(
                                        widget.players[0]),
                                builder:
                                    (context, AsyncSnapshot future1Snapshot) {
                                  if (future1Snapshot.hasData) {
                                    return Text(
                                      future1Snapshot.data['username']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: future1Snapshot.data['id'] ==
                                                  snapshot.data!['activePlayer']
                                              ? Colors.green
                                              : Colors.red),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                            FutureBuilder(
                                future: snakeLadderDatabase()
                                    .searchUserNamefromIdAndShowInSnakeLadderGame(
                                        widget.players[1]),
                                builder:
                                    (context, AsyncSnapshot future2Snapshot) {
                                  if (future2Snapshot.hasData) {
                                    return Text(
                                      future2Snapshot.data['username']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: future2Snapshot.data['id'] ==
                                                  snapshot.data!['activePlayer']
                                              ? Colors.green
                                              : Colors.red),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                })
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            initFunc();
                          },
                          child: Text('Reset'),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            try {
                              initFunc();
                              deleteUsersFromGameRoom(
                                  widget.gameId, otherPlayerUserId!);
                              GameService()
                                  .deleteGame(widget.gameId, widget.chatId);
                              widget.onEnd();
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text('End'),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
