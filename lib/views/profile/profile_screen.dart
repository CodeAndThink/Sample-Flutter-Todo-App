import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/common/views/custom_app_bar.dart';
import 'package:todo_app/common/views/custom_divider.dart';
import 'package:todo_app/common/views/custom_personal_information_field.dart';
import 'package:todo_app/common/views/custom_separated_part_title.dart';
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
                  const SizedBox(
                    height: 8,
                  ),
                  Selector<ProfileViewModel, User?>(
                      builder: (context, data, child) {
                        if (data != null) {
                          return _informationBox(data);
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
                      selector: (context, viewmodel) => viewmodel.userData)
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Image.asset(
                Assets.icons.pencil.path,
                height: 32,
                width: 32,
              )),
        );
      },
    );
  }

  Widget _informationBox(User data) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Container(
      width: screenWidth - 16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomSeparatedPartTitle(
                title: AppLocalizations.of(context)!.personalInformation),
            CustomPersonalInformationField(
                title: AppLocalizations.of(context)!.email,
                information: _vm.getEmail()),
            const CustomDivider(),
            CustomPersonalInformationField(
                title: AppLocalizations.of(context)!.phone,
                information: _vm.getPhone()),
            const CustomDivider(),
            CustomPersonalInformationField(
                title: AppLocalizations.of(context)!.createAt,
                information: _vm.getCreateAt(context)),
            const CustomDivider(),
            CustomPersonalInformationField(
                title: AppLocalizations.of(context)!.lastTimeUpdated,
                information: _vm.getUpdateAt(context)),
          ],
        ),
      ),
    );
  }
}
