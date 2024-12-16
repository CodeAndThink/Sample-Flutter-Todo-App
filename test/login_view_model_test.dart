import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/manager/auth_manager.dart';
import 'package:todo_app/manager/user_manager.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/views/auth/login/login_view_model.dart';

// Mock ApiProvider
class MockApiProvider extends Mock implements ApiProvider {}

void main() {
  late MockApiProvider mockApiProvider;
  late UserManager userManager;
  late AuthManager authManager;
  late LoginViewModel viewModel;

  setUp(() {
    mockApiProvider = MockApiProvider();
    userManager = UserManager.shared;
    authManager = AuthManager.shared;
    viewModel = LoginViewModel(mockApiProvider, userManager, authManager);
  });

  group('LoginViewModel', () {
    test('Initial values are correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.username, "");
      expect(viewModel.password, "");
      expect(viewModel.token.value, "");
      expect(viewModel.error.value, "");
    });

    test('setUsername updates username and notifies listeners', () {
      viewModel.setUsername('hello');
      expect(viewModel.username, 'hello');
    });

    test('setPassword updates password and notifies listeners', () {
      viewModel.setPassword('hello123');
      expect(viewModel.password, 'hello123');
    });

    test('Reset password text field error', () {
      viewModel.resetErrorText();
      expect(viewModel.errorPasswordText, null);
    });

    test('Reset username text field error', () {
      viewModel.resetErrorText();
      expect(viewModel.errorUsernameText, null);
    });
  });
}
