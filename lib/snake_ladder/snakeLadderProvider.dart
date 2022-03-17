import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class diceProvider extends ChangeNotifier {
  int number = 0;
  int position1 = 1;
  int position2 = 1;
  //! Comes from next button
  String myUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  // String otherPlayerUid = FirebaseAuth.instance

  updateDice(String gameId, List<String> players) {
    number = Random().nextInt(6);
    position1 = position1 + number;
    print('myUid');
    print(myUid);
    notifyListeners();
  }
}