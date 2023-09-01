import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ritammuddatask/models/task_model.dart';
import 'package:ritammuddatask/views/task/task_dialogs.dart';

class TaskView extends StatelessWidget {
  const TaskView({super.key, required this.task});
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: const Text("Task"),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Theme.of(context).colorScheme.onBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8.0,
                            spreadRadius: 1.0,
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withAlpha(100),
                          )
                        ],
                      ),
                      child: Text(
                        task.dueDate.difference(DateTime.now()).inMinutes < 0
                            ? TaskStatus.pending.name
                            : task.status,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.background,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Divider(),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TaskTagContainer(
                            child: Text(
                              "due date",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            DateFormat("hh:mm a, d/M/yy").format(task.dueDate),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50.0, child: VerticalDivider()),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TaskTagContainer(
                            child: Text(
                              "created on",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            DateFormat("hh:mm a, d/M/yy")
                                .format(task.creationDate),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Divider(),
                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TaskTagContainer(
                        child: Text(
                          "description",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        task.description,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80.0),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: task.completionDate != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                clipBehavior: Clip.none,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12.0,
                      spreadRadius: 1.0,
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(100),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Completed at:\t",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    Text(
                      DateFormat("hh:mm a, d/M/yy")
                          .format(task.completionDate!),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    CupertinoDialogRoute(
                      builder: (context) => TaskCompletionDialog(task: task),
                      context: context,
                    )),
                child: Container(
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12.0,
                        spreadRadius: 1.0,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(100),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_rounded,
                          color: Theme.of(context).colorScheme.onPrimary),
                      Text(
                        "\tMark as done",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class TaskTagContainer extends StatelessWidget {
  const TaskTagContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).colorScheme.onBackground,
      ),
      child: child,
    );
  }
}
