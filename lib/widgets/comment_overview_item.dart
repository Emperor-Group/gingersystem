import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/comment.dart';
import 'package:provider/provider.dart';

class CommentOverviewItem extends StatefulWidget {
  @override
  _CommentOverviewItemState createState() => _CommentOverviewItemState();
}

class _CommentOverviewItemState extends State<CommentOverviewItem> {
  int votes = -1;
  bool activeVote = false;
  bool challenge = false;

  @override
  Widget build(BuildContext context) {
    final Comment comment = Provider.of<Comment>(context);
    if (votes < 0) {
      votes = comment.votes;
    }
    final deviceSize = MediaQuery.of(context).size;
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
                                challenge = challenge ? false : true;
                              },
                              child: Icon(
                                Icons.gavel,
                                color: challenge ? Colors.purple : Colors.grey,
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
                                          child: activeVote
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
                                            if (!activeVote) {
                                              activeVote = true;
                                              votes++;
                                            } else {
                                              activeVote = false;
                                              votes--;
                                            }
                                          },
                                        ),
                                        Text(
                                          "$votes",
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
