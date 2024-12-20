import 'package:flutter/material.dart';
import 'package:todo_app/network/api_provider.dart';

class AnalysisViewModel extends ChangeNotifier {
  //MARK: Properties
  late ApiProvider _provider;

  int _doneNote = 0;
  int get doneNote => _doneNote;

  int _todoNote = 0;
  int get todoNote => _todoNote;

  int get totalNote => _doneNote + _todoNote;

  final ValueNotifier<String> _error = ValueNotifier('');
  ValueNotifier<String> get error => _error;

  List<List<int>> _notesCountByDayInYear =
      List.generate(12, (_) => List.filled(31, 0));
  List<List<int>> get notesCountByDayInYear => _notesCountByDayInYear;

  //MARK: Initializer
  AnalysisViewModel(ApiProvider provider) {
    _provider = provider;
  }

  //MARK: Public Methods

  //Function to count the number of done notes
  void countDoneNote() async {
    final response = await _provider.doneNoteCount();
    if (response.error != null) {
      _error.value = response.error!;
    } else {
      _doneNote = response.data!;
      notifyListeners();
    }
  }

  //Function to count the number of todo notes
  void countTodoNote() async {
    final response = await _provider.todoNoteCount();
    if (response.error != null) {
      _error.value = response.error!;
    } else {
      _todoNote = response.data!;
      notifyListeners();
    }
  }

  void countNoteBasedOnDayInYear() async {
    final response = await _provider.countNoteBasedOnDayInYear();
    if (response.error != null) {
      _error.value = response.error!;
    } else {
      _notesCountByDayInYear = response.data!;
      notifyListeners();
    }
  }

  //MARK: Private Methods
}