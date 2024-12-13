import 'dart:ui';
import 'package:todo_app/gen/assets.gen.dart';

class Configs {
  //Network
  static Duration timeOut = const Duration(seconds: 5);

  //Categories's Colors
  static Color noteCategoryBackgroundColor = const Color(0xFFDBECF6);
  static Color calendarCategoryBackgroundColor = const Color(0xFFE7E2F3);
  static Color celeCategoryBackgroundColor = const Color(0xFFFEF5D3);

  static Color cateIconBackgroundColor(int cateNumber) {
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

  //Categories's Icon
  static String cateIcon(int cateNumber) {
    switch (cateNumber) {
      case 0:
        return Assets.icons.note;
      case 1:
        return Assets.icons.calendar;
      case 2:
        return Assets.icons.cele;
      default:
        return Assets.icons.note;
    }
  }

  //Animation
  static Duration animationDuration = const Duration(milliseconds: 400);

  //Date Format
  static const longEnDate = 'MMMM d';
  static const mediumEnDate = 'dd MMM yyyy';
  static const mediumVnDate = 'dd/MM/yyyy';
  static const mediumDefaltDate = 'yyyy-MM-dd';
  static const longDefaltDateTime = 'yyyy-MM-dd hh:mm:ss';
  static String formatLongVnDate(DateTime date) {
    return 'Ngày ${date.day} tháng ${date.month} năm ${date.year}';
  }
}
