import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/utils/converse_datetime.dart';

class ProfileViewModel extends ChangeNotifier {
  //MARK: Properties
  late User _userData;
  User get userData => _userData;

  late ApiProvider _provider;

  //MARK: Constructor

  ProfileViewModel(ApiProvider provider) {
    _provider = provider;
    _userData = _provider.fetchUserInformation();
  }

  //MARK: Public Functions

  String getEmail() {
    return userData.email ?? "";
  }

  String getPhone() {
    return userData.phone ?? "";
  }

  String getCreateAt(BuildContext context) {
    return ConverseDateTime.convertDateTimeToStringFormattedByLocale(
        context, DateTime.parse(userData.createdAt));
  }

  String getUpdateAt(BuildContext context) {
    return ConverseDateTime.convertDateTimeToStringFormattedByLocale(
        context, DateTime.parse(userData.updatedAt ?? ""));
  }

  //MARK: Private Functions
}
