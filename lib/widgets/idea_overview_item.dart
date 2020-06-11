import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:gingersystem/providers/stage.dart';
import 'package:gingersystem/screens/idea_detail_screen.dart';
import 'package:gingersystem/screens/quest_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IdeaOverviewItem extends StatefulWidget {
  String idQuest;
  IdeaOverviewItem(this.idQuest);
  @override
  _IdeaOverviewItemState createState() => _IdeaOverviewItemState(idQuest);
}

class _IdeaOverviewItemState extends State<IdeaOverviewItem> {
String idQuest;
_IdeaOverviewItemState(this.idQuest);
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Idea idea = Provider.of<Idea>(context);

    final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          IdeaDetailScreen.routeName,
          arguments: <String, String>{
            'ideaId': idea.id,
            'questId': idQuest,
          },
        );
      },
      child: Card(
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
          title:  Text(
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