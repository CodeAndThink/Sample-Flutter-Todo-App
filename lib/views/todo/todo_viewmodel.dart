import 'package:flutter/material.dart';
import 'package:todo_app/manager/auth_manager.dart';
import 'package:todo_app/manager/user_manager.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/network/api_provider.dart';

class TodoViewmodel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  void updateNote(NoteModel oldNote) async {
    final newNote = oldNote;
    newNote.status = !newNote.status;

    _listUpdate(newNote);

    _silentLoading();

    final response = await _provider.updateNote(newNote);

    _setError(response.error ?? "");
    if (response.error != null) {
      _listUpdate(oldNote);
    }
  }

  void fetchNote() async {
    if (_data.isEmpty) {
      _startLoading();
    } else {
      _silentLoading();
    }

    final response = await _provider.fetchNotes();

    if (_data != response.data) {
      _data = response.data ?? [];

      _dataFilter();

      _setError(response.error ?? "");
    }
  }

  void deleteNote(NoteModel note) async {
    _dataDeleteUpdate(note);

    final response = await _provider.deleteNote(note.id!);

    _setError(response.error ?? "");

    if (response.error != null) {
      fetchNote();
    }
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

  void _dataDeleteUpdate(NoteModel deleteNote) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _todoData.removeWhere((note) => note.id == deleteNote.id);
      _doneData.removeWhere((note) => note.id == deleteNote.id);

      notifyListeners();
    });
  }
}
