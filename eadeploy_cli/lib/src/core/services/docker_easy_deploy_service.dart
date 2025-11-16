import 'dart:async';

import 'package:collection/collection.dart';
import 'package:eadeploy_cli/src/core/commands/command_base.dart';
import 'package:eadeploy_cli/src/core/entities/project/project.dart';
import 'package:eadeploy_cli/src/core/pipelines/git/check_git_existence_pipeline.dart';
import 'package:eadeploy_cli/src/core/pipelines/local/backup_project_pipeline.dart';
import 'package:eadeploy_cli/src/core/pipelines/local/destroy_backup_project_pipeline.dart';
import 'package:eadeploy_cli/src/core/pipelines/pipeline.dart';
import 'package:eadeploy_cli/src/core/pipelines/pipeline_event.dart';
import 'package:eadeploy_cli/src/core/services/services.dart';
import 'package:path/path.dart';

import '../../extensions/string_to_log_details.dart';
import '../logger/logger_details.dart';

class DockerDeployService {
  final List<PipelineEvent> stages = <PipelineEvent>[];
  final LoggerService logger = LoggerService();
  final PipelineStagesRunner runner = PipelineStagesRunner();

  static const String endMessage = 'End Of Deploy';

  DockerDeployService() {
    stages.addAll(<PipelineEvent>[
      CheckGitExistencePipeline(),
      BackupProjectPipeline(),
      DestroyBackupPipeline(),
    ]);
  }

  StreamSubscription<List<LogMessageDetail>> subscribe(
    void Function(List<LogMessageDetail>) callback, {
    void Function(Object)? onError,
    void Function(List<LogMessageDetail>)? onDone,
  }) {
    return logger.logs.listen(
      callback,
      cancelOnError: true,
      onError: onError,
      onDone: onDone != null
          ? () => onDone.call(
                <LogMessageDetail>[
                  ...logger.cache,
                  endMessage.toLog(),
                ],
              )
          : null,
    );
  }

  Future<void> deploy(
    Project project, {
    required String projectPath,
    void Function(int length)? processRunningLength,
    void Function(int progress, int length)? deployProgress,
  }) async {
    logger.clear();
    runner.reload();

    final List<PipelineEvent> tempStages = _initStages(project);
    runner.registerAll(tempStages);
    processRunningLength?.call(tempStages.length);

    //TODO: start stages running and handling exceptions
    //TODO: define what options should be putted at first place during
    //  running
    final Stream<Map<String, dynamic>> result = runner.run(<String, dynamic>{
      'project': project.toMap(),
      'project_path': projectPath,
    });

    await for (final Map<String, dynamic> v in result) {
      deployProgress?.call(0, tempStages.length);
    }
  }

  /// Returns all the stages but with the commands associated with them
  List<PipelineEvent> _initStages(Project project) {
    final List<CommandBase> commands = project.configuration.commands;
    final List<PipelineEvent> stagesWithCommands = <PipelineEvent>[
      ...stages.map(
        (PipelineEvent stage) => stage.clone(),
      ),
    ];

    for (PipelineEvent stage in stagesWithCommands) {
      final Iterable<CommandBase> stageCommands = commands.where(
        (CommandBase c) => c.assignedToPipeline == stage.identifier,
      );
      stage.attachAll(stageCommands);
    }

    // for non assigned commands, we just insert them at first stage
    final Iterable<CommandBase> nonAssignedCommands = commands.where(
      (CommandBase c) => c.assignedToPipeline.isEmpty,
    );

    if (nonAssignedCommands.isNotEmpty) {
      stagesWithCommands.first.attachAll(nonAssignedCommands);
    }

    return stagesWithCommands;
  }
}
