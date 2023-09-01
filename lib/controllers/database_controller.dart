import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ritammuddatask/models/task_model.dart';
import 'package:ritammuddatask/models/user_model.dart';

class DatabaseController {
  DatabaseController({required this.uid});

  final String uid;

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("Users");

  Future<bool> setInitialUserData(UserModel user) async {
    try {
      await _userCollection.doc(uid).set({
        "uid": user.uid,
        "name": user.name,
        "email": null,
        "tasks": [],
        "finishedTasks": [],
      }).onError((error, stackTrace) => false);
      return true;
    } catch (e) {
      throw "Something went wrong ($e)";
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final DocumentSnapshot docSnap =
          await _userCollection.doc(uid).get().timeout(networkTimeout);
      final dynamic docData = docSnap.data();

      if (docData != null) {
        List<TaskModel> tasks = <TaskModel>[];
        List<TaskModel> finishedTasks = <TaskModel>[];
        for (dynamic element in docData["tasks"]) {
          tasks.add(TaskModel(
            title: element["title"],
            status: element["status"],
            creationDate: element["creationDate"]?.toDate(),
            dueDate: element["dueDate"]?.toDate(),
            description: element["description"],
          ));
        }
        for (dynamic element in docData["finishedTasks"]) {
          finishedTasks.add(TaskModel(
            title: element["title"],
            status: element["status"],
            creationDate: element["creationDate"]?.toDate(),
            dueDate: element["dueDate"]?.toDate(),
            completionDate: element["completionDate"]?.toDate(),
            description: element["description"],
          ));
        }

        return UserModel(
          uid: docData["uid"],
          name: docData["name"],
          email: docData["email"],
          tasks: tasks,
          finishedTasks: finishedTasks,
        );
      } else {
        return null;
      }
    } catch (e) {
      throw "Something went wrong ($e)";
    }
  }

  Future<bool> addNewTask(TaskModel task) async {
    try {
      await _userCollection.doc(uid).update({
        "tasks": FieldValue.arrayUnion([
          {
            "title": task.title,
            "status": task.status,
            "creationDate": Timestamp.now(),
            "dueDate": Timestamp.fromDate(task.dueDate),
            "description": task.description,
          }
        ]),
      }).onError((error, stackTrace) => false);

      return true;
    } catch (e) {
      throw "Something went wrong ($e)";
    }
  }

  Future<bool> modifyTask(
      TaskModel? oldTask, TaskModel? newTask, bool isEditing) async {
    try {
      await _userCollection.doc(uid).update({
        "tasks": FieldValue.arrayRemove([
          {
            "title": oldTask!.title,
            "status": oldTask.status,
            "creationDate": Timestamp.fromDate(oldTask.creationDate),
            "dueDate": Timestamp.fromDate(oldTask.dueDate),
            "description": oldTask.description,
          }
        ]),
      }).onError((error, stackTrace) => false);
      if (isEditing) {
        await _userCollection.doc(uid).update({
          "tasks": FieldValue.arrayUnion([
            {
              "title": newTask!.title,
              "status": newTask.status,
              "creationDate": Timestamp.fromDate(newTask.creationDate),
              "dueDate": Timestamp.fromDate(newTask.dueDate),
              "description": newTask.description,
            }
          ]),
        }).onError((error, stackTrace) => false);
      }

      return true;
    } catch (e) {
      throw "Something went wrong ($e)";
    }
  }

  Future<bool> markTaskComplete(TaskModel task) async {
    try {
      await _userCollection.doc(uid).update({
        "tasks": FieldValue.arrayRemove([
          {
            "title": task.title,
            "status": task.status,
            "creationDate": Timestamp.fromDate(task.creationDate),
            "dueDate": Timestamp.fromDate(task.dueDate),
            "description": task.description,
          }
        ]),
      }).onError((error, stackTrace) => false);
      await _userCollection.doc(uid).update({
        "finishedTasks": FieldValue.arrayUnion([
          {
            "title": task.title,
            "status": TaskStatus.completed.name,
            "creationDate": Timestamp.fromDate(task.creationDate),
            "dueDate": Timestamp.fromDate(task.dueDate),
            "completionDate": Timestamp.now(),
            "description": task.description,
          }
        ]),
      }).onError((error, stackTrace) => false);

      return true;
    } catch (e) {
      throw "Something went wrong ($e)";
    }
  }

  final Duration networkTimeout = const Duration(seconds: 10);
}
