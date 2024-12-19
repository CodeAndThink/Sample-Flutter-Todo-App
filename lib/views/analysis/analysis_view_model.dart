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

  //MARK: Initializer
  AnalysisViewModel(ApiProvider provider) {
    _provider = provider;
  }

  //MARK: Public Methods

  //Function to count the number of done notes
  void countDoneNote() async {
    final respose = await _provider.doneNoteCount();
    if (respose.error != null) {
      // Handle error
    } else {
      _doneNote = respose.data!;
      notifyListeners();
    }
  }

  //Function to count the number of todo notes
  void countTodoNote() async {
    final respose = await _provider.todoNoteCount();
    if (respose.error != null) {
      // Handle error
    } else {
      _todoNote = respose.data!;
      notifyListeners();
    }
  }

  //MARK: Private Methods

  
}
