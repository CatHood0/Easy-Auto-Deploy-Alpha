import 'package:eadeploy_cli/src/core/entities/project/project_configs.dart';

class Project {
  final String id;
  final String repositoryUrl;
  final String repositoryBranch;
  final String containerName;
  final bool requireAuth;
  final ProjectConfiguration configuration;
  final DateTime updatedAt;

  Project({
    required this.id,
    required this.repositoryUrl,
    required this.containerName,
    required this.configuration,
    DateTime? updatedAt,
    this.requireAuth = true,
    this.repositoryBranch = 'master',
  }) : updatedAt = updatedAt ?? DateTime.now();

  Project copyWith({
    String? id,
    String? repositoryUrl,
    String? repositoryBranch,
    String? containerName,
    bool? requireAuth,
    ProjectConfiguration? configuration,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      repositoryUrl: repositoryUrl ?? this.repositoryUrl,
      repositoryBranch: repositoryBranch ?? this.repositoryBranch,
      requireAuth: requireAuth ?? this.requireAuth,
      containerName: containerName ?? this.containerName,
      configuration: configuration ?? this.configuration,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'repo': repositoryUrl,
      'branch': repositoryBranch,
      'require_auth': requireAuth,
      'image_name': containerName,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'configurations': configuration.toMap(),
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id']?.toInt() ?? -1,
      repositoryUrl: map['repo'] ?? '',
      repositoryBranch: map['branch'] ?? '',
      requireAuth: map['require_auth'] == 1 ? true : false,
      containerName: map['image_name'],
      configuration: ProjectConfiguration.fromMap(map['configurations']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['updated_at'] as int,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Project &&
        other.id == id &&
        other.repositoryUrl == repositoryUrl &&
        other.repositoryBranch == repositoryBranch &&
        other.containerName == containerName &&
        other.updatedAt == updatedAt &&
        other.requireAuth == requireAuth &&
        other.configuration == configuration;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        repositoryUrl.hashCode ^
        repositoryBranch.hashCode ^
        updatedAt.hashCode ^
        requireAuth.hashCode ^
        containerName.hashCode ^
        configuration.hashCode;
  }
}
