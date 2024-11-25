import 'package:flutter/material.dart';
import 'package:todo_app/manager/auth_manager.dart';
import 'package:todo_app/manager/user_manager.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/network/api_provider.dart';

class TodoViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  String _error = "";
  String get error => _error;

  late ApiProvider _provider;
  late UserManager _userManager;
  late AuthManager _authManager;

  List<NoteModel> _data = [];

  final List<NoteModel> _todoData = [];
  List<NoteModel> get todoData => _todoData;

  final List<NoteModel> _doneData = [];
  List<NoteModel> get doneData => _doneData;

  TodoViewmodel(provider, userManager, authManager) {
    _provider = provider;
    _userManager = userManager;
    _authManager = authManager;
  }

  //MARK: Public Functions

  void signout() {
    _provider.signOut();
    _userManager.removeUserData();
    _authManager.removeUserToken();
  }

  void updateNote(NoteModel newNote) async {
    _listUpdate(newNote);

    _silentLoading();

    final response = await _provider.updateNote(newNote);

    _setError(response.error ?? "");
  }

  void fetchNote() async {
    _silentLoading();

    final response = await _provider.fetchNotes();

    if (_data != response.data) {
      _data = response.data ?? [];

      _dataFilter();

      _setError(response.error ?? "");
    }
  }

  void deleteNote(NoteModel note) async {
    final newNote = note;
    newNote.status = !newNote.status;

    final response = await _provider.deleteNote(note.id!);

    if (response.error != null) {
      _setError(response.error ?? "");
    } else {
      _isSuccess = true;
    }
  }

  void dataDeleteUpdate(NoteModel note) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var note in _data) {
        if (note.id == note.id) {
          _doneData.remove(note);
          _todoData.remove(note);
          break;
        }
      }
    });
  }

  //MARK: Private Functions

  void _silentLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = false;
      _error = "";
      notifyListeners();
    });
  }

  void _dataFilter() {
    _todoData.clear();
    _doneData.clear();

    for (var note in _data) {
      if (note.status) {
        _doneData.add(note);
      } else {
        _todoData.add(note);
      }
    }
    notifyListeners();
  }

  void _startLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = true;
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

  void _listUpdate(NoteModel newNote) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (newNote.status) {
        _todoData.removeWhere((note) => note.id == newNote.id);
        _doneData.add(newNote);
      } else {
        _doneData.removeWhere((note) => note.id == newNote.id);
        _todoData.add(newNote);
      }

      notifyListeners();
    });
  }
}
