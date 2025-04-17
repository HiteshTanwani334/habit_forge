import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  final String category;
  final int tasksLeft;
  final int tasksDone;
  final IconData icon; // Added icon parameter
  final Color color; // Added color parameter
  final VoidCallback? onTap;

  const HabitCard({
    Key? key,
    required this.category,
    required this.tasksLeft,
    required this.tasksDone,
    required this.icon, // Ensure it's required
    required this.color, // Ensure it's required
    this.onTap,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$tasksDone/$tasksLeft tasks',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

