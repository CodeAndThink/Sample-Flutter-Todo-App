import 'package:flutter/material.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/network/api_provider.dart';

class AddNewTaskViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = "";
  String get error => _error;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  NoteModel? _data;
  NoteModel? get data => _data;

  late ApiProvider _provider;

  AddNewTaskViewModel(ApiProvider provider, NoteModel? data) {
    _provider = provider;
    data = data;
  }

  //MARK: Public Function

  void prepareNewNote(String newTitle, int newCategory, String newContent,
      String newDate, String newTime, bool isCreate) {
    final status = data != null ? data!.status : false;
    final time = newTime.isNotEmpty ? newTime : null;
    final content = newContent.isNotEmpty ? newContent : null;
    final deviceId = data?.deviceId;
    final id = data?.id;

    final newNote = NoteModel(
        id: id,
        deviceId: deviceId,
        taskTitle: newTitle,
        category: newCategory,
        status: status,
        content: content,
        date: newDate,
        time: time);

    isCreate ? _createNote(newNote) : _updateData(newNote);
  }

  void setData(NoteModel? inputData) {
    _data = inputData;
  }

  void resetAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _error = "";
      _isSuccess = false;
      notifyListeners();
    });
  }

  //MARK: Private Functions

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
