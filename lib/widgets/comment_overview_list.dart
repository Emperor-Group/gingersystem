import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quests_provider.dart';
import 'package:gingersystem/widgets/comment_overview_item.dart';
import 'package:provider/provider.dart';
import 'package:gingersystem/providers/comment.dart';

class CommentOverviewList extends StatefulWidget {
  @override
  _CommentOverviewListState createState() => _CommentOverviewListState();
}

class _CommentOverviewListState extends State<CommentOverviewList> {
  @override
  void didChangeDependencies() {
    Provider.of<Comment>(context, listen: false)
        .fetchAndSetCommentsByQuestAndIdea(
            '-M7E1BpiBF0AjxfHQuls', '-M7E1BvVdL9pPvmgKaeF');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final Comment commentManager = Provider.of<Comment>(context);
    final List<Comment> comments = commentManager.comments;
    return Container(
      height: deviceSize.height * 0.8,
      width: deviceSize.width * 0.9,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Container(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (ctx, index) {
                return ChangeNotifierProvider.value(
                  value: comments[index],
                  child: CommentOverviewItem(),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                    mini: true,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.deepOrange,
                    onPressed: () {
                      //Navigator.of(context).pushNamed(AddQuestScreen.routeName);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
Stack(
              children: <Widget>[
                Column(
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
                          child:
                              /*CommentOverviewList(),
                        )*/
                              QuestOverviewList(
                                  _showFilteredByUpcomingDeadlinesSorted),
                        ),
                        onRefresh: () =>
                            Provider.of<QuestsProvider>(context, listen: false)
                                .fetchAndSetLaunchedQuests(),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    showComments
                        ? AnimatedPositioned(
                            duration: Duration(milliseconds: 1500),
                            child: Center(
                              child: CommentOverviewList(),
                            ),
                          )
                        : GestureDetector(
                            onVerticalDragStart: (details) => setState(() {
                              showComments = true;
                            }),
                            onTap: () {
                              setState(() {
                                showComments = true;
                              });
                            },
                            child: Center(
                              child: Container(
                                height: deviceSize.height * 0.1,
                                width: deviceSize.width * 0.8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
 */
/*Container(
      height: deviceSize.height * 0.8,
      width: deviceSize.width * 0.9,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: deviceSize.height * 0.73,
            width: deviceSize.width * 0.9,
            color: Colors.white,
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (ctx, index) {
                return ChangeNotifierProvider.value(
                  value: comments[0],
                  child: CommentOverviewItem(),
                );
              },
            ),
          ),
          Container(
            height: deviceSize.height * 0.07,
            padding: EdgeInsets.only(top: 6, bottom: 6),
            child: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.deepOrange,
                onPressed: () {
                  //Navigator.of(context).pushNamed(AddQuestScreen.routeName);
                }),
          ),
        ],
      ),
    );*/
/*ChangeNotifierProxyProvider<Auth, Comment>(
          create: (ctx) => Comment('', ''),
          update: (ctx, auth, previousQuest) => Comment(
            auth.token,
            auth.userId,
          ),
        )*/
/*  void prueba(BuildContext context, bool checkingFlight, bool success) {
    final deviceSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
            height: deviceSize.height * 0.3,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: deviceSize.height * 0.2,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              color: Colors.grey[300],
                              spreadRadius: 5)
                        ]),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Comentario",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        Container(
                            height: deviceSize.height * 0.06,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10)),
                            child: TextField(
                              decoration: InputDecoration.collapsed(
                                hintText: 'Ingresa el comentario...',
                              ),
                              style: Theme.of(context).textTheme.bodyText2,
                            )),
                        !checkingFlight
                            ? MaterialButton(
                                color: Colors.grey[800],
                                onPressed: () async {
                                  setState(() {
                                    checkingFlight = true;
                                  });
                                  await Future.delayed(Duration(seconds: 1));
                                  setState(() {
                                    success = true;
                                  });
                                  await Future.delayed(
                                      Duration(milliseconds: 500));
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Check Flight',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : !success
                                ? CircularProgressIndicator()
                                : Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                      ],
                    ),
                  )
                ]),
          );
        });
  }*/
