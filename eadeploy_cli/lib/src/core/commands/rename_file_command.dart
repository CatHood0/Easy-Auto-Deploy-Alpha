import 'command_base.dart';

class RenameFileCommand extends CommandBase {
  final String oldPath;
  final String newPath;

  RenameFileCommand({
    required this.oldPath,
    required this.newPath,
    required super.assignedToPipeline,
    super.criticalCommand,
    super.pre,
  });

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'rename_file',
      'oldPath': oldPath,
      'newPath': newPath,
      'assignedToPipeline': assignedToPipeline,
      'criticalCommand': criticalCommand,
      'pre': pre,
    };
  }

  factory RenameFileCommand.fromJson(Map<String, dynamic> map) {
    return RenameFileCommand(
      oldPath: map['oldPath'] as String,
      newPath: map['newPath'] as String,
      assignedToPipeline: map['assignedToPipeline'] as String,
      criticalCommand: map['criticalCommand'] as bool? ?? false,
      pre: map['pre'] as bool? ?? false,
    );
  }

  RenameFileCommand copyWith({
    String? oldPath,
    String? newPath,
    String? assignedToPipeline,
    bool? criticalCommand,
    bool? pre,
  }) {
    return RenameFileCommand(
      oldPath: oldPath ?? this.oldPath,
      newPath: newPath ?? this.newPath,
      assignedToPipeline: assignedToPipeline ?? this.assignedToPipeline,
      criticalCommand: criticalCommand ?? this.criticalCommand,
      pre: pre ?? this.pre,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenameFileCommand &&
          runtimeType == other.runtimeType &&
          oldPath == other.oldPath &&
          assignedToPipeline == other.assignedToPipeline &&
          criticalCommand == other.criticalCommand &&
          pre == other.pre &&
          newPath == other.newPath;

  @override
  int get hashCode =>
      oldPath.hashCode ^
      newPath.hashCode ^
      pre.hashCode ^
      assignedToPipeline.hashCode ^
      criticalCommand.hashCode;
}
