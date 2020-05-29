import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/idea_provider.dart';
import 'package:provider/provider.dart';

class IdeaDetailScreen extends StatefulWidget {
  static const routeName = '/idea-detail';

  @override
  _IdeaDetailScreenState createState() => _IdeaDetailScreenState();
}

class _IdeaDetailScreenState extends State<IdeaDetailScreen> {
  bool _isInit = false;
  Idea selectedIdea;
  var list ;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
       Map<String,String> obj= ModalRoute.of(context).settings.arguments;
      list = obj.values.toList();
       final IdeasProvider ideaManager = Provider.of<IdeasProvider>(context);
       ideaManager.fetchAndSetCommentsByIdea(list[0],list[1]);
       selectedIdea = ideaManager.getByID(list[0]);
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
        child: IdeaDetail(),
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
  @override
  Widget build(BuildContext context) {
    Idea selected = Provider.of<Idea>(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            selected.title.toUpperCase(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            "Descripcion:",
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(
            selected.content,
            style: Theme.of(context).textTheme.caption,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 25, 0, 25),
                  child: Column(
                    children: <Widget>[
                      Text('Support'),
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 25, 25, 25),
                  child: Column(
                    children: <Widget>[
                      Text('Discard'),
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
                ),
              ],
            ),
          ),
        SizedBox(
          child: Text('AQUI VAN LAS CHANCLAS DE MATEO', textAlign: TextAlign.center,),
          width: double.infinity,
          height: 160,
        )],
      ),
    );
  }
}
