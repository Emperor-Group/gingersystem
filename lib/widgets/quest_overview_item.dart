import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:gingersystem/providers/stage.dart';
import 'package:gingersystem/screens/quest_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class QuestOverviewItem extends StatelessWidget {
  final Map<Stage, Color> colorPerStage = {
    Stage.Explore: Colors.blue,
    Stage.Exploit: Colors.deepPurple,
    Stage.Closed: Colors.red,
  };

  final Map<Stage, IconData> iconPerStage = {
    Stage.Explore: Icons.search,
    Stage.Exploit: Icons.all_out,
    Stage.Closed: Icons.lock,
  };

  @override
  Widget build(BuildContext context) {
    final Quest quest = Provider.of<Quest>(context);
    return GestureDetector(
      child: Card(
        elevation: 10,
        child: ListTile(
          leading: FittedBox(
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: colorPerStage[quest.stage],
                  child: Icon(
                    iconPerStage[quest.stage],
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    quest.stage
                        .toString()
                        .substring(quest.stage.toString().indexOf('.') + 1),
                    style: TextStyle(
                      color: colorPerStage[quest.stage],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            quest.title,
            style: Theme.of(context).textTheme.headline1,
          ),
          subtitle: Text(
            'deadline: ${DateFormat('dd/MM/yyyy').format(quest.deadline)}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed(
        QuestDetailScreen.routeName,
        arguments: quest.id,
      ),
    );
  }
}
