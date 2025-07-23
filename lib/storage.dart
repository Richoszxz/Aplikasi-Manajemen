import 'dart:io';
import 'dart:convert';
import 'task.dart';

String getFilePath() {
  // Ambil path folder tempat aplikasi dijalankan (biasanya root project)
  final directory = Directory.current;
  final path = '${directory.path}/tasks.json';
  return path;
}

Future<void> saveTasks(List<Task> tasks) async { //fungsi untuk mengarahkan hasil input ke file json
  final path = getFilePath();
  final file = File(path);
  final jsonList = tasks.map((task) => task.toJson()).toList();
  await file.writeAsString(jsonEncode(jsonList)); // digunakan untuk menyimpan dta dlm file json
  // print('✅ Data disimpan di: $path');
}

Future<List<Task>> loadTasks() async { // memuat data tugas 
  final path = await getFilePath();
  final file = File(path);

  if (!file.existsSync()) {
    print('⚠️ File tasks.json tidak ditemukan di: $path');
    return [];
  }

  final contents = file.readAsStringSync(); // untuk membaca isi file json

  if (contents.trim().isEmpty) {
    print('⚠️ File kosong, mengembalikan list kosong.');
    return [];
  }

  try {
    final List<dynamic> jsonList = jsonDecode(contents); // eror jika file kosong dnmc tipe data berubah ubah 
    return jsonList.map((json) => Task.fromJson(json)).toList();
  } catch (e) {
    print('❌ Gagal membaca file JSON: $e');
    return [];
  }
}

// KODE COBA COBA

// import 'dart:io';
// import 'dart:convert';
// import 'task.dart';

// const String fileName = 'tasks.json';

// Future<List<Task>> loadTasks() async {
//   final file = File(fileName);
//   if (!file.existsSync()) {
//     file.writeAsStringSync('[]');
//   }

//   final content = await file.readAsString();
//   final List<dynamic> jsonData = json.decode(content);
//   return jsonData.map((item) => Task.fromJson(item)).toList();
// }

// Future<void> saveTasks(List<Task> tasks) async {
//   final file = File(fileName);
//   final jsonData = tasks.map((task) => task.toJson()).toList();
//   await file.writeAsString(json.encode(jsonData), flush: true);
// }
