import 'package:dartz/dartz.dart' as dartz;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/views/custom_app_bar.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/network/api_provider.dart';
import 'package:todo_app/utils/show_alert_dialog.dart';
import 'package:todo_app/views/analysis/analysis_view_model.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  late AnalysisViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = AnalysisViewModel(ApiProvider.shared);

    _vm.error.addListener(() {
      if (_vm.error.value.isNotEmpty) {
        showAlert(context, AppLocalizations.of(context)!.error,
            AppLocalizations.of(context)!.fetchDataError, () {
          Navigator.pop(context);
        }, AppLocalizations.of(context)!.ok, null, null);
      }
    });

    _vm.countDoneNote();
    _vm.countTodoNote();
    _vm.countNoteBasedOnDayInYear();
  }

  @override
  void dispose() {
    _vm.error.dispose();
    super.dispose();
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
              child: Column(
                children: [
                  //MARK: App Bar
                  _appBar(context),

                  Container(
                    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //MARK: Analized Details
                        _analizedDetails(context),

                        //MARK: Pie Chart
                        _pieChart(context),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "${AppLocalizations.of(context)!.dataOf} ${DateTime.now().month} - ${DateTime.now().year}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        //MARK: Bar Chart
                        _barChart(context),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

//MARK: App Bar

  Widget _appBar(BuildContext context) {
    return CustomAppBar(
        title: AppLocalizations.of(context)!.statsScreenTitle,
        action: () {
          Navigator.pop(context);
        });
  }

//========================================================

//MARK: Pie Chart

  Widget _pieChart(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Selector<AnalysisViewModel, dartz.Tuple2<int, int>>(
        builder: (context, data, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight > screenWidth
                    ? screenWidth * 0.4
                    : screenHeight * 0.4,
                width: screenHeight > screenWidth
                    ? screenWidth * 0.4
                    : screenHeight * 0.4,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: data.value1.toDouble(),
                        color: Configs.todoPartPieChartColor,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: data.value2.toDouble(),
                        color: Theme.of(context).colorScheme.primary,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: Configs.todoPartPieChartColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.pieChartDoneLabel,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.pieChartTodoLabel,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
        selector: (context, viewmodel) =>
            dartz.Tuple2(viewmodel.doneNote, viewmodel.todoNote));
  }

//========================================================

//MARK: Analized Details

  Widget _analizedDetails(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<AnalysisViewModel, int>(
            builder: (context, numDone, child) {
              return Text(
                "$numDone",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 35, color: Configs.todoPartPieChartColor),
              );
            },
            selector: (context, viewmodel) => viewmodel.doneNote),
        SizedBox(
          width: screenWidth * 0.4,
          child: Container(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              AppLocalizations.of(context)!.notesDoneLabel,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Configs.todoPartPieChartColor),
              overflow: TextOverflow.clip,
            ),
          ),
        ),
        Selector<AnalysisViewModel, int>(
            builder: (context, numTodo, child) {
              return Text(
                "$numTodo",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 35, color: Theme.of(context).colorScheme.primary),
              );
            },
            selector: (context, viewmodel) => viewmodel.todoNote),
        Container(
          padding: const EdgeInsets.only(left: 16),
          width: screenWidth * 0.4,
          child: Text(AppLocalizations.of(context)!.notesTodoLabel,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
              overflow: TextOverflow.clip),
        ),
        Selector<AnalysisViewModel, int>(
            builder: (context, total, child) {
              return Text(
                "$total",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontSize: 35),
              );
            },
            selector: (context, viewmodel) => viewmodel.totalNote),
        SizedBox(
          width: screenWidth * 0.4,
          child: Container(
            padding: const EdgeInsets.only(left: 16),
            child: Text(AppLocalizations.of(context)!.notesTotalLabel,
                style: Theme.of(context).textTheme.headlineSmall,
                overflow: TextOverflow.clip),
          ),
        ),
      ],
    );
  }

//========================================================

//MARK: Bar Chart

  Widget _barChart(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Selector<AnalysisViewModel, List<List<int>>>(
          builder: (context, data, child) {
            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: [
                  for (int i = 0; i < 31; i++) ...{
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: data[DateTime.now().month - 1][i].toDouble(),
                          color: DateTime.now().day - 1 != i
                              ? Configs.otherDayBarChartColor
                              : Configs.todayBarChartColor,
                          width: 3,
                        ),
                      ],
                    ),
                  }
                ],
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        if (value % 5 == 0) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
          selector: (context, viewmodel) => viewmodel.notesCountByDayInYear),
    );
  }

//========================================================
}
