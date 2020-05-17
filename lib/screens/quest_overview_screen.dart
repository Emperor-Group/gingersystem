import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quests_provider.dart';
import 'package:gingersystem/screens/add_quest.dart';
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
  void didChangeDependencies() {
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
        )).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.2,
        0.4,
        curve: Curves.easeOut,
      ),
    ));
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
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddQuestScreen.routeName);
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
