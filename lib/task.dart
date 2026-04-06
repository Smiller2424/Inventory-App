class Task {
  String id;
  String name;
  bool isCompleted;

  Task({
    required this.id,
    required this.name,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      name: data['name'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
    );
  }
}