import 'package:eadeploy_cli/src/core/commands/execute_repository_command.dart';
import 'package:eadeploy_cli/src/core/commands/move_file_command.dart';
import 'package:eadeploy_cli/src/core/commands/rename_file_command.dart';
import 'package:eadeploy_cli/src/core/commands/update_file_content_command.dart';

import '../../commands/command_base.dart';
import '../../commands/create_file_command.dart';
import '../../entities/enums/execution_phases.dart';
import '../../entities/commands/command_execution_stream_response.dart';

class CommandExecuter {
  static final CommandExecuter instance = CommandExecuter._();

  const CommandExecuter._();

  factory CommandExecuter() {
    return instance;
  }

  Stream<CommandExecutionStreamResponse> execute(
    Map<String, dynamic> data,
    List<CommandBase> steps,
  ) async* {
    for (int i = 0; i < steps.length; i++) {
      final CommandBase command = steps[i];
      // tipically we return this value at firs
      // to let logger notify about the command
      yield CommandExecutionStreamResponse(
        command: command,
        index: i,
        phase: ExecutionPhase.executing,
      );
      late ExecutionPhase phase;
      if (command is CreateFileCommand) {
        phase = _executeCreateFile(command, data);
      }
      if (command is MoveFileCommand) {}
      if (command is UpdateFileContentCommand) {
        phase = _executeUpdateFile(command, data);
      }
      if (command is RenameFileCommand) {}
      if (command is ExecuteRepositoryCommand) {}

      // tipically we return this value at firs
      // to let logger notify about the command
      yield CommandExecutionStreamResponse(
        command: command,
        index: i,
        phase: phase,
      );
    }
  }

  ExecutionPhase _executeCreateFile(
    CreateFileCommand command,
    Map<String, dynamic> data,
  ) {
    return ExecutionPhase.success;
  }

  ExecutionPhase _executeUpdateFile(
    UpdateFileContentCommand command,
    Map<String, dynamic> data,
  ) {
    return ExecutionPhase.success;
  }

  ExecutionPhase _executeRenameFile(
    RenameFileCommand command,
    Map<String, dynamic> data,
  ) {
    return ExecutionPhase.success;
  }

  ExecutionPhase _executeMoveFile(
    MoveFileCommand command,
    Map<String, dynamic> data,
  ) {
    return ExecutionPhase.success;
  }

  ExecutionPhase _executeAnotherRepository(
    ExecuteRepositoryCommand command,
    Map<String, dynamic> data,
  ) {
    return ExecutionPhase.success;
  }
}
