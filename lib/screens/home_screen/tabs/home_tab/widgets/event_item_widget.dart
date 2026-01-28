import 'package:evently_app/core/theme/app_colors.dart';
import 'package:evently_app/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/my_provider.dart';
import 'image_card.dart';

class EventItemWidget extends StatefulWidget {
  final TaskModel model;

  const EventItemWidget({super.key, required this.model});

  @override
  State<EventItemWidget> createState() => _EventItemWidgetState();
}

class _EventItemWidgetState extends State<EventItemWidget> {
  bool isFavorite = false;


  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    final bool isDark = provider.themeMode == ThemeMode.dark;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isDark
                ? Border.all(
              color: AppColors.primary,
              width: 2,
            )
                : null,
          ),
          child: ImageCard(model:widget.model,initialFavorite:  widget.model.isFavorite,),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 43,
            height: 49,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isDark ? Colors.transparent : const Color(0XFFF2FEFF),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.model.date.day.toString(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _getMonthName(widget.model.date.month),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getMonthName(int monthNumber) {
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[monthNumber - 1];
  }
}
