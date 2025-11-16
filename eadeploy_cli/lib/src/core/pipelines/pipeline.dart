import 'package:eadeploy_cli/src/core/pipelines/pipeline_runner.dart';
import '../commands/runner/command_runner.dart';

// make this more readable
typedef PipelineJson
    = PipelineRunner<Map<String, dynamic>, Map<String, dynamic>>;
typedef PipelineEventEmitCallback = void Function(PipelineJson event);

class PipelineStagesRunner {
  PipelineStagesRunner({
    List<PipelineJson>? stages,
  }) : stages = stages ?? <PipelineJson>[];

  final List<PipelineJson> stages;
  final List<PipelineEventEmitCallback> _listeners =
      <PipelineEventEmitCallback>[];
  final CommandExecuter executer = CommandExecuter();

  bool get hasListeners => _listeners.isNotEmpty;

  void registerEventListener(PipelineEventEmitCallback callback) {
    _listeners.add(callback);
  }

  void removeListener(PipelineEventEmitCallback callback) {
    _listeners.remove(callback);
  }

  void removeAllListeners() {
    _listeners.clear();
  }

  /// Adds new runner at the end of the pipeline
  void register(PipelineJson stage) {
    stages.add(
      stage
        ..parent = this
        ..index = stages.length,
    );
  }

  void registerAll(List<PipelineJson> events) {
    for (final PipelineJson event in events) {
      register(event);
    }
  }

  void reload() {
    stages.clear();
    removeAllListeners();
  }

  Stream<Map<String, dynamic>> run(Map<String, dynamic> param) async* {
    if (stages.isEmpty) {
      yield <String, dynamic>{
        'error': 'There\'s no stages to execute',
      };
      return;
    }
    //TODO: we need to listen for interruptions during execution
    // to revert changes directly
    PipelineJson? stage = stages.firstOrNull;
    Map<String, dynamic> data = param;
    while (stage != null) {
      // use the last info, and transform it to the required info for the next one
      final PipelineResponse<Map<String, dynamic>> response = await stage.run(
        <String, dynamic>{
          ...data,
          'command_runner': executer,
        },
        preRun: () {
          for (PipelineEventEmitCallback v in _listeners) {
            v(stage!);
          }
        },
      );

      stage.unSubscribeAll();

      if (response.hasError && response.stopRunning) {
        if (response.requireRevert) {
          await stage.revert(param);
        }
        yield <String, dynamic>{
          'error': response.error,
          // used normally to pass to the revert operations
          // to know what was used to make the change at first
          // place
          'data': data,
          'stages': <String, Object>{
            'require_revert': true,
            'list': stages.take(stage.index),
          },
        };
        return;
      }
      stage = stage.next;
    }

    yield <String, dynamic>{};
  }
}
