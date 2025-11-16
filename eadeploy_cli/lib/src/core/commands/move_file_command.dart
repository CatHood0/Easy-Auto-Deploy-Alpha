import 'command_base.dart';

class MoveFileCommand extends CommandBase {
  final String from;
  final String to;

  MoveFileCommand({
    required this.from,
    required this.to,
    required super.assignedToPipeline,
    super.criticalCommand,
    super.pre,
  });

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'move_file',
      'from': from,
      'to': to,
      'assignedToPipeline': assignedToPipeline,
      'criticalCommand': criticalCommand,
      'pre': pre,
    };
  }

  factory MoveFileCommand.fromJson(Map<String, dynamic> map) {
    return MoveFileCommand(
      from: map['from'] as String,
      to: map['to'] as String,
      assignedToPipeline: map['assignedToPipeline'] as String,
      criticalCommand: map['criticalCommand'] as bool? ?? false,
      pre: map['pre'] as bool? ?? false,
    );
  }

  MoveFileCommand copyWith({
    String? from,
    String? to,
    String? assignedToPipeline,
    bool? criticalCommand,
    bool? pre,
  }) {
    return MoveFileCommand(
      from: from ?? this.from,
      to: to ?? this.to,
      assignedToPipeline: assignedToPipeline ?? this.assignedToPipeline,
      criticalCommand: criticalCommand ?? this.criticalCommand,
      pre: pre ?? this.pre,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoveFileCommand &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          assignedToPipeline == other.assignedToPipeline &&
          criticalCommand == other.criticalCommand &&
          pre == other.pre &&
          to == other.to;

  @override
  int get hashCode =>
      from.hashCode ^
      to.hashCode ^
      pre.hashCode ^
      assignedToPipeline.hashCode ^
      criticalCommand.hashCode;
}
