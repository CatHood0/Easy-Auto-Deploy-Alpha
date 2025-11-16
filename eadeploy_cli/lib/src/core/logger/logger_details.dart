import '../../utils/id_generator.dart';

enum LogLevel {
  error,
  info,
}

class LogMessageDetail {
  /// The id of this log
  ///
  /// If we found another id with the same value of this one
  /// it's removed from the logs list
  final String id;
  final String log;
  final LogLevel level;

  LogMessageDetail({
    String? id,
    required this.log,
    this.level = LogLevel.info,
  }) : id = id ?? nanoid();

  LogMessageDetail.error({
    String? id,
    required this.log,
  })  : id = id ?? nanoid(),
        level = LogLevel.error;

  LogMessageDetail copyWithNewMessage(String log) {
    return LogMessageDetail(
      level: level,
      id: id,
      log: log,
    );
  }
}
