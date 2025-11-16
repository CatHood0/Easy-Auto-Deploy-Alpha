import 'dart:async';
import 'dart:io';

import 'package:auto_deployment/src/domain/services/required_services.dart';

import '../../../domain/enums/deployment_status.dart';

class GitInstallationChecker
    extends RequiredServices<void, (bool, DeploymentStatus)> {
  const GitInstallationChecker._();

  static const GitInstallationChecker instance = GitInstallationChecker._();

  @override
  String get serviceKey => 'git-installation-checker';

  @override
  String get serviceName => 'Git';

  @override
  Future<(bool, DeploymentStatus)> check(
    void d, {
    void Function(String)? log,
    void Function()? onFail,
    void Function()? onEnd,
  }) async {
    try {
  }
}
