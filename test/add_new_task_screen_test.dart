import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/views/add_new_task/add_new_task_view_model.dart';

// Mock ApiProvider
class MockApiProvider extends Mock implements ApiProvider {}

void main() {
  late MockApiProvider mockApiProvider;
  late AddNewTaskViewModel viewModel;

  setUp(() {
    mockApiProvider = MockApiProvider();
    viewModel = AddNewTaskViewModel(mockApiProvider, null);
  });

  group('AddNewTaskScreen', () {});
}
