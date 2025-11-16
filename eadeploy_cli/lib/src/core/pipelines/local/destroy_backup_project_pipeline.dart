import 'dart:io';
import 'dart:ui';

import 'package:eadeploy_cli/src/core/commands/command_base.dart';
import 'package:eadeploy_cli/src/core/pipelines/pipeline_event.dart';
import 'package:eadeploy_cli/src/core/pipelines/pipeline_runner.dart';

import '../../../extensions/string_to_log_details.dart';

/// This pipeline always when the project is already builded (docker build)
/// to destroy the backup (free disk space)
class DestroyBackupPipeline extends PipelineEvent {
  DestroyBackupPipeline({
    super.preCommands,
    super.postCommands,
  });

  @override
  PipelineEvent clone({
    List<CommandBase>? preCommands,
    List<CommandBase>? postCommands,
  }) {
    return DestroyBackupPipeline(
      preCommands: preCommands ?? super.preCommands,
      postCommands: postCommands ?? super.postCommands,
    );
  }

  @override
  String get identifier => 'Destroy Backup Event';

  @override
  Future<PipelineResponse<Map<String, dynamic>>> run(
    Map<String, dynamic> param, {
    VoidCallback? preRun,
  }) async {
    preRun?.call();
    // at this point this need to be into the params
    emitLog('Executing pre-commands in $runtimeType'.toLog());

    final PipelineResponse<Map<String, dynamic>> response =
        await executeCommands(
      param,
      postCommands,
    );
    if (response.hasError) {
      return response;
    }

    final String? path = param['backup_path'] as String?;

    // if path does not exist, means that the user marked
    // previously an option to avoid executing backups
    if (path != null && path.isNotEmpty) {
      final Directory dir = Directory(path);

      // removes all the files in the backup, since
      // we don't require them anymore
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    }

    emitLog('Executing post-commands in $runtimeType'.toLog());

    final PipelineResponse<Map<String, dynamic>> response2 =
        await executeCommands(
      param,
      postCommands,
    );

    if (response2.hasError) {
      return response2;
    }

    return PipelineResponse<Map<String, dynamic>>.success(
      data: <String, dynamic>{
        ...param,
        'backup_path': null,
        'can_continue_stage': true,
      },
    );
  }

  // at this point we cannot revert this action, so
  @override
  bool revert(Map<String, dynamic> param) => true;
}
