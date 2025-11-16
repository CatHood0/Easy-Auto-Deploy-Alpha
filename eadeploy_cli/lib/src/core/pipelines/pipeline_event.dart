import 'package:eadeploy_cli/src/core/commands/runner/command_runner.dart';
import 'package:eadeploy_cli/src/core/entities/commands/command_execution_stream_response.dart';
import 'package:eadeploy_cli/src/core/logger/logger_details.dart';
import 'package:eadeploy_cli/src/core/pipelines/pipeline.dart';
import 'package:eadeploy_cli/src/core/pipelines/pipeline_runner.dart';
import '../commands/command_base.dart';

abstract class PipelineEvent extends PipelineJson {
  final List<CommandBase> preCommands;
  final List<CommandBase> postCommands;
  final List<LogCallbackWithDetails> _logSubscribers =
      <LogCallbackWithDetails>[];

  PipelineEvent({
    List<CommandBase>? preCommands,
    List<CommandBase>? postCommands,
  })  : preCommands = preCommands ?? <CommandBase>[],
        postCommands = postCommands ?? <CommandBase>[];

  PipelineEvent clone({
    List<CommandBase>? preCommands,
    List<CommandBase>? postCommands,
  });

  void attach(CommandBase command) {
    command.pre
        ? preCommands.add(command)
        : postCommands.add(
            command,
          );
  }

  void attachAll(Iterable<CommandBase> commands) {
    for (CommandBase v in commands) {
      attach(v);
    }
  }

  @override
  String get identifier;

  @override
  void subscribe(LogCallbackWithDetails callback) {
    _logSubscribers.add(callback);
  }

  @override
  void unSubscribe(LogCallbackWithDetails callback) {
    _logSubscribers.remove(callback);
  }

  Future<PipelineResponse<Map<String, dynamic>>> executeCommands(
    Map<String, dynamic> data,
    List<CommandBase> commands,
  ) async {
    final CommandExecuter executer = data['command_runner'] as CommandExecuter;
    final Stream<CommandExecutionStreamResponse> result = executer.execute(
      data,
      commands,
    );

    await for (final CommandExecutionStreamResponse response in result) {
      if (response.command.criticalCommand && response.endWithError) {
        emitLog(
          LogMessageDetail.error(
            log: 'The command #${response.index} '
                'was not executed sucessfully '
                'by: ${response.error}',
          ),
        );
        return PipelineResponse<Map<String, dynamic>>.error(
          error: 'Unknown error during '
              'executing the command '
              '#${response.index} in '
              '$runtimeType',
          requireRevert: false,
          stopRunning: true,
        );
      }
    }
    return PipelineResponse<Map<String, dynamic>>.success(data: data);
  }

  @override
  void unSubscribeAll() {
    //NOTE: should we notify to the listeners about the end?
    _logSubscribers.clear();
  }

  void emitLog(LogMessageDetail log) {
    for (final LogCallbackWithDetails subscriber in _logSubscribers) {
      subscriber(log);
    }
  }
}
