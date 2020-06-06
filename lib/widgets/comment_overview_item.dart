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

  _CommentOverviewItemState(this.idQuest, this.idIdea, this.idComment);

  @override
  Widget build(BuildContext context) {
    final Comment comment = Provider.of<Comment>(context);
    final CommentProvider commentManager =
        Provider.of<CommentProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
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
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          child: comment.vote
                                              ? Icon(
                                                  Icons.arrow_drop_up,
                                                  color: Colors.lightBlue,
                                                  size: 30,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
