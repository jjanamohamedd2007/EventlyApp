import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../models/fire_base/firebase_manager.dart';
import '../../../../../models/task_model.dart';
import '../../../../../providers/my_provider.dart';
import '../../../../create_event_screen/create_event_screen.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final TaskModel task;

   CustomPopupMenuButton({super.key, required this.task,});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (value) async {

        if (value == 1) {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateEventScreen(task: task),
            ),
          );


        }
        else if (value == 2) {
          if (task.id != null) {
            await FirebaseManager.deleteTask(task.id!);
          }
          var provider = Provider.of<MyProvider>(context, listen: false);
          provider.favoriteTasks.removeWhere((t) => t.id == task.id);
          provider.notifyListeners();
        }

      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      elevation: 8,
      itemBuilder: (_) => [
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.edit, color: Colors.blue, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                "Edit Event",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.delete, color: Colors.red, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                "Delete Event",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, color: AppColors.primary),
    );
  }
}
