// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoji/demoji.dart';
import 'package:dicegram/helpers/game_service.dart';
import 'package:dicegram/snake_ladder/snakeLadderDatabase.dart';
import 'package:dicegram/utils/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:dicegram/snake_ladder/stores/DatabaseSnake.dart';
import 'package:dicegram/snake_ladder/view/footer.dart';
import 'package:dicegram/snake_ladder/widgets/image-item.dart';
import 'package:dicegram/snake_ladder/widgets/play.dart';
import 'package:dicegram/snake_ladder/widgets/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../snakeLadderProvider.dart';

class SnakeLadder extends StatefulWidget {
  const SnakeLadder({
    Key? key,
    required this.gameId,
    required this.players,
    required this.chatId,
    required this.onEnd,
  }) : super(key: key);
  final String gameId;
  final List<String> players;
  final String chatId;
  final VoidCallback onEnd;

  @override
  _SnakeLadderState createState() => _SnakeLadderState();
}

class _SnakeLadderState extends State<SnakeLadder> {
  int dice = 0;
  late Utils utils;

  // late SnakesLadders _snakesLaddersStore;

  @override
  void initState() {
    super.initState();
    // _snakesLaddersStore = GetIt.instance<SnakesLadders>();
    // _snakesLaddersStore.init(widget.gameId, widget.players);
    // utils = Utils();
  }

  streamToGetData() {
    return FirebaseUtils.getGameColRef()
            .doc(widget.gameId)
            .collection('game')
            .snapshots()
        //     .listen((event) {
        //   if (event.docs.isNotEmpty) {
        //     setState(() {
        //       dice = event.docs[0]["dice"];
        //     });
        //     dice = 0;
        //   }
        // })
        ;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: streamToGetData(),
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                child: AnimationLimiter(
                  child: Stack(children: [
                    // Observer(
                    //   builder: (BuildContext context) {
                    // print('MediaQuery.of(context).size.height');
                    // print(MediaQuery.of(context).size.height);
                    // ScreenUtil.setContext(context);
                    Container(
                      // color: Colors.orange,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange.shade300),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(color: Colors.orange.shade100)
                          ]),
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(3),
                          addAutomaticKeepAlives: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 10),
                          itemCount: 100,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var color = index % 2 == 0
                                ? Colors.black38
                                : Colors.orange[300];
                            return Observer(
                              builder: (BuildContext context) {
                                return Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(color: color),
                                      child: Center(
                                        // For 100 only
                                        child: (100 - index) == 100
                                            ? Text(
                                                Demoji.house,
                                                style: TextStyle(fontSize: 18),
                                              )
                                            : Text(
                                                (100 - index).toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                      ),
                                    ),
                                    Play(
                                      // Real position of the player
                                      totalPlayerOne: context
                                          .watch<diceProvider>()
                                          .position1,
                                      // _snakesLaddersStore.totalPlayerOne,
                                      totalPlayerTwo: context
                                          .watch<diceProvider>()
                                          .position2,
                                      // _snakesLaddersStore.totalPlayerTwo,
                                      // currentPlayer: _snakesLaddersStore
                                      // .currentPlayer, // Still not implemented in Play
                                      index: index,
                                    )
                                  ],
                                );
                              },
                            );
                          }),
                    ),

                    // },
                    // ),
                    ImageItem(context), //! All the laders and Snakes
                  ]),
                ),
              ),
              // Observer(
              //   builder: (context) {
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          utils.dialogRestart(context);
                        },
                        child: Text('Reset'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // End updates gameId, gameName, player.uid,
                          //! uid just keeps adding, adding. Makes 3-5 players.
                          //? Why use players, users. different different??
                          //? Where the SnakeLadder inPlaying data is stored??
                          GameService()
                              .deleteGame(widget.gameId, widget.chatId);
                          widget.onEnd();
                        },
                        child: Text('End'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange)),
                      ),
                      Dice()
                      // Footer(snakeLaddersStore: _snakesLaddersStore, diceTwo: dice),
                    ],
                  ),
                ],
                // );
                // },
              ),
            ],
          );
        });
  }

  Widget Dice() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: () {
            context
                .read<diceProvider>()
                .updateDice(widget.gameId, widget.players);
            print('widget.gameId');
            print(widget.gameId);
            print('widget.players');
            print(widget.players);
Map<String, int> updatePositionData={
  'data': 67
};
            storeDataInFirebase(widget.gameId, updatePositionData);
            // print(number);
            // setState(() {});
          },
          child: Text(
            context.watch<diceProvider>().number.toString(),
            style: TextStyle(fontSize: 30),
          )),
    );
  }
}
