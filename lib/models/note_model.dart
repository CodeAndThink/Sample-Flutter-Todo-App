class NoteModel {
  int? id;
  String? userId;
  final String taskTitle;
  final int category;
  final String? content;
  bool status;
  final String date;
  final String? time;

  NoteModel(
      {this.id,
      this.userId,
      required this.taskTitle,
      required this.category,
      this.content,
      required this.status,
      required this.date,
      this.time});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as int?,
      userId: json['user_id'] as String?,
      taskTitle: json['task_title'] as String,
      category: json['category'] as int,
      content: json['content'] as String?,
      status: json['status'] as bool,
      date: json['date'] as String,
      time: json['time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'user_id': userId,
      'task_title': taskTitle,
      'category': category,
      'status': status,
      'date': date
    };

    if (id != null) {
      map['id'] = id;
    }

    if (time != null) {
      map['time'] = time;
    }

    if (content != null) {
      map['content'] = content;
    }

    return map;
  }
}
