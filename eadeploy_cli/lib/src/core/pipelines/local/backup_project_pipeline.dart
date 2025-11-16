import 'dart:io';
import 'dart:ui';

import 'package:eadeploy_cli/src/core/commands/command_base.dart';
import 'package:eadeploy_cli/src/core/pipelines/pipeline_event.dart';
import 'package:eadeploy_cli/src/core/pipelines/pipeline_runner.dart';
import 'package:eadeploy_cli/src/extensions/string_to_log_details.dart';
import 'package:uuid/v1.dart';

const UuidV1 _v1 = UuidV1();
final String _sep = Platform.pathSeparator;

/// This pipeline always is executed by safe docker commands execution
///
/// Since we can move or renamed some files, and something can fail at
/// any point, we don't want to do changes directly in cloned repo
class BackupProjectPipeline extends PipelineEvent {
  BackupProjectPipeline({
    super.preCommands,
    super.postCommands,
  });

  @override
  PipelineEvent clone({
    List<CommandBase>? preCommands,
    List<CommandBase>? postCommands,
  }) {
    return BackupProjectPipeline(
      preCommands: preCommands ?? super.preCommands,
      postCommands: postCommands ?? super.postCommands,
    );
  }

  @override
  String get identifier => 'Backup Project Event';

  //TODO: we will need to request the user password
  // by security
  @override
  Future<PipelineResponse<Map<String, dynamic>>> run(
    Map<String, dynamic> param, {
    VoidCallback? preRun,
  }) async {
    const String id = 'copying-file';
    preRun?.call();

    emitLog('Executing pre-commands in $runtimeType'.toLog());

    final PipelineResponse<Map<String, dynamic>> response =
        await executeCommands(
      param,
      preCommands,
    );

    if (response.hasError) {
      return response;
    }

    emitLog('Executing $runtimeType'.toLog());

    final String? curPath = param['project_path'] as String?;
    final Directory dir = Directory(curPath ?? '');

    // should never happen
    if (curPath == null || !(await dir.exists())) {
      throw Exception('Was not found path to make the backup');
    }

    final String path = '${dir.path}-${_v1.generate()}';

    emitLog('Making backup at $path'.toLog());

    final Directory backupDir = Directory(path);

    if (await backupDir.exists()) {
      emitLog('Deleting existing similar directory'.toLog());
      await backupDir.delete(recursive: false);
    }

    if (!(await backupDir.exists())) {
      await backupDir.create(recursive: false);
    }

    emitLog('Copying all the files in ${dir.path}'.toLog(id: id));

    await _copyStoragePath(
      dir,
      backupDir,
    );

    emitLog('Copied all the files from ${dir.path} to ${backupDir.path}'
        .toLog(id: id));

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
        'backup_path': backupDir.path,
      },
    );
  }

  @override
  bool revert(Map<String, dynamic> param) {
    if (param['backup_path'] == null || param['backup_path'] == "") {
      return false;
    }

    emitLog('Reverting $runtimeType change'.toLog());
    final String backupPath = param['backup_path'] as String;
    final Directory backupDir = Directory(backupPath);
    if (backupDir.existsSync()) {
      emitLog('Deleting backup at $backupPath'.toLog());
      backupDir.deleteSync(recursive: false);
    } else {
      emitLog(
        'The backup '
                'path does not exist '
                'at $backupPath, so, '
                'will be ignored'
            .toLogError(),
      );
    }

    return backupDir.existsSync();
  }

  Future<void> _copyStoragePath(
    FileSystemEntity? entity,
    Directory destDir,
  ) async {
    if (entity is Directory) {
      for (final FileSystemEntity entity in entity.listSync()) {
        final String name = _fileName(entity);

        if (entity is File) {
          await _copyStoragePath(entity, destDir);
        } else {
          await _copyStoragePath(entity, _joinDir(destDir, <String>[name]));
        }
      }
    } else if (entity is File) {
      final File destFile = _joinFile(destDir, <String>[_fileName(entity)]);

      if (!destFile.existsSync() ||
          entity.lastModifiedSync() != destFile.lastModifiedSync()) {
        destDir.createSync(recursive: true);
        entity.copySync(destFile.path);
      }
    } else {
      throw StateError('unexpected type: ${entity.runtimeType}');
    }
  }

  File _joinFile(Directory dir, List<String> files) {
    final String pathFragment = files.join(_sep);
    return File('${dir.path}$_sep$pathFragment');
  }

  Directory _joinDir(Directory dir, List<String> files) {
    final String pathFragment = files.join(_sep);
    return Directory('${dir.path}$_sep$pathFragment');
  }

  /// Return the last segment of the file path.
  String _fileName(FileSystemEntity entity) {
    final String name = entity.path;
    final int index = name.lastIndexOf(_sep);
    return (index != -1 ? name.substring(index + 1) : name);
  }
}
