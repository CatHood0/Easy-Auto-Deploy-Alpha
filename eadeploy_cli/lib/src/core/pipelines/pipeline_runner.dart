import 'dart:ui';
import '../logger/logger_details.dart';
import 'pipeline.dart';

typedef LogCallbackWithDetails = void Function(LogMessageDetail);

abstract class PipelineRunner<T, R extends Object?> {
  PipelineStagesRunner? parent;
  int index = -1;

  PipelineJson? get previous => index == -1 || parent == null
      ? parent?.stages.elementAtOrNull(index - 1)
      : null;

  PipelineJson? get next => index == -1 || parent == null
      ? parent?.stages.elementAtOrNull(index + 1)
      : null;

  /// Register the a simple
  void subscribe(LogCallbackWithDetails callback);

  void unSubscribe(LogCallbackWithDetails callback);

  /// Tipically called when the stage ends and does not
  /// require more listeners
  void unSubscribeAll();

  String get identifier;

  /// Revert all the changes as possible
  Future<bool> revert(R param);

  /// Runs the runner
  Future<PipelineResponse<T>> run(
    R param, {
    VoidCallback? preRun,
  });
}

class PipelineResponse<T> {
  final T? data;
  final Object? error;
  final bool requireRevert;
  final bool stopRunning;

  PipelineResponse({
    required this.data,
    required this.error,
    required this.stopRunning,
    this.requireRevert = false,
  });

  PipelineResponse.error({
    required this.error,
    required this.requireRevert,
    required this.stopRunning,
  }) : data = null;

  PipelineResponse.success({
    required this.data,
  })  : assert(
          data != null,
          'data should '
          'not be null if the '
          'pipeline was '
          'executed sucessfully',
        ),
        requireRevert = false,
        stopRunning = false,
        error = null;

  bool get hasError => error != null;

  bool get hasData => data != null;

  T get castData => data!;
}
