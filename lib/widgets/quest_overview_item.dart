import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:provider/provider.dart';

class QuestOverviewItem extends StatelessWidget {
  const QuestOverviewItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Quest quest = Provider.of<Quest>(context);
    return Card(
      elevation: 10,
      child: ListTile(
        title: Text(quest.title),
        leading: Card(
          child: Text(quest.initialIdea.title),
        ),
      ),
    );
  }
}
