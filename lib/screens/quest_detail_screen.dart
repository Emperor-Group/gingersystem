import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:gingersystem/providers/quests_provider.dart';
import 'package:gingersystem/providers/stage.dart';
import 'package:provider/provider.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

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
  bool _isInit = false;
  bool _isLoading = false;

  final Map<Stage, Color> colorPerStage = {
    Stage.Explore: Colors.blue,
    Stage.Exploit: Colors.deepPurple,
    Stage.Closed: Colors.red,
  };

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Quest>(context, listen: false).setInitialIdea().then(
        (value) {
          setState(() {
            _isLoading = false;
          });
        },
      );
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Quest selected = Provider.of<Quest>(context);
    final Size deviceSize = MediaQuery.of(context).size;
    double ratio = DateTime.now().difference(selected.launchedDate).inHours /
        selected.deadline.difference(selected.launchedDate).inHours;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
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
                SizedBox(
                  height: deviceSize.height * 0.025,
                ),
                Container(
                  height: deviceSize.height * 0.1,
                  padding: EdgeInsets.only(
                    right: 8,
                    left: 8,
                  ),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: LiquidLinearProgressIndicator(
                              value: ratio,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  colorPerStage[selected.stage]),
                              backgroundColor: Colors.white,
                              center: selected.deadline.isBefore(DateTime.now())
                                  ? Text(
                                      'Quest Closed',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      selected.stage.toString().substring(
                                              selected.stage
                                                      .toString()
                                                      .indexOf('.') +
                                                  1) +
                                          ' Stage, ' +
                                          selected.deadline
                                              .difference(DateTime.now())
                                              .inDays
                                              .toString() +
                                          ' day' +
                                          (selected.deadline
                                                      .difference(
                                                          DateTime.now())
                                                      .inDays >
                                                  1
                                              ? 's'
                                              : '') +
                                          ' to go.',
                                      style: ratio >= 0.8
                                          ? TextStyle(color: Colors.white)
                                          : ratio >= 0.6
                                              ? TextStyle(
                                                  color: Colors.grey[100],
                                                )
                                              : ratio >= 0.4
                                                  ? TextStyle(
                                                      color: Colors.grey[200],
                                                    )
                                                  : TextStyle(
                                                      color: Colors.grey[300],
                                                    ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.025,
                ),
                Container(
                  height: deviceSize.height * 0.3,
                  width: deviceSize.width * 0.85,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Idea Pionera',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              selected.initialIdea.title,
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            'Descripción',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 15,
                              left: 15,
                              bottom: 10,
                              top: 5,
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                selected.initialIdea.content,
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          ),
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
