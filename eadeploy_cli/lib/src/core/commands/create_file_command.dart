import 'command_base.dart';

class CreateFileCommand extends CommandBase {
  final String filePath;
  final String content;

  CreateFileCommand({
    required this.filePath,
    required this.content,
    required super.assignedToPipeline,
    super.criticalCommand,
    super.pre,
  });

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'create_file',
      'filePath': filePath,
      'content': content,
      'assignedToPipeline': assignedToPipeline,
      'criticalCommand': criticalCommand,
      'pre': pre,
    };
  }

  factory CreateFileCommand.fromJson(Map<String, dynamic> map) {
    return CreateFileCommand(
      filePath: map['filePath'] as String,
      content: map['content'] as String,
      assignedToPipeline: map['assignedToPipeline'] as String,
      criticalCommand: map['criticalCommand'] as bool,
      pre: map['pre'] as bool,
    );
  }

  CreateFileCommand copyWith({
    String? filePath,
    String? content,
    String? assignedToPipeline,
    bool? criticalCommand,
    bool? pre,
  }) {
    return CreateFileCommand(
      filePath: filePath ?? this.filePath,
      content: content ?? this.content,
      criticalCommand: criticalCommand ?? this.criticalCommand,
      assignedToPipeline: assignedToPipeline ?? this.assignedToPipeline,
      pre: pre ?? this.pre,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateFileCommand &&
          runtimeType == other.runtimeType &&
          filePath == other.filePath &&
          criticalCommand == other.criticalCommand &&
          pre == other.pre &&
          assignedToPipeline == other.assignedToPipeline &&
          content == other.content;

  @override
  int get hashCode =>
      filePath.hashCode ^
      content.hashCode ^
      assignedToPipeline.hashCode ^
      criticalCommand.hashCode;
}
