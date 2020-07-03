import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/idea_provider.dart';
import 'package:provider/provider.dart';
import 'package:gingersystem/screens/idea_overview_screen.dart';
import 'package:gingersystem/widgets/comment_overview_list.dart';
import 'package:url_launcher/url_launcher.dart';

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
    ideaId = obj['ideaId'];
    questId = obj['questId'];

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
    }
    _isInit = true;
  }

  @override
  Widget build(BuildContext context) {
//    print('initialSupport '+initialSupport.toString());
//    print('initialDiscard '+initialDiscard.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Idea Control Screen'),
      ),
      body: ChangeNotifierProvider.value(
        value: selectedIdea,
        child: (_isLoading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : IdeaDetail(questId, ideaId),
      ),
    );
  }
}

// ignore: must_be_immutable
class IdeaDetail extends StatefulWidget {
  String idQ;
  String idIdea;

  IdeaDetail(this.idQ, this.idIdea);

  @override
  _IdeaDetailState createState() => _IdeaDetailState();
}

class _IdeaDetailState extends State<IdeaDetail> {
  String idQuest;
  String idIdea1;
  bool supportBoolean = false;
  bool reportBoolean = false;
  bool _isInit = false;
  bool _isLoading = false;
  bool _isLoading2 = false;
  bool showComments = false;

  @override
  void initState() {
    super.initState();
    idQuest = widget.idQ;
    idIdea1 = widget.idIdea;
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
          _isLoading2 = true;
        },
      );
      final IdeasProvider ideaManager = Provider.of<IdeasProvider>(context);
      ideaManager
          .getVotosDeUsuarioEnIdeaSupportOrDiscard(idQuest, idIdea1, 'support')
          .then((value) => setState(() {
                supportBoolean = (value != 0);
                _isLoading = false;
              }));
      ideaManager
          .getVotosDeUsuarioEnIdeaSupportOrDiscard(idQuest, idIdea1, 'discard')
          .then((value) => setState(() {
                reportBoolean = (value != 0);
                _isLoading2 = false;
              }));
    }
    _isInit = true;
    super.didChangeDependencies();
  }

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
    return (_isLoading && _isLoading2)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: (selected.supportDataLink)
                                ? RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                          text:
                                              'Descargar los documentos de soporte: ',
                                        ),
                                        TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2,
                                          text: 'Dando click aquí',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final url =
                                                  Provider.of<IdeasProvider>(
                                                          context,
                                                          listen: false)
                                                      .link;
                                              if (await canLaunch(url)) {
                                                await launch(
                                                  url,
                                                  forceSafariVC: false,
                                                );
                                              }
                                            },
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    child: Text('no hay files en esta idea'),
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
                                      Text(
                                        selected.supportVotes != null
                                            ? selected.supportVotes.toString()
                                            : '0',
                                        style: selected.supportVotes == 0
                                            ? TextStyle(
                                                fontSize: 25,
                                                color: Colors.grey,
                                              )
                                            : TextStyle(
                                                fontSize: 25,
                                                color: Colors.green,
                                              ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            !supportBoolean
                                                ? 'Support'
                                                : 'Supported',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                          GestureDetector(
                                            child: Icon(
                                              !supportBoolean
                                                  ? Icons.wb_incandescent
                                                  : Icons.lightbulb_outline,
                                              color: supportBoolean
                                                  ? Colors.grey
                                                  : Colors.yellow,
                                              size: 50,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                IdeasProvider ideaManager =
                                                    Provider.of<IdeasProvider>(
                                                        context,
                                                        listen: false);
                                                if (!supportBoolean) {
                                                  selected.supportVotes =
                                                      selected.supportVotes + 1;
                                                  ideaManager.switchVotes(
                                                      idQuest,
                                                      selected.id,
                                                      selected.supportVotes,
                                                      selected.discardVotes);
                                                } else {
                                                  selected.supportVotes =
                                                      selected.supportVotes - 1;
                                                  ideaManager.switchVotes(
                                                      idQuest,
                                                      selected.id,
                                                      selected.supportVotes,
                                                      selected.discardVotes);
                                                }
                                                supportBoolean =
                                                    !supportBoolean;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        selected.discardVotes != null
                                            ? selected.discardVotes.toString()
                                            : '0',
                                        style: selected.discardVotes == 0
                                            ? TextStyle(
                                                fontSize: 25,
                                                color: Colors.grey,
                                              )
                                            : TextStyle(
                                                fontSize: 25,
                                                color: Colors.red,
                                              ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            !reportBoolean
                                                ? 'Discard'
                                                : 'Discarded',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                          GestureDetector(
                                            child: Icon(
                                              !reportBoolean
                                                  ? Icons.report
                                                  : Icons.report_off,
                                              color: reportBoolean
                                                  ? Colors.grey
                                                  : Colors.red,
                                              size: 50,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                IdeasProvider ideaManager =
                                                    Provider.of<IdeasProvider>(
                                                        context,
                                                        listen: false);
                                                if (!reportBoolean) {
                                                  selected.discardVotes =
                                                      selected.discardVotes + 1;
                                                  ideaManager.switchVotes(
                                                      idQuest,
                                                      selected.id,
                                                      selected.supportVotes,
                                                      selected.discardVotes);
                                                } else {
                                                  selected.discardVotes =
                                                      selected.discardVotes - 1;
                                                  ideaManager.switchVotes(
                                                      idQuest,
                                                      selected.id,
                                                      selected.supportVotes,
                                                      selected.discardVotes);
                                                }
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
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
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
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  IdeaOverviewScreen.routeName,
                                  arguments: <Idea, String>{
                                    selected: idQuest,
                                    null: 'ideasPadres'
                                  });
                            },
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
