import 'package:flutter/material.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:collection/collection.dart';

class HistoryViewModel extends ChangeNotifier {
  //MARK: Properties

  late ApiProvider _provider;

  List<NoteModel> _data = [];

  List<List<NoteModel>> _filteredData = [];
  List<List<NoteModel>> get filteredData => _filteredData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = "";
  String get error => _error;

  //MARK: Constructor

  HistoryViewModel(ApiProvider provider) {
    _provider = provider;
  }

  //MARK: Public Methods

  //Function for fetching notes from database
  Future<void> fetchNote() async {
    _startLoading();
    final response = await _provider.fetchAllNotes();
    if (_data != response.data) {
      _data = response.data ?? [];
      _filterData(_data);
    }
    _setError(response.error ?? "");
  }

  //MARK: Private Methods

  //Function of filtering data
  void _filterData(List<NoteModel> inputData) {
    var grouped = groupBy(inputData, (NoteModel note) => note.date);
    _filteredData = grouped.values.toList();
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
}
