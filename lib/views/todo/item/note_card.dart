import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/utilities/converse_datetime.dart';

class NoteCard extends StatefulWidget {
  final NoteModel data;
  final VoidCallback onTap;
  final Function(bool value) checkBoxAction;
  final bool isTop;
  final bool isBottom;

  const NoteCard({
    super.key,
    required this.data,
    required this.onTap,
    required this.checkBoxAction,
    required this.isTop,
    required this.isBottom,
  });

  @override
  NoteCardState createState() => NoteCardState();
}

class NoteCardState extends State<NoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Configs.animationDuration,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //Function receives type of category and return the path of icon
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

  //Function receives type of category and return color for each category
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

  //Function detects which border apply for each card
  List<double> _borderRadiusCal() {
    if (widget.isTop && widget.isBottom) {
      return [10, 10, 10, 10];
    } else if (widget.isTop) {
      return [10, 10, 0, 0];
    } else if (widget.isBottom) {
      return [0, 0, 10, 10];
    } else {
      return [0, 0, 0, 0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Opacity(
          opacity: widget.data.status ? 0.5 : 1,
          child: SizedBox(
            height: 80,
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 1),
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_borderRadiusCal()[0]),
                  topRight: Radius.circular(_borderRadiusCal()[1]),
                  bottomLeft: Radius.circular(_borderRadiusCal()[2]),
                  bottomRight: Radius.circular(_borderRadiusCal()[3]),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Center(
                  child: Row(
                    children: [
                      //MARK: Icon of category

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

                      //========================================================

                      //MARK: Title and Time

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data.taskTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      decoration: widget.data.status
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.data.time != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                ConverseDateTime.timeFormat(
                                        widget.data.time!, context)
                                    .toString(),
                                style: TextStyle(
                                    decoration: widget.data.status
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              ),
                            ],
                          ],
                        ),
                      ),

                      //========================================================

                      //MARK: Check box

                      Checkbox(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                        value: widget.data.status,
                        onChanged: (value) {
                          _controller.forward();
                          _controller.addStatusListener((status) {
                            if (status == AnimationStatus.completed) {
                              widget.checkBoxAction(value!);
                              _controller.removeStatusListener((status) {});
                            }
                          });
                        },
                      )

                      //========================================================
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
