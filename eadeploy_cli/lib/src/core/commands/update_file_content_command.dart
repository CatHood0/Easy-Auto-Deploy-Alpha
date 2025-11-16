import 'command_base.dart';

class UpdateFileContentCommand extends CommandBase {
  final String filePath;
  final String matchExpression;

  // if value replacement match with a EnvironmentVar
  // the values is automatically replaced
  final String valueReplacement;

  UpdateFileContentCommand({
    required this.filePath,
    required this.matchExpression,
    required this.valueReplacement,
    required super.assignedToPipeline,
    super.criticalCommand,
    super.pre,
  });

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'update_file_content',
      'filePath': filePath,
      'matchExpression': matchExpression,
      'valueReplacement': valueReplacement,
      'assignedToPipeline': assignedToPipeline,
      'criticalCommand': criticalCommand,
      'pre': pre,
    };
  }

  factory UpdateFileContentCommand.fromJson(Map<String, dynamic> map) {
    return UpdateFileContentCommand(
      filePath: map['filePath'] as String,
      matchExpression: map['matchExpression'] as String,
      valueReplacement: map['valueReplacement'] as String,
      assignedToPipeline: map['assignedToPipeline'] as String,
      criticalCommand: map['criticalCommand'] as bool? ?? false,
      pre: map['pre'] as bool? ?? true,
    );
  }

  UpdateFileContentCommand copyWith({
    String? filePath,
    String? matchExpression,
    String? valueReplacement,
    String? assignedToPipeline,
    bool? criticalCommand,
    bool? pre,
  }) {
    return UpdateFileContentCommand(
      filePath: filePath ?? this.filePath,
      matchExpression: matchExpression ?? this.matchExpression,
      valueReplacement: valueReplacement ?? this.valueReplacement,
      assignedToPipeline: assignedToPipeline ?? this.assignedToPipeline,
      criticalCommand: criticalCommand ?? this.criticalCommand,
      pre: pre ?? this.pre,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateFileContentCommand &&
          runtimeType == other.runtimeType &&
          filePath == other.filePath &&
          matchExpression == other.matchExpression &&
          assignedToPipeline == other.assignedToPipeline &&
          pre == other.pre &&
          criticalCommand == other.criticalCommand &&
          valueReplacement == other.valueReplacement;

  @override
  int get hashCode =>
      filePath.hashCode ^
      matchExpression.hashCode ^
      valueReplacement.hashCode ^
      assignedToPipeline.hashCode ^
      pre.hashCode ^
      criticalCommand.hashCode;
}
