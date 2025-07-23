class Task { // deklarasi kelas
  String title; 
  DateTime deadline; 
  int priority; 

  Task({required this.title, required this.deadline, required this.priority}); // objek

  Map<String, dynamic> toJson() => { // menata data untuk mengirim ke  file json
    'title': title,
    'deadline': deadline.toIso8601String(),
    'priority': priority, 
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task( //mengontorol proses pembuatan objek 
    title: json['title'],
    deadline: DateTime.parse(json['deadline']),
    priority: json['priority'],
  );
}
// kita menggunakan data enkapsulation untuk menyimpan dta tugas dlm objek task 
// paradikma pbo dan memakai konsep enkapsulation