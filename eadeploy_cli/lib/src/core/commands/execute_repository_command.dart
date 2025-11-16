import 'command_base.dart';

class ExecuteRepositoryCommand extends CommandBase {
  /// The repository that will be executed
  final String repoId;

  /// The [PipelineEvent] where this will be executed
  final String eventId;

  ExecuteRepositoryCommand({
    required this.repoId,
    required this.eventId,
    required super.assignedToPipeline,
    super.criticalCommand,
    super.pre,
  });

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': 'execute_repo',
      'repoId': repoId,
      'eventId': eventId,
      'assignedToPipeline': assignedToPipeline,
      'criticalCommand': criticalCommand,
      'pre': pre,
    };
  }

  factory ExecuteRepositoryCommand.fromJson(Map<String, dynamic> map) {
    return ExecuteRepositoryCommand(
      eventId: map['eventId'] as String,
      repoId: map['repoId'] as String,
      assignedToPipeline: map['assignedToPipeline'] as String,
      criticalCommand: map['criticalCommand'] as bool? ?? false,
      pre: map['pre'] as bool? ?? false,
    );
  }

  ExecuteRepositoryCommand copyWith({
    String? eventId,
    String? repoId,
    String? assignedToPipeline,
    bool? criticalCommand,
    bool? pre,
  }) {
    return ExecuteRepositoryCommand(
      repoId: repoId ?? this.repoId,
      eventId: eventId ?? this.eventId,
      assignedToPipeline: assignedToPipeline ?? this.assignedToPipeline,
      criticalCommand: criticalCommand ?? this.criticalCommand,
      pre: pre ?? this.pre,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExecuteRepositoryCommand &&
          runtimeType == other.runtimeType &&
          repoId == other.repoId &&
          assignedToPipeline == other.assignedToPipeline &&
          pre == other.pre &&
          criticalCommand == other.criticalCommand &&
          eventId == other.eventId;

  @override
  int get hashCode =>
      repoId.hashCode ^
      eventId.hashCode ^
      assignedToPipeline.hashCode ^
      pre.hashCode ^
      criticalCommand.hashCode;
}
