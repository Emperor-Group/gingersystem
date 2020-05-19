import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:gingersystem/providers/quests_provider.dart';
import 'package:gingersystem/providers/stage.dart';
import 'package:gingersystem/screens/add_quest.dart';
import 'package:gingersystem/screens/quest_detail_screen.dart';
import 'package:gingersystem/widgets/main_drawer.dart';
import 'package:gingersystem/widgets/quest_overview_list.dart';
import 'package:provider/provider.dart';

enum FilteredOptions {
  UPCOMING,
  ALL,
}

class QuestOverviewScreen extends StatefulWidget {
  @override
  _QuestOverviewScreenState createState() => _QuestOverviewScreenState();
}

class _QuestOverviewScreenState extends State<QuestOverviewScreen>
    with SingleTickerProviderStateMixin {
  bool _showFilteredByUpcomingDeadlinesSorted = false;
  bool _isInit = false;
  bool _isLoading = false;

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
          seconds: 1,
          milliseconds: 300,
        ),
        animationBehavior: AnimationBehavior.preserve);
    _slideAnimation = Tween(
      begin: Offset(
        0,
        100,
      ),
      end: Offset(
        0,
        0,
      ),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.2,
          0.4,
          curve: Curves.easeOut,
        ),
      ),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
        },
      );
      Provider.of<QuestsProvider>(context, listen: false)
          .fetchAndSetLaunchedQuests()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        _controller.forward();
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'The Rhizome',
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilteredOptions opt) {
              if (opt == FilteredOptions.ALL) {
                setState(
                  () {
                    _showFilteredByUpcomingDeadlinesSorted = false;
                  },
                );
              } else {
                setState(
                  () {
                    _showFilteredByUpcomingDeadlinesSorted = true;
                  },
                );
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'All',
                  style: Theme.of(context).textTheme.headline6,
                ),
                value: FilteredOptions.ALL,
              ),
              PopupMenuItem(
                child: Text(
                  'Upcoming',
                  style: Theme.of(context).textTheme.headline6,
                ),
                value: FilteredOptions.UPCOMING,
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Image.asset(
                        'assets/images/rhizome.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: QuestOverviewList(
                          _showFilteredByUpcomingDeadlinesSorted),
                    ),
                    onRefresh: () =>
                        Provider.of<QuestsProvider>(context, listen: false)
                            .fetchAndSetLaunchedQuests(),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.orange[500],
        onPressed: () {
          Navigator.of(context).pushNamed(AddQuestScreen.routeName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final Map<Stage, IconData> iconPerStage = {
    Stage.Explore: Icons.search,
    Stage.Exploit: Icons.all_out,
    Stage.Closed: Icons.lock,
  };

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(
          context,
          null,
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Quest> recieved = query.isEmpty
        ? Provider.of<QuestsProvider>(context).upComingQuests
        : Provider.of<QuestsProvider>(context).launchedQuests.where(
            (element) {
              return element.title.toLowerCase().contains(
                    query.toLowerCase(),
                  );
            },
          ).toList();
    return ListView.builder(
      itemCount: recieved.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(iconPerStage[recieved[index].stage]),
        onTap: () {
          Navigator.of(context).popAndPushNamed(
            QuestDetailScreen.routeName,
            arguments: recieved[index].id,
          );
        },
        title: query.isEmpty
            ? Text(
                recieved[index].title,
                style: Theme.of(context).textTheme.subtitle2,
              )
            : RichText(
                text: TextSpan(
                  text: recieved[index].title.substring(
                        0,
                        recieved[index]
                                    .title
                                    .toLowerCase()
                                    .indexOf(query.toLowerCase()) <=
                                0
                            ? 0
                            : recieved[index]
                                .title
                                .toLowerCase()
                                .indexOf(query.toLowerCase()),
                      ),
                  style: Theme.of(context).textTheme.subtitle2,
                  children: [
                    TextSpan(
                      text: recieved[index].title.substring(
                            recieved[index].title.toLowerCase().indexOf(
                                  query.toLowerCase(),
                                ),
                            recieved[index].title.toLowerCase().indexOf(
                                      query.toLowerCase(),
                                    ) +
                                query.length,
                          ),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextSpan(
                      text: recieved[index].title.substring(
                            recieved[index]
                                    .title
                                    .toLowerCase()
                                    .indexOf(query.toLowerCase()) +
                                query.length,
                          ),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
