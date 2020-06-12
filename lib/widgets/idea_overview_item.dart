import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:gingersystem/providers/stage.dart';
import 'package:gingersystem/screens/idea_detail_screen.dart';
import 'package:gingersystem/screens/quest_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gingersystem/providers/idea_provider.dart';

class IdeaOverviewItem extends StatefulWidget {
  String idQuest;
  bool onlyShow;
  IdeaOverviewItem(this.idQuest, this.onlyShow);
  @override
  _IdeaOverviewItemState createState() =>
      _IdeaOverviewItemState(idQuest, onlyShow);
}

class _IdeaOverviewItemState extends State<IdeaOverviewItem> {
  _IdeaOverviewItemState(this.idQuest, this.onlyShow);
  String idQuest;
  bool onlyShow;
  @override
  Widget build(BuildContext context) {
    final Idea idea = Provider.of<Idea>(context);
    return GestureDetector(
      onTap: () {
        !onlyShow
            ? Navigator.of(context).pushNamed(
                IdeaDetailScreen.routeName,
                arguments: <String, String>{
                  'ideaId': idea.id,
                  'questId': idQuest,
                },
              )
            : setState(() {
                idea.isPressedIdea();
                Provider.of<IdeasProvider>(context, listen: false)
                    .addParent(idea.id);
              });
      },
      child: Card(
        color: idea.isPressed ? Colors.grey[300] : null,
        elevation: 10,
        child: ListTile(
          leading: FittedBox(
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(
                    Icons.all_out,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            idea.title,
            style: Theme.of(context).textTheme.headline1,
          ),
          subtitle: Text(
            idea.content,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}
