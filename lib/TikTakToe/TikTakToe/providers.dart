import 'package:flutter/cupertino.dart';

class recieverNameProvider extends ChangeNotifier {
  String recieverName = '';
  getRecieverName(String reciever) {
    recieverName = reciever;
    print('RECIEVERSSS');
    print(recieverName);
    notifyListeners();
  }
}
