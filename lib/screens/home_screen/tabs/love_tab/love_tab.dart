import 'package:flutter/cupertino.dart' show StatelessWidget, Text, BuildContext;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

import '../../../../providers/my_provider.dart' show MyProvider;
import '../home_tab/widgets/event_item_widget.dart';

class LoveTab extends StatefulWidget {
  const LoveTab({super.key});

  @override
  State<LoveTab> createState() => _LoveTabState();
}

class _LoveTabState extends State<LoveTab> {
  @override
  Widget build(BuildContext context) {
    var favoriteTasks = Provider.of<MyProvider>(context).favoriteTasks;

    if (favoriteTasks.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 60),

      itemCount: favoriteTasks.length,
      separatorBuilder: (_, __) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        return EventItemWidget(model: favoriteTasks[index]);
      },
    );




  }
}
