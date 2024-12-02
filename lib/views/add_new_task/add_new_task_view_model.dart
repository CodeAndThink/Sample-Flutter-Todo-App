import 'package:flutter/material.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewTaskViewModel extends ChangeNotifier {
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

  AddNewTaskViewModel(ApiProvider provider, NoteModel? noteData) {
    _data = noteData;
    _provider = provider;

    _setInitialData();
  }

  //MARK: Public Function

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

  void setCategory(int newCategory) {
    _category = newCategory;
    notifyListeners();
  }

  void setTaskTitle(String newTaskTitle) {
    _taskTitle = newTaskTitle;
    notifyListeners();
  }

  void setContent(String newContent) {
    _content = newContent;
    notifyListeners();
  }

  void setDate(String newDate) {
    _date = newDate;
    notifyListeners();
  }

  void setTime(String newTime) {
    _time = newTime;
    notifyListeners();
  }

  void resetAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _error = "";
      _isSuccess = false;
      notifyListeners();
    });
  }

  void resetErrorText() {
    _errorDateText = null;
    _errorTaskTitleText = null;
  }

  //MARK: Private Functions

  void _setInitialData() {
    if (_data != null) {

      _taskTitle = _data!.taskTitle;
      _category = _data!.category;
      _date = _data!.date;
      _time = _data!.time ?? "";
      _content = _data!.content ?? "";
    }
  }

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

  void _updateData(NoteModel oldNote) async {
    _startLoading();

    final response = await _provider.updateNote(oldNote);

    _stopLoading();

    _isSuccess = response.data != null ? true : false;

    _setError(response.error ?? "");
  }

  void _startLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = true;
      _isSuccess = false;
      _error = "";
      notifyListeners();
    });
  }

  void _stopLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void _setError(String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _error = errorMessage;
      _isLoading = false;
      notifyListeners();
    });
  }

  void _createNote(NoteModel newNote) async {
    _startLoading();
    final response = await _provider.createNewNote(newNote);
    _stopLoading();
    _isSuccess = response.data != null ? true : false;
    _setError(response.error ?? "");
  }
}
