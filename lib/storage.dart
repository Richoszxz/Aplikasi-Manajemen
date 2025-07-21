import 'dart:io';
import 'dart:convert';
import 'task.dart';

const String fileName = '../tasks.json';

Future<List<Task>> loadTasks() async {
  final file = File(fileName);
  if (!file.existsSync()) {
    file.writeAsStringSync('[]');
  }

  final content = await file.readAsString();
  final List<dynamic> jsonData = json.decode(content);
  return jsonData.map((item) => Task.fromJson(item)).toList();
}

Future<void> saveTasks(List<Task> tasks) async {
  final file = File(fileName);
  final jsonData = tasks.map((task) => task.toJson()).toList();
  await file.writeAsString(json.encode(jsonData), flush: true);
}
