import 'dart:ui';
import 'dart:io';
import 'package:eadeploy_cli/src/core/commands/command_base.dart';
import 'package:eadeploy_cli/src/core/pipelines/pipeline_event.dart';
import 'package:eadeploy_cli/src/core/pipelines/pipeline_runner.dart';

class CheckGitExistencePipeline extends PipelineEvent {
  CheckGitExistencePipeline({
    super.preCommands,
    super.postCommands,
  });

  @override
  Future<PipelineResponse<Map<String, dynamic>>> run(
    Map<String, dynamic> param, {
    VoidCallback? preRun,
  }) async {
    emitLog.call('Checking git existence');
    //TODO: should we suscribe to the run events to log them?
    final ProcessResult process = await Process.run('git', <String>['-v']);

    final int exitCode = process.exitCode;

    if (exitCode == 0 || process.stderr == null) {
      emitLog.call('✅ Git is already installed in the current device');
      return PipelineResponse<Map<String, dynamic>>.success(data: param);
    }
    emitLog.call('❌ Git no está instalado');
    return PipelineResponse<Map<String, dynamic>>.error(
      error: 'Git is not installed in the current OS',
      requireRevert: false,
      stopRunning: true,
    );
  }

  @override
  PipelineEvent clone({
    List<CommandBase>? preCommands,
    List<CommandBase>? postCommands,
  }) {
    return CheckGitExistencePipeline(
      preCommands: preCommands ?? super.preCommands,
      postCommands: postCommands ?? super.postCommands,
    );
  }

  @override
  String get identifier => 'Check Git Existence';

  @override
  bool revert(Map<String, dynamic> param) => true;
}
