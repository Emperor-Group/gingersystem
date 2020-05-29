import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/idea_provider.dart';
import 'package:provider/provider.dart';
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
      print('list ' + list.toString());
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
            : IdeaDetail(),
      ),
    );
  }
}

class IdeaDetail extends StatefulWidget {
  IdeaDetail({Key key}) : super(key: key);

  @override
  _IdeaDetailState createState() => _IdeaDetailState();
}

class _IdeaDetailState extends State<IdeaDetail> {
  bool supportBoolean = false;
  bool reportBoolean = false;
  bool showComments = false;

  void showcomments(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
              margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
              height: deviceSize.height * 0.9,
              child: CommentOverviewList());
        });
  }

  @override
  Widget build(BuildContext context) {
    Idea selected = Provider.of<Idea>(context);
    final deviceSize = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Expanded(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    selected.title.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    "Descripcion:",
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              margin: EdgeInsets.only(right: 40),
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Support',
                        textAlign: TextAlign.center,
                      ),
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
                      Text(
                        'Discard',
                        textAlign: TextAlign.center,
                      ),
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
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: GestureDetector(
              onTap: () {
                showcomments(context);
              },
              child: Center(
                child: Container(
                  height: deviceSize.height * 0.1,
                  width: deviceSize.width * 0.8,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
