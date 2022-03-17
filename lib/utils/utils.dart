import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Utils {
  // Solve it for groupId
  static String getDateFromTimestamp(firestoreTimestamp, String format) {
    firestoreTimestamp == null
        ? firestoreTimestamp = Timestamp(3, 12)
        : firestoreTimestamp = firestoreTimestamp;
    DateTime timestamp = (firestoreTimestamp as Timestamp).toDate();
    return DateFormat(format).format(timestamp);
  }
}
