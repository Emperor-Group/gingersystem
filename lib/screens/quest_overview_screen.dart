import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quests_provider.dart';
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

class _QuestOverviewScreenState extends State<QuestOverviewScreen> {
  bool _showFilteredByUpcomingDeadlinesSorted = false;
  bool _isInit = false;
  bool _isLoading = false;

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
      });
    }
    _isInit = true;
    super.didChangeDependencies();
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
            onPressed: () => () {},
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
                    child: Image.asset(
                      'assets/images/rhizome.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    child: QuestOverviewList(
                        _showFilteredByUpcomingDeadlinesSorted),
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
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
