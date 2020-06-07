import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/comment.dart';
import 'package:provider/provider.dart';
import 'package:gingersystem/providers/comment_provider.dart';

class CommentOverviewItem extends StatefulWidget {
  String idQuest;
  String idIdea;
  String idComment;

  CommentOverviewItem(this.idQuest, this.idIdea, this.idComment);

  @override
  _CommentOverviewItemState createState() =>
      _CommentOverviewItemState(this.idQuest, this.idIdea, this.idComment);
}

class _CommentOverviewItemState extends State<CommentOverviewItem> {
  int votes = -1;
  bool activeVote = false;
  bool challenge = false;
  String idQuest;
  String idIdea;
  String idComment;
  Comment comment;
  CommentProvider commentManager;
  bool isConfig = false;

  _CommentOverviewItemState(this.idQuest, this.idIdea, this.idComment);

  void didChangeDependencies() {
    comment = Provider.of<Comment>(context);
    commentManager = Provider.of<CommentProvider>(context);
    super.didChangeDependencies();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmar',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Esta seguro de eliminar este comentario? ',
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  'No se puede revocar esta acción.',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Confirmar'),
              onPressed: () {
                commentManager.deleteComment(idQuest, idIdea, idComment);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void modifyComment(BuildContext context, bool checkingFlight, bool success,
      CommentProvider commentManager, Comment comment) {
    final deviceSize = MediaQuery.of(context).size;
    TextEditingController tec1 = new TextEditingController();
    tec1.text = comment.title;
    TextEditingController tec2 = new TextEditingController();
    tec2.text = comment.content;
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
                                    commentManager.modifyComment(
                                        idQuest,
                                        idIdea,
                                        comment.id,
                                        tec1.text,
                                        tec2.text);
                                  });
                                  comment.title = tec1.text;
                                  comment.content = tec2.text;
                                  await Future.delayed(Duration(seconds: 1));
                                  setState(() {
                                    success = true;
                                  });
                                  await Future.delayed(
                                      Duration(milliseconds: 500));
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Modificar',
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

  bool checkingFlight = false;
  bool success = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onLongPressEnd: (details) {
          if (comment.isOwner(commentManager.userId)) {
            setState(() {
              isConfig = isConfig ? false : true;
            });
          }
        },
        child: Card(
          elevation: 10,
          color:
              comment.isOwner(commentManager.userId) ? Colors.grey[200] : null,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Text(
                                '${comment.title}',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  if (comment.isOwner(commentManager.userId)) {
                                    comment.switchIsChallenge();
                                    commentManager.switchIsChallenge(idQuest,
                                        idIdea, idComment, comment.isChallenge);
                                  }
                                },
                                child: Icon(
                                  Icons.gavel,
                                  color: comment.isChallenge
                                      ? Colors.purple
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Text(
                                  '${comment.content}',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Votos",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            child: comment.vote
                                                ? Icon(
                                                    Icons.change_history,
                                                    color: Colors.lightBlue,
                                                  )
                                                : Icon(
                                                    Icons.change_history,
                                                    color: Colors.grey,
                                                  ),
                                            onTap: () {
                                              comment.switchVote();
                                              commentManager.switchVote(
                                                  idQuest,
                                                  idIdea,
                                                  idComment,
                                                  comment.vote,
                                                  comment.votes);
                                            },
                                          ),
                                          Text(
                                            "${comment.votes}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        isConfig
                            ? const Divider(
                                color: Colors.black,
                                height: 10,
                                thickness: 2,
                                endIndent: 0,
                              )
                            : Container(),
                        isConfig
                            ? Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        modifyComment(context, checkingFlight,
                                            success, commentManager, comment);
                                      },
                                      child: Icon(
                                        Icons.create,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        _showMyDialog().then((value) =>
                                            Navigator.of(context).pop());
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
