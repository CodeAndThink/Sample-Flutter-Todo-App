import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/custom_app_bar.dart';
import 'package:todo_app/common/views/loading.dart';
import 'package:todo_app/gen/assets.gen.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/views/history/history_view_model.dart';
import 'package:todo_app/views/history/item/history_section.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HistoryViewModel(ApiProvider.shared),
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              _consumerMainList(context),
              _appBar(context),
            ],
          ),
        );
      },
    );
  }

//MARK: App Bar

  Widget _appBar(BuildContext context) {
    return CustomAppBar(
        title: AppLocalizations.of(context)!.historyScreenTitle,
        action: () {
          Navigator.pop(context);
        });
  }

//========================================================

//MARK: Consumer - Main List

  Widget _consumerMainList(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.15 > 96 ? screenHeight * 0.15 : 96,
        ),
        Expanded(
          child: Consumer<HistoryViewModel>(builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Loading();
            } else if (vm.error.isEmpty) {
              if (vm.filteredData.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: vm.filteredData.length,
                      itemBuilder: (context, index) {
                        return HistorySection(data: vm.filteredData[index]);
                      }),
                );
              } else {
                return Align(
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
                        style: Theme.of(context).textTheme.headlineSmall,
                      )
                    ],
                  ),
                );
              }
            } else if (vm.error.isNotEmpty) {
              return Center(
                child: SizedBox(
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.8,
                  child: Column(
                    children: [
                      Text(
                        vm.error,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Provider.of<HistoryViewModel>(context,
                                    listen: false)
                                .fetchNote();
                          },
                          child: Text(AppLocalizations.of(context)!.reload))
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Column(
                  children: [
                    Image.asset(
                      Assets.images.logo.path,
                      height: 48,
                      width: 48,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      AppLocalizations.of(context)!.textHolder,
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  ],
                ),
              );
            }
          }),
        ),
      ],
    );
  }

//========================================================
}
