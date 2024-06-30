import 'package:intl/intl.dart';

String formatDate(String date, {bool isDetailed = false}) {
  final DateFormat formatter = isDetailed
      ? DateFormat("yyyy-MM-dd HH:mm:ss", "id_ID")
      : DateFormat("yyyy-MM-dd", "id_ID");

  final parsedDate = formatter.parse(date);

  if (isDetailed) {
    return DateFormat("EEEE, d MMMM yyyy HH:mm", "id_ID").format(parsedDate);
  }

  return DateFormat("EEEE, d MMMM yyyy", "id_ID").format(parsedDate);
}
