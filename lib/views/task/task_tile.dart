import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ritammuddatask/models/task_model.dart';
import 'package:ritammuddatask/views/task/add_task.dart';
import 'package:ritammuddatask/views/task/task_dialogs.dart';
import 'package:ritammuddatask/views/task/task_view.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: InkWell(
        onTap: () => Navigator.push(context,
            CupertinoPageRoute(builder: (context) => TaskView(task: task))),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 12.0,
                spreadRadius: 1.0,
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withAlpha(100),
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 22.0,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          DateFormat("hh:mm a, d/M/yy").format(task.dueDate),
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.list_alt_rounded, size: 18.0),
                        const SizedBox(width: 5.0),
                        Flexible(
                          child: Text(
                            task.description,
                            style: const TextStyle(
                              fontSize: 15.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5.0),
              if (task.completionDate != null)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8.0,
                        spreadRadius: 1.0,
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withAlpha(100),
                      ),
                    ],
                  ),
                  child: const Icon(CupertinoIcons.checkmark_alt),
                )
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          CupertinoDialogRoute(
                              builder: (context) => AddTaskDialog(task: task),
                              context: context)),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.background,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8.0,
                              spreadRadius: 1.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withAlpha(100),
                            ),
                          ],
                        ),
                        child: const Icon(CupertinoIcons.pen),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          CupertinoDialogRoute(
                              builder: (context) =>
                                  TaskDeleteDialog(task: task),
                              context: context)),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.background,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8.0,
                              spreadRadius: 1.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withAlpha(100),
                            ),
                          ],
                        ),
                        child: const Icon(CupertinoIcons.trash),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
