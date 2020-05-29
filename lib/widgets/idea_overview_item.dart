import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/stage.dart';
import 'package:gingersystem/screens/quest_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IdeaOveviewItem extends StatefulWidget {
  @override
  _IdeaOveviewItemState createState() => _IdeaOveviewItemState();
}

class _IdeaOveviewItemState extends State<IdeaOveviewItem> {
  bool supportBoolean=false;
  bool reportBoolean=false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
        leading: FittedBox(
          child: Column(
            children: <Widget>[
              Text(
                "Titulo idea",
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                "Descripcion de idea....",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('Support'),
                        GestureDetector(
                          child: Icon(
                            supportBoolean ? Icons.wb_incandescent :Icons.lightbulb_outline,
                            color: supportBoolean ? Colors.yellow: Colors.grey,
                          ),
                          onTap: (){
                            setState(() {
                              supportBoolean=!supportBoolean;
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('Discard'),
                        GestureDetector(
                          child: Icon(
                            reportBoolean ? Icons.report :Icons.report_off,
                            color: reportBoolean ? Colors.grey: Colors.red,
                          ),
                          onTap: (){
                            setState(() {
                              reportBoolean=!reportBoolean;
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
        ),
      ),
    );
  }
}