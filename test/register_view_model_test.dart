import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/views/auth/register/register_view_model.dart';

// Mock ApiProvider
class MockApiProvider extends Mock implements ApiProvider {}

void main() {
  late MockApiProvider mockApiProvider;
  late RegisterViewModel viewModel;

//MARK: Setup Environment

  setUp(() {
    mockApiProvider = MockApiProvider();
    viewModel = RegisterViewModel(mockApiProvider);
  });

//========================================================

  group('RegisterViewModel', () {

//MARK: Test ViewModel Initialize Variables

    test('Initial values are correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.username, "");
      expect(viewModel.password, "");
      expect(viewModel.repassword, "");
      expect(viewModel.token.value, "");
      expect(viewModel.error.value, "");
    });

//========================================================

//MARK: Test setUsername Function

    test('setUsername updates username and notifies listeners', () {
      viewModel.setUsername('hello');
      expect(viewModel.username, 'hello');
    });

//========================================================

//MARK: Test setPassword Function

    test('setPassword updates password and notifies listeners', () {
      viewModel.setPassword('hello123');
      expect(viewModel.password, 'hello123');
    });

//========================================================

//MARK: Test setRePassword Function

    test('setRePassword updates repassword and notifies listeners', () {
      viewModel.setRePassword('hello123');
      expect(viewModel.repassword, 'hello123');
    });

//========================================================

//MARK: Test resetErrorText Function For Password Text Field

    test('Reset password text field error', () {
      viewModel.resetErrorText();
      expect(viewModel.errorPasswordText, null);
    });

//========================================================

//MARK: Test resetErrorText Funtion For Confirm Password Text Field

    test('Reset repassword text field error', () {
      viewModel.resetErrorText();
      expect(viewModel.errorRepasswordText, null);
    });

//========================================================

//MARK: Test resetErrorText Funtion For Username Text Field

    test('Reset username text field error', () {
      viewModel.resetErrorText();
      expect(viewModel.errorUsernameText, null);
    });

//========================================================
  });
}
