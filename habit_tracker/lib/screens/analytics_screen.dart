import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/theme/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Habit>('habits').listenable(),
        builder: (context, Box<Habit> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Add habits to see analytics'),
            );
          }

          final weeklyData = _getWeeklyData(box);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTheme.glassContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Progress',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: (weeklyData.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.2)
                                  .ceilToDouble(),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          weeklyData[value.toInt()].x,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: false),
                              barGroups: weeklyData.asMap().entries.map((entry) {
                                return BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.y,
                                      color: AppTheme.primaryColor,
                                      width: 16,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Individual Habit Progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...box.values.map((habit) => _buildHabitHeatmap(context, habit)).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHabitHeatmap(BuildContext context, Habit habit) {
    final heatmapData = _getHabitHeatmapData(habit);
    final habitColor = Color(int.parse('0xFF${habit.color.substring(1)}'));

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppTheme.glassContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: habitColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      habit.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              if (habit.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  habit.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              HeatMap(
                datasets: heatmapData,
                colorMode: ColorMode.opacity,
                defaultColor: Colors.grey[900]!,
                textColor: Colors.white,
                showColorTip: false,
                showText: false,
                scrollable: true,
                colorsets: {
                  1: habitColor.withOpacity(0.3),
                  2: habitColor.withOpacity(0.5),
                  3: habitColor.withOpacity(0.7),
                  4: habitColor.withOpacity(0.8),
                  5: habitColor,
                },
                onClick: (value) {
                  final isCompleted = habit.isCompletedForDate(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isCompleted ? 'Completed on this day' : 'Not completed on this day',
                      ),
                      backgroundColor: isCompleted ? habitColor : Colors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<DateTime, int> _getHabitHeatmapData(Habit habit) {
    final Map<DateTime, int> heatmapData = {};
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 180));

    for (var date = startDate;
        date.isBefore(now.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      if (habit.isCompletedForDate(date)) {
        heatmapData[DateTime(date.year, date.month, date.day)] = 5;
      }
    }

    return heatmapData;
  }

  List<_ChartData> _getWeeklyData(Box<Habit> box) {
    final now = DateTime.now();
    final weekDays = List.generate(7, (index) {
      return now.subtract(Duration(days: 6 - index));
    });

    return weekDays.map((date) {
      final completedHabits = box.values.where((habit) {
        return habit.isCompletedForDate(date);
      }).length;

      return _ChartData(
        '${date.day}/${date.month}',
        completedHabits.toDouble(),
      );
    }).toList();
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
} 