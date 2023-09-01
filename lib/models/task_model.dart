class TaskModel {
  final String title;
  final String status;
  final DateTime creationDate;
  final DateTime dueDate;
  final DateTime? completionDate;
  final String description;

  TaskModel({
    required this.title,
    required this.status,
    required this.creationDate,
    required this.dueDate,
    this.completionDate,
    required this.description,
  });
}

enum TaskStatus {
  urgent,
  started,
  pending,
  completed,
}
