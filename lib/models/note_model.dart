class NoteModel {
  final int? id;
  final String? deviceId;
  final String taskTitle;
  final int category;
  final String? content;
  final bool status;
  final String date;
  final String? time;

  NoteModel({this.id, this.deviceId, required this.taskTitle, required this.category, this.content, required this.status, required this.date, this.time});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as int?,
      deviceId: json['device_id'] as String?,
      taskTitle: json['task_title'] as String,
      category: json['category'] as int,
      content: json['content'] as String?,
      status: json['status'] as bool,
      date: json['date'] as String,
      time: json['time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'task_title': taskTitle,
      'category': category,
      'content': content,
      'status': status,
      'date': date,
      'time': time,
    };
  }
}