import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class QuestOverviewItem extends StatelessWidget {
  const QuestOverviewItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Quest quest = Provider.of<Quest>(context);
    return GestureDetector(
      child: Card(
        elevation: 10,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.deepOrange,
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          title: Text(quest.title),
          subtitle: Text(
              'deadline: ${DateFormat('dd/MM/yyyy hh:mm').format(quest.deadline)}.'),
        ),
      ),
      onTap: () => Provider.of<Quest>(context, listen: false).setInitialIdea(),
    );
  }
}
