import 'package:evently_app/screens/home_screen/tabs/home_tab/widgets/popup_menuItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/base_theme.dart';
import '../../../../../models/task_model.dart';
import '../../../../../providers/my_provider.dart';

class ImageCard extends StatefulWidget {
  final TaskModel model;
  final bool initialFavorite;

  const ImageCard({
    super.key,
    required this.model,
    this.initialFavorite = false,
  });

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initialFavorite;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    bool isDark = provider.themeMode == ThemeMode.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            "assets/images/${widget.model.category.toLowerCase().replaceAll(' ', '')}.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),

          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? BaseTheme.dark.scaffoldBackgroundColor
                  : AppColors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.model.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Row(
                    children: [
                      IconButton(
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        icon: Icon(
                          provider.favoriteTasks.any(
                                (t) => t.id == widget.model.id,
                              )
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 26,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          var provider = Provider.of<MyProvider>(
                            context,
                            listen: false,
                          );

                          if (provider.favoriteTasks.any(
                            (t) => t.id == widget.model.id,
                          )) {
                            provider.favoriteTasks.removeWhere(
                              (t) => t.id == widget.model.id,
                            );
                          } else {
                            provider.favoriteTasks.add(widget.model);
                          }

                          provider.notifyListeners();
                        },
                      ),

                      CustomPopupMenuButton(task: widget.model),


                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
