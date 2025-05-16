import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  List<DateTime> completedDates;

  @HiveField(5)
  String color;

  Habit({
    required this.id,
    required this.title,
    this.description = '',
    required this.createdAt,
    List<DateTime>? completedDates,
    this.color = '#FF6B6B',
  }) : completedDates = completedDates ?? [];

  bool isCompletedForDate(DateTime date) {
    return completedDates.any((completedDate) =>
        completedDate.year == date.year &&
        completedDate.month == date.month &&
        completedDate.day == date.day);
  }

  void toggleCompletion(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (isCompletedForDate(date)) {
      completedDates.removeWhere((completedDate) =>
          completedDate.year == date.year &&
          completedDate.month == date.month &&
          completedDate.day == date.day);
    } else {
      completedDates.add(normalizedDate);
    }
    save();
  }

  double getCompletionRate(DateTime startDate, DateTime endDate) {
    final daysInRange = endDate.difference(startDate).inDays + 1;
    final completedInRange = completedDates.where((date) =>
        date.isAfter(startDate.subtract(const Duration(days: 1))) &&
        date.isBefore(endDate.add(const Duration(days: 1)))).length;
    
    return daysInRange > 0 ? completedInRange / daysInRange : 0;
  }
} 