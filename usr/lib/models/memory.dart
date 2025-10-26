class Memory {
  final String id;
  final String title;
  final String description;
  final MemoryType type;
  final DateTime createdDate;
  final DateTime? memoryDate;
  final List<String> tags;
  // TODO: Add media fields (imageUrl, videoUrl, audioUrl) when implementing media handling

  Memory({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.createdDate,
    this.memoryDate,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'createdDate': createdDate.toIso8601String(),
      'memoryDate': memoryDate?.toIso8601String(),
      'tags': tags,
    };
  }

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: MemoryType.values.firstWhere((e) => e.name == json['type']),
      createdDate: DateTime.parse(json['createdDate']),
      memoryDate: json['memoryDate'] != null ? DateTime.parse(json['memoryDate']) : null,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}

enum MemoryType {
  text,
  photo,
  video,
  audio,
}

class TimeCapsule {
  final String id;
  final String title;
  final String message;
  final String? recipient;
  final DateTime createdDate;
  final DateTime unlockDate;
  final bool isPrivate;

  TimeCapsule({
    required this.id,
    required this.title,
    required this.message,
    this.recipient,
    required this.createdDate,
    required this.unlockDate,
    this.isPrivate = false,
  });

  bool get isUnlocked => DateTime.now().isAfter(unlockDate);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'recipient': recipient,
      'createdDate': createdDate.toIso8601String(),
      'unlockDate': unlockDate.toIso8601String(),
      'isPrivate': isPrivate,
    };
  }

  factory TimeCapsule.fromJson(Map<String, dynamic> json) {
    return TimeCapsule(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      recipient: json['recipient'],
      createdDate: DateTime.parse(json['createdDate']),
      unlockDate: DateTime.parse(json['unlockDate']),
      isPrivate: json['isPrivate'] ?? false,
    );
  }
}