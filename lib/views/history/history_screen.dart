import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/common/views/custom_app_bar.dart';
import 'package:todo_app/views/history/history_view_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late HistoryViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = HistoryViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            _appBar(),
          ],
        ),
      ),
    );
  }

//MARK: App Bar

  Widget _appBar() {
    return CustomAppBar(
        title: AppLocalizations.of(context)!.history_screen_title,
        action: () {
          Navigator.pop(context);
        });
  }

//========================================================
}
