import 'package:flutter/material.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/network/api_provider.dart';

class TodoViewModel extends ChangeNotifier {
  //MARK: Properties

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = "";
  String get error => _error;

  List<NoteModel> _data = [];

  final List<NoteModel> _todoData = [];
  List<NoteModel> get todoData => _todoData;

  final List<NoteModel> _doneData = [];
  List<NoteModel> get doneData => _doneData;

  late ApiProvider _provider;

  //MARK: Construction

  TodoViewModel(provider) {
    _provider = provider;
  }

  //MARK: Public Functions

  //Function for updating feature
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

  //Function for fetching note from database
  Future<void> fetchNote() async {
    if (_data.isEmpty) {
      _startLoading();
      // _data = await DatabaseHelper().getAllNotes();
    } else {
      _silentLoading();
    }

    final response = await _provider.fetchNotes();

    if (_data != response.data) {
      _data = response.data ?? [];

      _dataFilter();

      // await DatabaseHelper().saveListNote(_data);
    }
    _setError(response.error ?? "");
  }

  //Funtion for delete current note
  void deleteNote(NoteModel note) async {
    _dataDeleteUpdate(note);

    final response = await _provider.deleteNote(note.id!);

    _setError(response.error ?? "");

    if (response.error != null) {
      fetchNote();
    }
  }

  //MARK: Private Functions

  //Function disable loading animation
  void _silentLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = false;
      _error = "";
      notifyListeners();
    });
  }

  //Function reset and add new data
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

  //Function of loading animation
  void _startLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = true;
      _error = "";
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

  //Function replace data between 2 data source
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

  //Function removes data in local
  void _dataDeleteUpdate(NoteModel deleteNote) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _todoData.removeWhere((note) => note.id == deleteNote.id);
      _doneData.removeWhere((note) => note.id == deleteNote.id);

      notifyListeners();
    });
  }
}
