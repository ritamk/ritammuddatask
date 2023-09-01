import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ritammuddatask/controllers/database_controller.dart';
import 'package:ritammuddatask/controllers/shared_pref.dart';
import 'package:ritammuddatask/models/task_model.dart';
import 'package:ritammuddatask/views/home/home_view.dart';

class TaskCompletionDialog extends StatefulWidget {
  const TaskCompletionDialog({super.key, required this.task});
  final TaskModel task;

  @override
  State<TaskCompletionDialog> createState() => _TaskCompletionDialogState();
}

class _TaskCompletionDialogState extends State<TaskCompletionDialog> {
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: CupertinoAlertDialog(
        title: const Text("Mark as done"),
        content: const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("Are you sure you want to mark this task as completed?"),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              setState(() => _submitting = true);
              await markTaskComplete().whenComplete(() =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const HomeView()),
                      (route) => false));
            },
            child: !_submitting
                ? const Text("Yes")
                : const CupertinoActivityIndicator(),
          ),
        ],
      ),
    );
  }

  Future<void> markTaskComplete() async {
    await DatabaseController(uid: LocalSharedPref.getUid()!)
        .markTaskComplete(TaskModel(
      title: widget.task.title,
      status: widget.task.status,
      creationDate: widget.task.creationDate,
      dueDate: widget.task.dueDate,
      description: widget.task.description,
    ));
  }
}

class TaskDeleteDialog extends StatefulWidget {
  const TaskDeleteDialog({super.key, required this.task});
  final TaskModel task;

  @override
  State<TaskDeleteDialog> createState() => _TaskDeleteDialogState();
}

class _TaskDeleteDialogState extends State<TaskDeleteDialog> {
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: CupertinoAlertDialog(
        title: const Text("Delete task"),
        content: const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("Are you sure you want to delete this task?"),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              setState(() => _submitting = true);
              await deleteTask().whenComplete(() => Navigator.pop(context));
            },
            child: !_submitting
                ? const Text("Yes")
                : const CupertinoActivityIndicator(),
          ),
        ],
      ),
    );
  }

  Future<void> deleteTask() async {
    await DatabaseController(uid: LocalSharedPref.getUid()!)
        .modifyTask(widget.task, null, false);
  }
}
