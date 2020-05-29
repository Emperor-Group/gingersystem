import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/idea_provider.dart';
import 'package:gingersystem/providers/stage.dart';
import 'package:provider/provider.dart';
import 'package:gingersystem/screens/idea_overview_screen.dart';

class IdeaDetailScreen extends StatefulWidget {
  static const routeName = '/idea-detail';

  @override
  _IdeaDetailScreenState createState() => _IdeaDetailScreenState();
}

class _IdeaDetailScreenState extends State<IdeaDetailScreen> {
  bool _isInit = false;
  bool _isLoading = false;
  Idea selectedIdea;
  var list;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, String> obj = ModalRoute.of(context).settings.arguments;
    list = obj.values.toList();
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
        },
      );

      final IdeasProvider ideaManager = Provider.of<IdeasProvider>(context);
      ideaManager.fetchAndSetCommentsByIdea(list[0], list[1]).then((_) {
        setState(() {
          _isLoading = false;
          selectedIdea = ideaManager.getByID(list[0]);
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
            : IdeaDetail(list[1]),
      ),
    );
  }
}

class IdeaDetail extends StatefulWidget {
  final String idQ;
  IdeaDetail(this.idQ) ;
  @override
  _IdeaDetailState createState() => _IdeaDetailState(idQ);

}

class _IdeaDetailState extends State<IdeaDetail> {
  bool supportBoolean = false;
  bool reportBoolean = false;
  String idQuest;

  _IdeaDetailState(this.idQuest);
  @override
  Widget build(BuildContext context) {
    Idea selected = Provider.of<Idea>(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      selected.title.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      "Descripcion:",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      selected.content,
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('Support', textAlign: TextAlign.center,),
                        GestureDetector(
                          child: Icon(
                            supportBoolean
                                ? Icons.wb_incandescent
                                : Icons.lightbulb_outline,
                            color: supportBoolean ? Colors.yellow : Colors.grey,
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
                    Column(
                      children: <Widget>[
                        Text('Discard', textAlign: TextAlign.center,),
                        GestureDetector(
                          child: Icon(
                            reportBoolean ? Icons.report : Icons.report_off,
                            color: reportBoolean ? Colors.grey : Colors.red,
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
          Expanded(
            flex: 1,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Text(
                        "Aqui van las chanclas de mateo ",
                        style: Theme.of(context).textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: FloatingActionButton(
                          heroTag: 'IdeasPadres',
                          child: Icon(Icons.navigate_before),
                          mini: true,
                          onPressed: () {

                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          heroTag: 'IdeasHijas',
                          child: Icon(Icons.navigate_next),
                          mini: true,
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              IdeaOverviewScreen.routeName,
                              arguments: <Idea, String>{selected: idQuest}
                            );
                          },
                        ),
                      ),
                    ],
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
