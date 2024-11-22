import 'package:flutter/material.dart';
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

  List<NoteModel> _data = [];

  final List<NoteModel> _todoData = [];
  List<NoteModel> get todoData => _todoData;

  final List<NoteModel> _doneData = [];
  List<NoteModel> get doneData => _doneData;

  TodoViewmodel(provider) {
    _provider = provider;
  }

  //MARK: Public Functions

  void signout() {
    _provider.signOut();
  }

  void updateNote(NoteModel oldNote) async {
    final newNote = oldNote;
    newNote.status = !newNote.status;

    _dataUpdate(newNote);

    _silentLoading();

    final response = await _provider.updateNote(newNote);

    _silentStopLoading();

    _setError(response.error ?? "");
  }

  void fetchNote() async {
    _startLoading();

    final response = await _provider.fetchNotes();

    _stopLoading();

    _data = response.data ?? [];

    _dataFilter();

    _setError(response.error ?? "");
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
    _isLoading = false;
    _error = "";
    notifyListeners();
  }

  void _silentStopLoading() {
    _isLoading = false;
    notifyListeners();
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

  void _dataUpdate(NoteModel newNote) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var note in _data) {
        if (newNote.id == note.id && newNote.status) {
          _doneData.add(newNote);
          _todoData.remove(newNote);
          break;
        }
        if (newNote.id == note.id && !newNote.status) {
          _doneData.remove(newNote);
          _todoData.add(newNote);
          break;
        }
      }
    });
  }

  void _setError(String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _error = errorMessage;
      _isLoading = false;
      notifyListeners();
    });
  }
}
