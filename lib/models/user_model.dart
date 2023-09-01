import 'package:flutter/cupertino.dart';
import 'package:ritammuddatask/models/task_model.dart';

class UserModel {
  final String uid;
  final String? name;
  final String? email;
  final List<TaskModel>? tasks;
  final List<TaskModel>? finishedTasks;

  UserModel({
    required this.uid,
    this.name,
    this.email,
    this.tasks,
    this.finishedTasks,
  });
}

class ThemeModel {
  final Color color;
  final bool dark;

  ThemeModel({
    required this.color,
    required this.dark,
  });
}
