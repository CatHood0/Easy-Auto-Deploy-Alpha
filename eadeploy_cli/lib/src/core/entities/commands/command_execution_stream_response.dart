import '../../commands/command_base.dart';
import '../enums/execution_phases.dart';

class CommandExecutionStreamResponse {
  final CommandBase command;
  final Object? error;
  final int index;
  final ExecutionPhase phase;

  CommandExecutionStreamResponse({
    required this.command,
    required this.index,
    required this.phase,
    this.error,
  });

  /// Whether the command already was executed sucessfully
  bool get endSuccessfully => phase == ExecutionPhase.success;

  /// Whether the command already was executed and ends with an error
  bool get endWithError => phase == ExecutionPhase.error;

  /// Whether the command is being executing yet
  bool get isExecuting => phase == ExecutionPhase.executing;
}
