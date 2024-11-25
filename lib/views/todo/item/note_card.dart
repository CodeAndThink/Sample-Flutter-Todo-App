import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/utilis/converse_time.dart';

class NoteCard extends StatelessWidget {
  final NoteModel data;
  final VoidCallback onTap;
  final Function(bool value) checkBoxAction;
  final bool isTop;
  final bool isBottom;

  const NoteCard(
      {super.key,
      required this.data,
      required this.onTap,
      required this.checkBoxAction,
      required this.isTop,
      required this.isBottom});

  String _cateIconSelected(int cateNumber) {
    switch (cateNumber) {
      case 0:
        return 'assets/icons/note.svg';
      case 1:
        return 'assets/icons/calendar.svg';
      case 2:
        return 'assets/icons/cele.svg';
      default:
        return 'assets/icons/note.svg';
    }
  }

  Color _cateIconBackgroundColor(int cateNumber) {
    switch (cateNumber) {
      case 0:
        return Configs.noteCategoryBackgroundColor;
      case 1:
        return Configs.calendarCategoryBackgroundColor;
      case 2:
        return Configs.celeCategoryBackgroundColor;
      default:
        return Configs.noteCategoryBackgroundColor;
    }
  }

  List<double> borderRadiusCal() {
    if (isTop && isBottom) {
      return [10, 10, 10, 10];
    } else if (isTop) {
      return [10, 10, 0, 0];
    } else if (isBottom) {
      return [0, 0, 10, 10];
    } else {
      return [0, 0, 0, 0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: data.status ? 0.5 : 1,
        child: SizedBox(
          height: 80,
          child: Card(
            margin: const EdgeInsets.all(1),
            color: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadiusCal()[0]),
                topRight: Radius.circular(borderRadiusCal()[1]),
                bottomLeft: Radius.circular(borderRadiusCal()[2]),
                bottomRight: Radius.circular(borderRadiusCal()[3]),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Center(
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        color: _cateIconBackgroundColor(data.category),
                        width: 48,
                        height: 48,
                        child: Center(
                          child: SvgPicture.asset(
                            _cateIconSelected(data.category),
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.taskTitle,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    decoration: data.status
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                          ),
                          if (data.time != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              ConverseTime()
                                  .timeFormat(data.time!, context)
                                  .toString(),
                              style: TextStyle(
                                  decoration: data.status
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Checkbox(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      value: data.status,
                      onChanged: (value) {
                        
                        checkBoxAction(value!);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
