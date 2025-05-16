import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/theme/app_theme.dart';
import 'package:habit_tracker/screens/add_edit_habit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTheme.gradientText(
          'My Habits',
          Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditHabitScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.backgroundColor.withOpacity(0.8),
              AppTheme.surfaceColor.withOpacity(0.5),
            ],
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Habit>('habits').listenable(),
          builder: (context, Box<Habit> box, _) {
            if (box.isEmpty) {
              return Center(
                child: AppTheme.enhancedGlassContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_task_rounded,
                          size: 48,
                          color: AppTheme.primaryColor.withOpacity(0.8),
                        ),
                        const SizedBox(height: 16),
                        AppTheme.gradientText(
                          'Add your first habit',
                          Theme.of(context).textTheme.titleLarge!,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button to get started',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: box.length,
              itemBuilder: (context, index) {
                final habit = box.getAt(index)!;
                final habitColor = Color(int.parse('0xFF${habit.color.substring(1)}'));
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditHabitScreen(
                                  habit: habit,
                                ),
                              ),
                            );
                          },
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.8),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(16),
                          ),
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            habit.delete();
                          },
                          backgroundColor: Colors.red.withOpacity(0.8),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(16),
                          ),
                        ),
                      ],
                    ),
                    child: AppTheme.enhancedGlassContainer(
                      child: ListTile(
                        title: Text(
                          habit.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: habit.description.isNotEmpty
                            ? Text(
                                habit.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              )
                            : null,
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: habitColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: habitColor,
                              width: 2,
                            ),
                          ),
                        ),
                        trailing: Transform.scale(
                          scale: 0.9,
                          child: Switch.adaptive(
                            value: habit.isCompletedForDate(DateTime.now()),
                            onChanged: (value) {
                              habit.toggleCompletion(DateTime.now());
                            },
                            activeColor: habitColor,
                            activeTrackColor: habitColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
} 