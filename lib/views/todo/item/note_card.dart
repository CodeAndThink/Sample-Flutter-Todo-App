import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/models/note_model.dart';

class NoteCard extends StatefulWidget {
  const NoteCard({super.key, required this.data, required this.onTap});

  final NoteModel data;
  final VoidCallback onTap;

  @override
  NoteCardState createState() => NoteCardState();
}

class NoteCardState extends State<NoteCard> {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: 80,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Center(
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                      color: _cateIconBackgroundColor(widget.data.category),
                      width: 48,
                      height: 48,
                      child: Center(
                        child: SvgPicture.asset(
                          _cateIconSelected(widget.data.category),
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
                        Text(widget.data.taskTitle,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineSmall),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(widget.data.time ?? "")
                      ],
                    ),
                  ),
                  Checkbox(
                      value: widget.data.status, onChanged: (bool? value) {})
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
