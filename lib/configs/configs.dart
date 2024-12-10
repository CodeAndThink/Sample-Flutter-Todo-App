import 'dart:ui';

class Configs {
  //Network
  static Duration timeOut = const Duration(seconds: 5);
  static const apiSupabaseBaseUrl = "https://jwtukvndlexkwbqasypb.supabase.co";
  static const apiSubabaseKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp3dHVrdm5kbGV4a3dicWFzeXBiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjkxNTY0NjMsImV4cCI6MjA0NDczMjQ2M30.QYFrsRJGoAg1SjKGUImEGg3YAxlIp5IdOvAzK6YABBY";

  //Categories's Colors
  static Color noteCategoryBackgroundColor = const Color(0xFFDBECF6);
  static Color calendarCategoryBackgroundColor = const Color(0xFFE7E2F3);
  static Color celeCategoryBackgroundColor = const Color(0xFFFEF5D3);

  //Animation
  static Duration animationDuration = const Duration(milliseconds: 400);

  //Date Format
  static const longEnDate = 'MMMM d';
  static const mediumEnDate = 'dd MMM yyyy';
  static const mediumVnDate = 'dd/MM/yyyy';
  static const mediumDefaltDate = 'yyyy-MM-dd';
  static String formatLongVnDate(DateTime date) {
    return 'Ngày ${date.day} tháng ${date.month} năm ${date.year}';
  }
}
