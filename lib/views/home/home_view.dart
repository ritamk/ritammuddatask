import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ritammuddatask/controllers/database_controller.dart';
import 'package:ritammuddatask/controllers/shared_pref.dart';
import 'package:ritammuddatask/models/task_model.dart';
import 'package:ritammuddatask/models/user_model.dart';
import 'package:ritammuddatask/shared/error_view.dart';
import 'package:ritammuddatask/views/home/home_loading.dart';
import 'package:ritammuddatask/views/settings/settings.dart';
import 'package:ritammuddatask/views/task/add_task.dart';
import 'package:ritammuddatask/views/task/task_tile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _loading = true;
  bool _reloading = false;
  bool _errorLoading = false;
  UserModel? user;

  bool _incompleteTasks = true;

  @override
  void initState() {
    getUser().then((value) {
      if (value != null) {
        setState(() => user = value);
      } else {
        setState(() => _errorLoading = true);
      }
    }).whenComplete(() => setState(() => _loading = false));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_errorLoading
        ? !_loading
            ? Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            _reloading = true;
                            _errorLoading = false;
                          });
                          await getUser().then((value) {
                            if (value != null) {
                              setState(() => user = value);
                            } else {
                              setState(() => _errorLoading = true);
                            }
                          }).whenComplete(
                              () => setState(() => _reloading = false));
                        },
                        icon: !_reloading
                            ? const Icon(Icons.refresh_rounded)
                            : const CupertinoActivityIndicator(),
                        visualDensity: VisualDensity.compact,
                        tooltip: "Refresh",
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, ${user!.name}",
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              " ${user!.tasks!.length} incomplete "
                              "${user!.tasks!.length > 1 ? "tasks" : "task"}",
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const SettingsView())),
                        icon: const Icon(Icons.settings_outlined),
                        visualDensity: VisualDensity.compact,
                        tooltip: "Settings",
                      )
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      bottom: 24.0, left: 24.0, right: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  _incompleteTasks
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                ),
                                shape: MaterialStatePropertyAll(
                                  StadiumBorder(
                                    side: BorderSide(
                                      width: 2,
                                      color: _incompleteTasks
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () =>
                                  setState(() => _incompleteTasks = true),
                              child: Text(
                                "Incomplete",
                                style: TextStyle(
                                    color: _incompleteTasks
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                    fontWeight: _incompleteTasks
                                        ? FontWeight.bold
                                        : null),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Expanded(
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  _incompleteTasks
                                      ? Colors.transparent
                                      : Theme.of(context).colorScheme.primary,
                                ),
                                shape: MaterialStatePropertyAll(
                                  StadiumBorder(
                                    side: BorderSide(
                                      width: 2,
                                      color: _incompleteTasks
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () =>
                                  setState(() => _incompleteTasks = false),
                              child: Text(
                                "Completed",
                                style: TextStyle(
                                    color: _incompleteTasks
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onBackground
                                        : Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                    fontWeight: _incompleteTasks
                                        ? null
                                        : FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      if (_incompleteTasks
                          ? user!.tasks!.isNotEmpty
                          : user!.finishedTasks!.isNotEmpty)
                        for (TaskModel task in _incompleteTasks
                            ? user!.tasks!
                            : user!.finishedTasks!)
                          TaskTile(task: task)
                      else
                        Center(
                          child: ErrorView(
                              message:
                                  "Could not find any ${_incompleteTasks ? "incomplete" : "completed"} tasks"),
                        ),
                    ],
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        CupertinoDialogRoute(
                          barrierDismissible: false,
                          builder: (context) => const AddTaskDialog(),
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
                          Icon(Icons.add_rounded,
                              color: Theme.of(context).colorScheme.onPrimary),
                          Text(
                            "\tAdd task",
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
              )
            : const HomeLoadingShimmer()
        : const Center(child: ErrorView(message: "Could not load any data"));
  }

  void refreshMethod() async {
    setState(() {
      _reloading = true;
      _errorLoading = false;
    });
    await getUser().then((value) {
      if (value != null) {
        setState(() => user = value);
      } else {
        setState(() => _errorLoading = true);
      }
    }).whenComplete(() => setState(() => _reloading = false));
  }

  Future<UserModel?> getUser() async {
    return await DatabaseController(uid: LocalSharedPref.getUid()!)
        .getUserData()
        .onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
      return null;
    });
  }
}
