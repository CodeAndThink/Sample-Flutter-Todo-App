import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
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

  group('AddNewTaskViewModel', () {
    test('Initial values are correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.taskTitle, "");
      expect(viewModel.category, 0);
      expect(viewModel.date, "");
      expect(viewModel.time, "");
      expect(viewModel.content, "");
    });

    test('setTaskTitle updates task title and notifies listeners', () {
      viewModel.setTaskTitle('New Task');
      expect(viewModel.taskTitle, 'New Task');
    });

    test('setCategory updates category and notifies listeners', () {
      viewModel.setCategory(1);
      expect(viewModel.category, 1);
    });

    test('setContent updates content and notifies listeners', () {
      viewModel.setContent('New content');
      expect(viewModel.content, 'New content');
    });

    testWidgets('Simulate setDate with Locale en_US',
        (WidgetTester tester) async {
      final viewModel = AddNewTaskViewModel(MockApiProvider(), null);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en', 'US'),
          supportedLocales: const [
            Locale('en', 'US'),
          ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (BuildContext context) {
              viewModel.setDate(context, DateTime(2024, 12, 25));
              return const Placeholder();
            },
          ),
        ),
      );

      expect(viewModel.date, '25 Dec 2024');
    });

    testWidgets('Simulate setDate with Locale vi_VN',
        (WidgetTester tester) async {
      final viewModel = AddNewTaskViewModel(MockApiProvider(), null);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('vi', 'VN'),
          supportedLocales: const [
            Locale('vi', 'VN'),
          ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (BuildContext context) {
              viewModel.setDate(context, DateTime(2024, 12, 25));
              return const Placeholder();
            },
          ),
        ),
      );

      expect(viewModel.date, '25/12/2024');
    });

    testWidgets('Simulate setTime with Locale en_US',
        (WidgetTester tester) async {
      final viewModel = AddNewTaskViewModel(MockApiProvider(), null);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en', 'US'),
          supportedLocales: const [
            Locale('en', 'US'),
          ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Builder(
            builder: (BuildContext context) {
              viewModel.setTime(context, const TimeOfDay(hour: 1, minute: 1));
              return const Placeholder();
            },
          ),
        ),
      );

      expect(viewModel.time, '1:01 AM');
    });

    testWidgets('Simulate setTime with Locale vi_VN',
        (WidgetTester tester) async {
      final viewModel = AddNewTaskViewModel(MockApiProvider(), null);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('vi', 'VN'),
          home: MediaQuery(
            data: const MediaQueryData(alwaysUse24HourFormat: true),
            child: Builder(
              builder: (BuildContext context) {
                viewModel.setTime(
                    context, const TimeOfDay(hour: 13, minute: 13));
                return const Placeholder();
              },
            ),
          ),
        ),
      );
      expect(viewModel.time, '13:13');
    });

    testWidgets('Simulate set initial data with Locale vi_VN',
        (WidgetTester tester) async {
      final testInitialData = NoteModel(
          taskTitle: 'test', category: 0, status: false, date: '2001-01-01');
      final viewModel = AddNewTaskViewModel(MockApiProvider(), testInitialData);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('vi', 'VN'),
          home: MediaQuery(
            data: const MediaQueryData(alwaysUse24HourFormat: true),
            child: Builder(
              builder: (BuildContext context) {
                viewModel.setInitialData(context);
                return const Placeholder();
              },
            ),
          ),
        ),
      );
      expect(viewModel.data?.taskTitle, 'test');
      expect(viewModel.data?.category, 0);
      expect(viewModel.data?.date, '2001-01-01');
    });
  });
}
