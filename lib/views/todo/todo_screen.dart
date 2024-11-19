import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/views/add_new_task/add_new_task_screen.dart';
import 'package:todo_app/views/todo/item/note_card.dart';

import '../../configs/main_bottom_button.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final ScrollController _listViewController = ScrollController();

  @override
  void initState() {
    super.initState();

    _listViewController.addListener(() {
      if (_listViewController.position.atEdge) {
        bool isTop = _listViewController.position.pixels == 0;
        if (isTop) {
          print("Đang ở đầu danh sách");
        } else {
          print("Đang ở cuối danh sách");
        }
      }
    });
  }

  String formatDate(DateTime date) {
    final day = date.day;
    final daySuffix = getDaySuffix(day);
    final formattedDate = DateFormat('MMMM d').format(date); // October 14
    final year = date.year;

    return '$formattedDate$daySuffix $year'; // October, 14th 2002
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  void dispose() {
    _listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final currentDate = DateTime.now();
    final formattedDate = formatDate(currentDate);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight * 0.2 < 222 ? 222 : screenHeight * 0.2,
            width: screenWidth,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 36,
                ),
                Text(
                  formattedDate,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Theme.of(context).colorScheme.surface),
                ),
                const SizedBox(
                  height: 42,
                ),
                Text(
                  AppLocalizations.of(context)!.todoScreenTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                )
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: screenHeight * 0.15 < 158 ? 158 : screenHeight * 0.15,
              ),
              SizedBox(
                  height: screenHeight * 0.75 - 56,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: ListView.builder(
                      controller: _listViewController,
                      itemCount: Configs.demoNotes.length,
                      itemBuilder: (data, index) {
                        return NoteCard(
                            data: Configs.demoNotes[index],
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddNewTaskScreen()));
                            });
                      },
                    ),
                  ))
            ],
          ),
          Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              height: 56,
              child: MainBottomButton(
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddNewTaskScreen()),
                  );
                },
                buttonLabel:
                    AppLocalizations.of(context)!.addNewTaskButtonTitle,
              ))
        ],
      ),
    );
  }
}
