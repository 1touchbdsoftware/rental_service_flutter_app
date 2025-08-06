import 'package:intl/intl.dart';

String formatDateTimeReadable(DateTime dateTime) {
  final formatter = DateFormat('d MMMM yyyy h:mma');
  return formatter.format(dateTime);
}
