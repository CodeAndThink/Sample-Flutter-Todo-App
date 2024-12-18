import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/network/api_provider.dart';

class ProfileViewModel extends ChangeNotifier {
  //MARK: Properties
  User? _user;
  User? get user => _user;

  late ApiProvider _provider;

  //MARK: Constructor

  ProfileViewModel(ApiProvider provider) {
    _provider = provider;
  }

  //MARK: Public Functions

  void fetchUserInformation() {
    _user = _provider.fetchUserInformation();
  }

  //MARK: Private Functions
}
