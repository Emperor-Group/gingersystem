import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:gingersystem/providers/quests_provider.dart';
import 'package:provider/provider.dart';

class QuestDetailScreen extends StatefulWidget {
  static const routeName = '/quest-detail';

  QuestDetailScreen({Key key}) : super(key: key);

  @override
  _QuestDetailScreenState createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  bool _isInit = false;
  Quest selectedQuest;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      String questID = ModalRoute.of(context).settings.arguments;
      selectedQuest = Provider.of<QuestsProvider>(context).getByID(questID);
      selectedQuest.setInitialIdea();
    }
    _isInit = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quest Control Screen'),
      ),
      body: ChangeNotifierProvider.value(
        value: selectedQuest,
        child: QuestDetail(),
      ),
    );
  }
}

class QuestDetail extends StatefulWidget {
  QuestDetail({Key key}) : super(key: key);

  @override
  _QuestDetailState createState() => _QuestDetailState();
}

class _QuestDetailState extends State<QuestDetail> {
  @override
  Widget build(BuildContext context) {
    Quest selected = Provider.of<Quest>(context);
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              selected.title.toUpperCase(),
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
