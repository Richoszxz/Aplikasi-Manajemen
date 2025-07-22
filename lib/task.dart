class Task {
  String title;
  DateTime deadline;
  int priority;

  Task({required this.title, required this.deadline, required this.priority});

  Map<String, dynamic> toJson() => {
    'title': title,
    'deadline': deadline.toIso8601String(),
    'priority': priority,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    deadline: DateTime.parse(json['deadline']),
    priority: json['priority'],
  );
}
