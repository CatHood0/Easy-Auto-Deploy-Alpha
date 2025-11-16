import 'dart:convert';
import 'package:collection/collection.dart';
import '../../commands/command_base.dart';

class ProjectConfiguration {
  final int id;
  final int repoId;
  final String identifier;
  final bool requestForSudo;
  final List<EnvironmentVar> environmentVars;
  final List<CommandBase> commands;

  ProjectConfiguration({
    required this.id,
    required this.repoId,
    required this.identifier,
    required this.commands,
    required this.environmentVars,
    this.requestForSudo = true,
  });

  ProjectConfiguration copyWith({
    int? id,
    int? repoId,
    String? identifier,
    List<EnvironmentVar>? environmentVars,
    List<CommandBase>? steps,
    bool? requestForSudo,
  }) {
    return ProjectConfiguration(
      id: id ?? this.id,
      repoId: repoId ?? this.repoId,
      identifier: identifier ?? this.identifier,
      commands: steps ?? this.commands,
      environmentVars: environmentVars ?? this.environmentVars,
      requestForSudo: requestForSudo ?? this.requestForSudo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'repo_id': repoId,
      'identifier': identifier,
      'commands': json.encode(
        commands
            .map(
              (CommandBase x) => x.toJson(),
            )
            .toList(),
      ),
      'request_sudo': requestForSudo ? 1 : 0,
    };
  }

  factory ProjectConfiguration.fromMap(Map<String, dynamic> map) {
    return ProjectConfiguration(
      id: map['id']?.toInt() ?? -1,
      repoId: map['repo_id'] ?? -1,
      identifier: map['identifier'] ?? '',
      environmentVars: [],
      commands: List<CommandBase>.from(
        (json.decode(map['commands'] as String) as List<dynamic>).map(
          (dynamic x) => CommandBase.fromJson(
            x,
          ),
        ),
      ),
      requestForSudo: map['request_sudo'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectConfiguration.fromJson(String source) =>
      ProjectConfiguration.fromMap(json.decode(source));
  @override
  String toString() {
    return 'Arguments('
        'id: $id, '
        'repoId: $repoId, '
        'environmentVars: $environmentVars, '
        'commands: $commands, '
        'request_sudo: request_sudo, '
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProjectConfiguration &&
        other.id == id &&
        other.repoId == repoId &&
        other.identifier == identifier &&
        _deepCollectionEquality.equals(other.commands, commands) &&
        _deepCollectionEquality.equals(
            other.environmentVars, environmentVars) &&
        other.requestForSudo == requestForSudo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        identifier.hashCode ^
        commands.hashCode ^
        environmentVars.hashCode ^
        requestForSudo.hashCode;
  }
}

class EnvironmentVar {
  final int id;
  final int repoId;
  final String key;
  final String value;

  EnvironmentVar({
    required this.id,
    required this.repoId,
    required this.key,
    required this.value,
  });

  EnvironmentVar copyWith({
    int? id,
    int? repoId,
    String? key,
    String? value,
  }) {
    return EnvironmentVar(
      id: id ?? this.id,
      repoId: repoId ?? this.repoId,
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'repo_id': repoId,
      'key': key,
      'value': value,
    };
  }

  factory EnvironmentVar.fromMap(Map<String, dynamic> map) {
    return EnvironmentVar(
      id: map['id']?.toInt() ?? -1,
      repoId: map['repo_id'] ?? -1,
      key: map['key'] ?? '',
      value: map['value'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EnvironmentVar.fromJson(String source) =>
      EnvironmentVar.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Arguments('
        'id: $id, '
        'repoId: $repoId, '
        'key: $key, '
        'value: $value, '
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnvironmentVar &&
        other.key == key &&
        other.id == id &&
        other.repoId == repoId &&
        other.value == value;
  }

  @override
  int get hashCode =>
      key.hashCode ^ value.hashCode ^ id.hashCode ^ repoId.hashCode;
}

const DeepCollectionEquality _deepCollectionEquality = DeepCollectionEquality();
