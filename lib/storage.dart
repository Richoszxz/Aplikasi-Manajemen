import 'dart:io';
import 'dart:convert';
import 'task.dart';

String getFilePath() {
  // Ambil path folder tempat aplikasi dijalankan dari terminal 
  final directory = Directory.current;
  final path = '${directory.path}/tasks.json';
  return path;
}

Future<void> saveTasks(List<Task> tasks) async { //untuk mengarahkan hasil input ke file json
  final path = getFilePath();
  final file = File(path);
  final jsonList = tasks.map((task) => task.toJson()).toList(); 
  await file.writeAsString(jsonEncode(jsonList)); // digunakan untuk menyimpan dta dlm json
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

  // Error handling untuk pengambilan data
  try {
    final List<dynamic> jsonList = jsonDecode(contents); // eror jika file kosong dnmc tipe data berubah ubah 
    return jsonList.map((json) => Task.fromJson(json)).toList();//membuat objek
  } catch (e) {
    print('❌ Gagal membaca file JSON: $e');
    return [];
  }
}