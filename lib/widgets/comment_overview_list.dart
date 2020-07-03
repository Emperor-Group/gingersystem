import 'package:flutter/material.dart';
import 'package:gingersystem/widgets/comment_overview_item.dart';
import 'package:provider/provider.dart';
import 'package:gingersystem/providers/comment_provider.dart';
import 'package:gingersystem/providers/comment.dart';

class CommentOverviewList extends StatefulWidget {
  String idQuest;
  String idIdea;

  CommentOverviewList(this.idQuest, this.idIdea);

  @override
  _CommentOverviewListState createState() => _CommentOverviewListState();
}

class _CommentOverviewListState extends State<CommentOverviewList> {
  String idQuest;
  String idIdea;
  Size deviceSize;
  bool checkingFlight = false;
  bool success = false;
  bool _isInit;
  bool _isLoading;
  CommentProvider commentManager;
  List<Comment> comments;

  @override
  void initState() {
    idQuest = widget.idQuest;
    idIdea = widget.idIdea;
    _isInit = false;
    _isLoading = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<CommentProvider>(context, listen: false)
          .fetchAndSetCommentsByQuestAndIdea(idQuest, idIdea)
          .then(
        (value) {
          setState(
            () {
              _isLoading = false;
            },
          );
        },
      );
    }
    _isInit = true;
    commentManager = Provider.of<CommentProvider>(context);
    comments = commentManager.comments;
    deviceSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  void addComment(BuildContext context, bool checkingFlight, bool success,
      CommentProvider commentManager) {
    TextEditingController tec1 = new TextEditingController();
    TextEditingController tec2 = new TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: deviceSize.height,
            margin: const EdgeInsets.only(left: 15, right: 15),
            padding: EdgeInsets.only(top: 12),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: deviceSize.height * 0.3,
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
                          height: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Titulo...',
                                ),
                                style: Theme.of(context).textTheme.bodyText2,
                                autofocus: false,
                                maxLines: null,
                                keyboardType: TextInputType.text,
                                controller: tec1,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
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
                              hintText: 'Comentario...',
                            ),
                            style: Theme.of(context).textTheme.bodyText2,
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.text,
                            controller: tec2,
                          ),
                        ),
                        !checkingFlight
                            ? MaterialButton(
                                color: Colors.grey[800],
                                onPressed: () async {
                                  setState(() {
                                    checkingFlight = true;
                                    commentManager.addComment(
                                        idQuest, idIdea, tec1.text, tec2.text);
                                  });
                                  await Future.delayed(Duration(seconds: 1));
                                  setState(() {
                                    success = true;
                                  });
                                  await Future.delayed(
                                      Duration(milliseconds: 500));
                                  Navigator.pop(context);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Compartir',
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
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
            child: Container(
              width: deviceSize.width,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                          value: comments[index],
                          child: CommentOverviewItem(
                              this.idQuest, this.idIdea, comments[index].id),
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
                              addComment(context, checkingFlight, success,
                                  commentManager);
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
