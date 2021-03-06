import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:gingersystem/providers/quests_provider.dart';
import 'package:gingersystem/providers/stage.dart';
import 'package:gingersystem/widgets/idea_overview_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

import 'idea_detail_screen.dart';

enum FilteredIdeaOptions {
  Favourites,
  Latest,
}

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

  FilteredIdeaOptions _showLatestOrFavourites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quest Control Screen'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilteredIdeaOptions opt) {
              if (opt == FilteredIdeaOptions.Latest) {
                setState(
                  () {
                    _showLatestOrFavourites = FilteredIdeaOptions.Latest;
                  },
                );
              } else if (opt == FilteredIdeaOptions.Favourites) {
                setState(
                  () {
                    _showLatestOrFavourites = FilteredIdeaOptions.Favourites;
                  },
                );
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.all_inclusive,
                        color: Colors.black,
                        size: 15,
                      ),
                    ),
                    Text(
                      'Latest',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
                value: FilteredIdeaOptions.Latest,
              ),
              PopupMenuItem(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.stars,
                        color: Colors.black54,
                        size: 15,
                      ),
                    ),
                    Text(
                      'Top 10',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ],
                ),
                value: FilteredIdeaOptions.Favourites,
              ),
            ],
          ),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: selectedQuest,
        child: QuestDetail(
          _showLatestOrFavourites,
        ),
      ),
    );
  }
}

class QuestDetail extends StatefulWidget {
  final FilteredIdeaOptions showOptions;

  QuestDetail(this.showOptions);

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
          Provider.of<Quest>(context, listen: false)
              .fetchAndSetIdeasToDisplay(option: widget.showOptions)
              .then(
            (value) {
              setState(
                () {
                  _isLoading = false;
                },
              );
            },
          );
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
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
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
                  width: deviceSize.width,
                  padding: EdgeInsets.only(
                    right: 8,
                    left: 8,
                  ),
                  child: GestureDetector(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(fontSize: 17.0),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(fontSize: 15.0),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(fontSize: 13.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        IdeaDetailScreen.routeName,
                        arguments: <String, String>{
                          'ideaId': selected.initialIdea.id,
                          'questId': selected.id,
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                    left: 12,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Center(
                    child: Text(
                      'Ideas',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 17.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                      left: 8,
                    ),
                    child: IdeaOverviewList(null, selected.id, 'todas', false),
                  ),
                ),
              ],
            ),
          );
  }
}
