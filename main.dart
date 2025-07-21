import 'dart:io';
import '../lib/task.dart';
import '../lib/storage.dart';

// Fungsi untuk memberi warna pada teks berdasarkan prioritas
String getColorForPriority(int priority) {
  switch (priority) {
    case 1:
      return '\x1B[31m'; // Merah
    case 2:
      return '\x1B[33m'; // Kuning
    case 3:
      return '\x1B[32m'; // Hijau
    default:
      return '\x1B[0m';  // Default
  }
}

void main() async {
  List<Task> tasks = await loadTasks();

  while (true) {
    stdout.write('\x1B[2J\x1B[0;0H'); // Clear terminal
    print('=== APLIKASI MANAJEMEN TUGAS DENGAN REMINDER ===');

    // Fitur 1: Tampilkan tugas yang sudah lewat deadline
    final now = DateTime.now();
    final expiredTasks = tasks
        .where((t) => t.deadline.isBefore(now))
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
    if (expiredTasks.isNotEmpty) {
      print('\n⏰ Tugas yang sudah melewati deadline ⏰');
      for (var t in expiredTasks) {
        final color = getColorForPriority(t.priority);
        print('$color- ${t.title} | Deadline: ${t.deadline} | Prioritas: ${t.priority}\x1B[0m');
      }
    }

    // Menu utama
    print('\nMenu Utama:');
    print('1. Tambah Tugas');
    print('2. Lihat Semua Tugas');
    print('3. Hapus Tugas');
    print('4. Keluar');
    stdout.write('Pilih menu (1/2/3/4): ');
    print("\n=================================================");
    final choice = stdin.readLineSync();

    if (choice == '1') {
      stdout.write('\nJudul Tugas     : ');
      final title = stdin.readLineSync() ?? '';

      stdout.write('Deadline (yyyy-mm-dd HH:mm): ');
      final deadlineInput = stdin.readLineSync();
      final deadline = DateTime.tryParse(deadlineInput ?? '') ??
          DateTime.now().add(Duration(days: 1));

      stdout.write('Prioritas (1. Tinggi, 2. Sedang, 3. Rendah) : ');
      final priority = int.tryParse(stdin.readLineSync() ?? '3') ?? 3;

      tasks.add(Task(title: title, deadline: deadline, priority: priority));
      await saveTasks(tasks);
      print('✅ Tugas berhasil disimpan!');
    } else if (choice == '2') {
      tasks.sort((a, b) {
        final priorityCompare = a.priority.compareTo(b.priority);
        if (priorityCompare != 0) return priorityCompare;
        return b.priority.compareTo(a.priority);
      });

      print('\n📋 Daftar Tugas:');
      for (var task in tasks) {
        final color = getColorForPriority(task.priority);
        print('$color- ${task.title} | Deadline: ${task.deadline} | Prioritas: ${task.priority}\x1B[0m');
      }
    } else if (choice == '3') {
      if (tasks.isEmpty) {
        print('📭 Tidak ada tugas untuk dihapus.');
      } else {
        print('\n🗑️ Daftar Tugas:');
        for (int i = 0; i < tasks.length; i++) {
          final t = tasks[i];
          final color = getColorForPriority(t.priority);
          print('$color${i + 1}. ${t.title} | Deadline: ${t.deadline} | Prioritas: ${t.priority}\x1B[0m');
        }

        stdout.write('\nMasukkan nomor tugas yang ingin dihapus: ');
        final index = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

        if (index < 1 || index > tasks.length) {
          print('❌ Nomor tidak valid.');
        } else {
          final removed = tasks.removeAt(index - 1);
          await saveTasks(tasks);
          print('🗑️ Tugas "${removed.title}" berhasil dihapus.');
        }
      }
    } else if (choice == '4') {
      print('\n👋 Terima kasih telah menggunakan aplikasi!');
      break;
    } else {
      print('❌ Pilihan tidak valid.');
    }

    // Tunggu enter sebelum kembali ke menu
    stdout.write('\nTekan ENTER untuk kembali ke menu...');
    stdin.readLineSync();
  }
}
