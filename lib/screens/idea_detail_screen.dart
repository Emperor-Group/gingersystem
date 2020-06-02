import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/idea_provider.dart';
import 'package:provider/provider.dart';
import 'package:gingersystem/screens/idea_overview_screen.dart';
import 'package:gingersystem/widgets/comment_overview_list.dart';

class IdeaDetailScreen extends StatefulWidget {
  static const routeName = '/idea-detail';

  @override
  _IdeaDetailScreenState createState() => _IdeaDetailScreenState();
}

class _IdeaDetailScreenState extends State<IdeaDetailScreen> {
  bool _isInit = false;
  bool _isLoading = false;
  Idea selectedIdea;
  String ideaId;
  String questId;

  var list;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, String> obj = ModalRoute.of(context).settings.arguments;
    list = obj.values.toList();
    ideaId=obj['ideaId'];
    questId=obj['questId'];

    if (!_isInit) {
      setState(
            () {
          _isLoading = true;
        },
      );

      final IdeasProvider ideaManager = Provider.of<IdeasProvider>(context);
      ideaManager.fetchAndSetOneIdeaByQuest(ideaId, questId).then((_) {
        setState(() {
          _isLoading = false;
          selectedIdea = ideaManager.getByID(ideaId);
        });
      });
      //print('list ' + list.toString());
    }
    _isInit = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Idea Control Screen'),
      ),
      body: ChangeNotifierProvider.value(
        value: selectedIdea,
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : IdeaDetail(questId),
      ),
    );
  }
}

class IdeaDetail extends StatefulWidget {
  final String idQ;

  IdeaDetail(this.idQ);

  @override
  _IdeaDetailState createState() => _IdeaDetailState(idQ);
}

class _IdeaDetailState extends State<IdeaDetail> {
  bool supportBoolean = false;
  bool reportBoolean = false;
  String idQuest;

  _IdeaDetailState(this.idQuest);

  bool showComments = false;

  void showcomments(BuildContext context, String idQuest, String idIdea) {
    final deviceSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
            height: deviceSize.height,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'Comentarios',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                CommentOverviewList(idQuest, idIdea),
              ],
            ),
            /*child: CommentOverviewList(
                '-M7E1BpiBF0AjxfHQuls', '-M7E1BvVdL9pPvmgKaeF'),*/
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Idea selected = Provider.of<Idea>(context);
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        selected.title.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        "Descripción:",
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        selected.content,
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Support',
                                      textAlign: TextAlign.center,
                                      style:
                                      Theme.of(context).textTheme.headline2,
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        supportBoolean
                                            ? Icons.wb_incandescent
                                            : Icons.lightbulb_outline,
                                        color: supportBoolean
                                            ? Colors.yellow
                                            : Colors.grey,
                                        size: 50,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          supportBoolean = !supportBoolean;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'Discard',
                                      textAlign: TextAlign.center,
                                      style:
                                      Theme.of(context).textTheme.headline2,
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        reportBoolean
                                            ? Icons.report
                                            : Icons.report_off,
                                        color: reportBoolean
                                            ? Colors.grey
                                            : Colors.red,
                                        size: 50,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          reportBoolean = !reportBoolean;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Stack(
          children: <Widget>[
            Container(
              child: GestureDetector(
                onVerticalDragStart: (details) => setState(() {
                  showcomments(context, idQuest, selected.id);
                }),
                onTap: () {
                  showcomments(context, idQuest, selected.id);
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 40),
                      alignment: Alignment.bottomCenter,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Comentarios',
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, left: 7, right: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                      heroTag: 'ideasPadres',
                      child: Icon(Icons.navigate_before),
                      mini: true,
                      onPressed: () {},
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      heroTag: 'ideasHijas',
                      child: Icon(Icons.navigate_next),
                      mini: true,
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            IdeaOverviewScreen.routeName,
                            arguments: <Idea, String>{
                              selected: idQuest,
                              null: 'ideasHijas'
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}