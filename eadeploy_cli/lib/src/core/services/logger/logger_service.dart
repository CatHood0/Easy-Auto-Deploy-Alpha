import 'dart:async';
import 'dart:core';
import '../../../extensions/date_format.dart';
import '../../logger/logger_details.dart';

//TODO: we need to reimplement this part
class LoggerService {
  final StreamController<List<LogMessageDetail>> logController =
      StreamController<List<LogMessageDetail>>.broadcast();

  final List<LogMessageDetail> _cachedLogs = <LogMessageDetail>[];

  static const int _logStackSize = 400;

  List<LogMessageDetail> get cache => _cachedLogs.toList(growable: false);
  Stream<List<LogMessageDetail>> get logs => logController.stream;
  LogMessageDetail? get last => _cachedLogs.lastOrNull;
  LogMessageDetail? get first => _cachedLogs.firstOrNull;
  int get length => _cachedLogs.length;

  void clear() {
    logController.add(<LogMessageDetail>[]);
    _cachedLogs.clear();
  }

  void setLog(List<LogMessageDetail> messages) {
    logController.add(messages);
  }

  void clamp(int start, int end) {
    _cachedLogs.replaceRange(
      start,
      end,
      <LogMessageDetail>[],
    );
    logController.add(_cachedLogs);
  }

  void clampIfRequired([int max = _logStackSize]) {
    if (_cachedLogs.length > max) {
      final int delta = _cachedLogs.length - _logStackSize;
      clamp(0, delta);
    }
  }

  void log(LogMessageDetail message, [bool ignore = false]) {
    if (ignore) return;
    clampIfRequired();
    final LogMessageDetail resultM = message.copyWithNewMessage(
        '[${DateTime.now().formatHhMmSs()}] - [${message.level.name.toUpperCase()}]: '
        '$message');

    // every log with an id that is already cached, will be removed
    // to the incomming message
    if (_cachedLogs.isNotEmpty && _cachedLogs.last.id == resultM.id) {
      _cachedLogs.removeLast();
    }

    logController.add(<LogMessageDetail>[
      ..._cachedLogs,
      resultM,
    ]);

    _cachedLogs.add(resultM);
  }

  void dispose() {
    logController.close();
  }
}
