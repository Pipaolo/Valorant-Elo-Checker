import 'package:logger/logger.dart';
import 'package:logger_flutter/logger_flutter.dart';

class ValorantLogOutput extends ConsoleOutput {
  @override
  void output(OutputEvent event) {
    super.output(event);
    LogConsole.add(event);
  }
}
