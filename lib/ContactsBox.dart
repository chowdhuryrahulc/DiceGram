import 'package:hive/hive.dart';
part 'ContactsBox.g.dart';

@HiveType(typeId: 1)
class ContactsBox {
  ContactsBox({required this.number ,required this.contactsName});
  
  @HiveField(0)
  int number;

  @HiveField(1)
  String contactsName;

}
// Step 3: flutter packages pub run build_runner build