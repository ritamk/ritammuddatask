import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ritammuddatask/controllers/database_controller.dart';
import 'package:ritammuddatask/controllers/shared_pref.dart';
import 'package:ritammuddatask/models/task_model.dart';
import 'package:ritammuddatask/shared/shared.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key, this.task});
  final TaskModel? task;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  bool _submitting = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocus = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _descriptionFocus = FocusNode();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDueDate;
  String? _status;

  final List<String> statuses = TaskStatus.values.map((e) => e.name).toList();

  TaskModel? task;

  @override
  void initState() {
    if (widget.task != null) {
      task = widget.task;
      _titleController.text = task!.title;
      _descriptionController.text = task!.description;
      _selectedDueDate = task!.dueDate;
      _status = task!.dueDate.difference(DateTime.now()).inMinutes < 0
          ? TaskStatus.pending.name
          : task!.status;
      statuses.removeWhere((element) => element == "completed");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: CupertinoAlertDialog(
        title: Text(
          task != null ? "Edit task" : "Add task",
          style: TextStyle(
              fontFamily:
                  Theme.of(context).primaryTextTheme.bodyLarge!.fontFamily),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12.0),
                TextFormField(
                  focusNode: _titleFocus,
                  controller: _titleController,
                  decoration: authTextInputDecoration(
                      "Title", Icons.title_rounded, null, context),
                  validator: (value) => titleValidator(value, "title"),
                  textInputAction: TextInputAction.next,
                  minLines: 1,
                  maxLines: 2,
                  onFieldSubmitted: (val) =>
                      FocusScopeNode().requestFocus(_descriptionFocus),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  focusNode: _descriptionFocus,
                  controller: _descriptionController,
                  decoration: authTextInputDecoration(
                      "Description", Icons.list_alt_rounded, null, context),
                  validator: (value) => titleValidator(value, "description"),
                  textInputAction: TextInputAction.newline,
                  scrollPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 2.0),
                  minLines: 1,
                  maxLines: 4,
                  onFieldSubmitted: (val) => FocusScopeNode().unfocus(),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    onTap: () async {
                      final DateTime now = DateTime.now();
                      await showDatePicker(
                              firstDate: now,
                              lastDate:
                                  DateTime(now.year, now.month + 1, now.day),
                              context: context,
                              initialDate: now.add(const Duration(hours: 1)))
                          .then((value) =>
                              setState(() => _selectedDueDate = value));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Text(
                        _selectedDueDate != null
                            ? "Due date: ${DateFormat("d/M/y").format(_selectedDueDate!)}"
                            : "Select due date",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: Theme.of(context)
                                .primaryTextTheme
                                .bodyLarge!
                                .fontFamily),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    onTap: () async {
                      if (_selectedDueDate != null) {
                        await showTimePicker(
                          initialTime: TimeOfDay.now().replacing(minute: 0),
                          context: context,
                        ).then((value) => value != null
                            ? setState(() => _selectedDueDate = DateTime(
                                  _selectedDueDate!.year,
                                  _selectedDueDate!.month,
                                  _selectedDueDate!.day,
                                  value.hour,
                                  value.minute,
                                ))
                            : null);
                      } else {
                        Fluttertoast.showToast(msg: "Choose a date first");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Text(
                        _selectedDueDate != null
                            ? "Due time: ${DateFormat("hh:mm a").format(_selectedDueDate!)}"
                            : "Select due time",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: Theme.of(context)
                                .primaryTextTheme
                                .bodyLarge!
                                .fontFamily),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                if (task != null) const SizedBox(height: 10.0),
                if (task != null)
                  SizedBox(
                    width: double.infinity,
                    child: PopupMenuButton(
                      constraints:
                          BoxConstraints.loose(const Size(250.0, 350.0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      onSelected: (value) => setState(() => _status = value),
                      itemBuilder: (context) {
                        return <PopupMenuEntry<String>>[
                          for (String elem in statuses)
                            PopupMenuItem(
                              value: elem,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  elem,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                        ];
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _status!,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyLarge!
                                      .fontFamily),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(width: 10.0),
                            const Icon(Icons.keyboard_arrow_down_rounded)
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontFamily:
                      Theme.of(context).primaryTextTheme.bodyLarge!.fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              )),
          CupertinoDialogAction(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (_selectedDueDate != null) {
                  setState(() => _submitting = true);
                  await submitAction().then((val) {
                    Fluttertoast.showToast(
                        msg: val ? "Done!" : "Something went wrong");
                    Navigator.pop(context);
                  }).onError((error, stackTrace) {
                    Fluttertoast.showToast(msg: error.toString());
                    return null;
                  });
                } else {
                  Fluttertoast.showToast(
                      msg: "Please select due completion time");
                }
              }
            },
            child: !_submitting
                ? Text(
                    "Submit",
                    style: TextStyle(
                      fontFamily: Theme.of(context)
                          .primaryTextTheme
                          .bodyLarge!
                          .fontFamily,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const CupertinoActivityIndicator(),
          ),
        ],
      ),
    );
  }

  Future<bool> submitAction() async {
    if (_selectedDueDate!.difference(DateTime.now()).inMinutes > 0) {
      if (task != null) {
        return await DatabaseController(uid: LocalSharedPref.getUid()!)
            .modifyTask(
          TaskModel(
            title: widget.task!.title,
            status: widget.task!.status,
            creationDate: widget.task!.creationDate,
            dueDate: widget.task!.dueDate,
            description: widget.task!.description,
          ),
          TaskModel(
            title: _titleController.text.trim(),
            status: _status!,
            creationDate: widget.task!.creationDate,
            dueDate: _selectedDueDate!,
            description: _descriptionController.text.trim(),
          ),
          true,
        )
            .onError((error, stackTrace) {
          Fluttertoast.showToast(msg: error.toString());
          return false;
        });
      } else {
        return await DatabaseController(uid: LocalSharedPref.getUid()!)
            .addNewTask(TaskModel(
          title: _titleController.text.trim(),
          status: TaskStatus.started.name,
          creationDate: DateTime.now(),
          dueDate: _selectedDueDate!,
          description: _descriptionController.text.trim(),
        ))
            .onError((error, stackTrace) {
          Fluttertoast.showToast(msg: error.toString());
          return false;
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Due date can't be before current time");
      return false;
    }
  }

  String? titleValidator(String? value, String type) {
    if (value!.isEmpty) {
      return "Please enter a $type";
    }
    return null;
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _titleController.dispose();
    _descriptionFocus.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
