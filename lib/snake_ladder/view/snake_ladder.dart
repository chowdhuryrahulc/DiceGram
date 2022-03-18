// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:developer';
import 'dart:math';
import 'package:dicegram/helpers/user_service.dart';
import 'package:spring/spring.dart';
import 'package:demoji/demoji.dart';
import 'package:dicegram/helpers/game_service.dart';
import 'package:dicegram/snake_ladder/consts/dices.dart';
import 'package:dicegram/snake_ladder/snakeLadderDatabase.dart';
import 'package:dicegram/snake_ladder/widgets/dice-item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:dicegram/snake_ladder/widgets/image-item.dart';
import 'package:dicegram/snake_ladder/widgets/play.dart';
import 'package:dicegram/snake_ladder/widgets/utils.dart';

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
  Stream? getSnakeLadderDataStream;

  // late SnakesLadders _snakesLaddersStore;

  @override
  void initState() {
    super.initState();
    initFunc();
    // _snakesLaddersStore = GetIt.instance<SnakesLadders>();
    // _snakesLaddersStore.init(widget.gameId, widget.players);
    // utils = Utils();
  }

  initFunc() {
    int position1 = 1;
    int position2 = 1;
    Map<String, dynamic> positionAndActivePlayerMap = {
      widget.players[0]: position1,
      widget.players[1]: position2,
      'activePlayer': widget.players[0]
    };
    snakeLadderDatabase()
        .sendSnakeLadderPositionData(widget.gameId, positionAndActivePlayerMap);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: snakeLadderDatabase().getSnakeLadderPositionData(widget.gameId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: AnimationLimiter(
                    child: Stack(children: [
                      Container(
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
                                    totalPlayerOne:
                                        snapshot.data[widget.players[0]],
                                    totalPlayerTwo:
                                        snapshot.data[widget.players[1]],
                                    index: index,
                                  )
                                ],
                              );
                            }),
                      ),
                      ImageItem(context), // All the laders and Snakes
                    ]),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            initFunc();
                            number = 1;
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
                        Dice(snapshot)
                        // Footer(snakeLaddersStore: _snakesLaddersStore, diceTwo: dice),
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

  int number = 1;
  void rollDice(AsyncSnapshot snapshot) {
    number = Random().nextInt(6);
    //todo should not go above 100.
    // int oldPosition1 = snapshot.data[widget.players[0]] + number;
    //todo update all the positions.
    //todo the ? needs to be uncommented during checking multiplayer
    //? if (snapshot.data['activePlayer'] == UserServices.userId) {
    Map<String, dynamic> positionAndActivePlayerMap = {
      widget.players[0]: snapshot.data[widget.players[0]] + number,
      widget.players[1]: snapshot.data[widget.players[1]],
      'activePlayer': widget.players[1]
    };
    snakeLadderDatabase().updateSnakeLadderPositionData(
        widget.gameId, positionAndActivePlayerMap);
    //? }
  }

  Widget Dice(AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          rollDice(snapshot);
        },
        child: DiceItem(
          dice: DicesConst.dice(
            number.toString(),
          ),
          color: snapshot.data['activePlayer'] == UserServices.userId
              ? Colors.transparent
              : Colors.black38,
          springController: SpringController(initialAnim: Motion.play),
        ),
      ),
    );
  }
}
