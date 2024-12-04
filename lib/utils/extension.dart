import 'package:intl/intl.dart';

extension DateParsing on String {
  String parseDateAsString() {
    return DateFormat.yMMMd().add_jm().format(DateTime.parse(this).toLocal());
  }
}
