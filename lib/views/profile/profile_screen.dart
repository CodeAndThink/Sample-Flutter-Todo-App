import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/common/views/custom_app_bar.dart';
import 'package:todo_app/gen/assets.gen.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/views/profile/profile_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileViewModel _vm;

  @override
  void initState() {
    super.initState();

    _vm = ProfileViewModel(ApiProvider.shared);

    _vm.fetchUserInformation();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _vm,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            top: false,
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppBar(
                      title: AppLocalizations.of(context)!.profile,
                      action: () {
                        Navigator.pop(context);
                      }),
                  Selector<ProfileViewModel, User?>(
                      builder: (context, data, child) {
                        if (data != null) {
                          return Column(
                            children: [
                              Text("Username: ${data.email}"),
                              Text('UUID: ${data.id}'),
                              Text('Created at: ${data.createdAt}'),
                              Text('Aud: ${data.aud}'),
                              Text('Last signin at: ${data.lastSignInAt}'),
                              Text('Phone: ${data.phone}'),
                              Text('Update at: ${data.updatedAt}'),
                              Text('Aud: ${data.userMetadata}')
                            ],
                          );
                        }
                        return Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Assets.images.logo.path,
                                  height: 100,
                                  width: 100,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.textHolder,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      selector: (context, viewmodel) => viewmodel.user)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
