import 'package:flutter/material.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/utilis/converse_time.dart';

class AddNewTaskViewModel extends ChangeNotifier {

  //MARK: Properties

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = "";
  String get error => _error;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  NoteModel? _data;
  NoteModel? get data => _data;

  String _taskTitle = "";
  String get taskTitle => _taskTitle;

  int _category = 0;
  int get category => _category;

  String _date = "";
  String get date => _date;

  String _time = "";
  String get time => _time;

  String _content = "";
  String get content => _content;

  String? _errorTaskTitleText;
  String? get errorTaskTitleText => _errorTaskTitleText;

  String? _errorDateText;
  String? get errorDateText => _errorDateText;

  late ApiProvider _provider;

  //MARK: Contruction

  AddNewTaskViewModel(ApiProvider provider, NoteModel? noteData) {
    _data = noteData;
    _provider = provider;
  }

  //MARK: Public Function

  //Function prepares new note's data for create note or update note
  void prepareNewNote(BuildContext context) {
    if (_taskTitle.isNotEmpty && _date.isNotEmpty) {
      final status = _data != null ? _data!.status : false;
      final time = _time.isNotEmpty ? _time : null;
      final content = _content.isNotEmpty ? _content : null;
      final deviceId = _data?.deviceId;
      final id = _data?.id;

      final newNote = NoteModel(
          id: id,
          deviceId: deviceId,
          taskTitle: _taskTitle,
          category: _category,
          status: status,
          content: content,
          date: _date,
          time: time);

      _data == null ? _createNote(newNote) : _updateData(newNote);
    } else {
      _validateInput(context);
    }
  }

  //Function set the category value
  void setCategory(int newCategory) {
    _category = newCategory;
    notifyListeners();
  }

  //Function set the task title value
  void setTaskTitle(String newTaskTitle) {
    _taskTitle = newTaskTitle;
    notifyListeners();
  }

  //Function set the content value
  void setContent(String newContent) {
    _content = newContent;
    notifyListeners();
  }

  //Function set the date value
  void setDate(String newDate) {
    _date = newDate;
    notifyListeners();
  }

  //Function set the time value
  void setTime(String newTime) {
    _time = newTime;
    notifyListeners();
  }

  //Function reset error text of input text box
  void resetErrorText() {
    _errorDateText = null;
    _errorTaskTitleText = null;
  }

  //Function set initial data if available
  void setInitialData(BuildContext context) {
    if (_data != null) {
      _taskTitle = _data!.taskTitle;
      _category = _data!.category;
      _date = _data!.date;
      if (_data!.time != null) {
        _time = ConverseTime.timeFormat(_data!.time, context);
      }
      _content = _data!.content ?? "";
    }
  }

  //MARK: Private Functions

  //Function validate the input text box
  void _validateInput(BuildContext context) {
    if (_taskTitle.isEmpty) {
      _errorTaskTitleText = AppLocalizations.of(context)!.taskTitleEmptyWarning;
    } else {
      _errorTaskTitleText = null;
    }

    if (_date.isEmpty) {
      _errorDateText = AppLocalizations.of(context)!.dateEmptyWarning;
    } else {
      _errorDateText = null;
    }
    notifyListeners();
  }

  //Function of updating feature
  void _updateData(NoteModel oldNote) async {
    _startLoading();

    final response = await _provider.updateNote(oldNote);

    _stopLoading();

    _isSuccess = response.data != null ? true : false;

    _setError(response.error ?? "");
  }

  //Function of loading animation
  void _startLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = true;
      _isSuccess = false;
      _error = "";
      notifyListeners();
    });
  }

  //Function for stopping loading animation
  void _stopLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = false;
      notifyListeners();
    });
  }

  //Function set the error value if available 
  void _setError(String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _error = errorMessage;
      _isLoading = false;
      notifyListeners();
    });
  }

  //Function of creating new note feature
  void _createNote(NoteModel newNote) async {
    _startLoading();
    final response = await _provider.createNewNote(newNote);
    _stopLoading();
    _isSuccess = response.data != null ? true : false;
    _setError(response.error ?? "");
  }
}
