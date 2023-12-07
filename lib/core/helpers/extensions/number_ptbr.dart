import 'package:intl/intl.dart';

extension NumberPtbr on double {
  String get toPTBR {
    NumberFormat real = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return real.format(this);
  }
}
