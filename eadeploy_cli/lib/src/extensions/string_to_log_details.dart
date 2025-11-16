import 'package:eadeploy_cli/src/core/logger/logger_details.dart';

extension StringToLogDetails on String {
  LogMessageDetail toLog({String? id, LogLevel level = LogLevel.info}) {
    return LogMessageDetail(
      log: this,
      id: id,
      level: level,
    );
  }

  LogMessageDetail toLogError({String? id}) {
    return LogMessageDetail(
      log: this,
      id: id,
      level: LogLevel.error,
    );
  }
}
