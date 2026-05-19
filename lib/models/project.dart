class Project {
  final String id;
  final String userId;
  final String name;
  final String code;
  final bool isDeleted;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.userId,
    required this.name,
    required this.code,
    this.isDeleted = false,
    required this.createdAt,
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      isDeleted: map['is_deleted'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'code': code,
      'is_deleted': isDeleted,
    };
  }

  Project copyWith({String? name, String? code, bool? isDeleted}) {
    return Project(
      id: id,
      userId: userId,
      name: name ?? this.name,
      code: code ?? this.code,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt,
    );
  }
}

