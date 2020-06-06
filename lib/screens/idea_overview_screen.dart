import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/idea_provider.dart';
import 'package:gingersystem/widgets/idea_overview_list.dart';
import 'package:provider/provider.dart';
import 'add_idea.dart';

enum FilteredOptions {
  DEPTH,
  ALTERNATE,
  MIX,
}

class IdeaOverviewScreen extends StatefulWidget {
  static String routeName='/idea-overview-screen';

  @override
  _IdeaOverviewScreenState createState() => _IdeaOverviewScreenState();
}

class _IdeaOverviewScreenState extends State<IdeaOverviewScreen> with SingleTickerProviderStateMixin {
  FilteredOptions _showFiltered = FilteredOptions.MIX;
  List<StorageInfo> _storageInfo = [];
  bool _isInit = false;
  bool _isLoading = false;
  Idea ideaActual;
  String questActual;
  String padresOHijas;

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    initPlatformState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
          seconds: 1,
          milliseconds: 300,
        ),
        animationBehavior: AnimationBehavior.preserve);
    _slideAnimation = Tween(
      begin: Offset(
        0,
        100,
      ),
      end: Offset(
        0,
        0,
      ),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.2,
          0.4,
          curve: Curves.easeOut,
        ),
      ),
    );
    super.initState();

  }

  @override
  void didChangeDependencies() {

    if (!_isInit) {
      setState(
            () {
          _isLoading = true;
        },
      );
      Map<Idea, String> obj = ModalRoute.of(context).settings.arguments;
      questActual=obj.values.toList()[0];
      ideaActual=obj.keys.toList()[0];
      padresOHijas=obj.values.toList()[1];

//      Provider.of<IdeasProvider>(context, listen: false)
//          .fetchAndSetLaunchedQuests()
//          .then((_) {
//        setState(() {
//          _isLoading = false;
//        });
//        _controller.forward();
//      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    List<StorageInfo> storageInfo;
    try {
      storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException {}

    if (!mounted) return;

    setState(() {
      _storageInfo = storageInfo;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
         PopupMenuButton(
           icon: Icon(Icons.more_vert),
           onSelected: (FilteredOptions opt){
             if (opt == FilteredOptions.MIX) {
               setState(
                     () {
                   _showFiltered =
                       FilteredOptions.MIX;
                 },
               );
             } else if (opt == FilteredOptions.DEPTH) {
               setState(
                     () {
                   _showFiltered =
                       FilteredOptions.DEPTH;
                 },
               );
             } else {
               setState(
                     () {
                   _showFiltered =
                       FilteredOptions.ALTERNATE;
                 },
               );
             }
           },
           itemBuilder: (_)=>[
             PopupMenuItem(
               child: Row(
                 children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.only(right: 5),
                     child: Icon(
                       Icons.all_inclusive,
                       color: Colors.black,
                       size: 15,
                     ),
                   ),
                   Text(
                     'Mix',
                     style: Theme.of(context).textTheme.headline2,
                   ),
                 ],
               ),
               value: FilteredOptions.MIX,
             ),
             PopupMenuItem(
               child: Row(
                 children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.only(right: 5),
                     child: Icon(
                       Icons.vertical_align_bottom,
                       color: Colors.black,
                       size: 15,
                     ),
                   ),
                   Text(
                     'Depth',
                     style: Theme.of(context).textTheme.headline2,
                   ),
                 ],
               ),
               value: FilteredOptions.DEPTH,
             ),
             PopupMenuItem(
               child: Row(
                 children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.only(right: 5),
                     child: Icon(
                       Icons.merge_type,
                       color: Colors.black,
                       size: 15,
                     ),
                   ),
                   Text(
                     'Alternate',
                     style: Theme.of(context).textTheme.headline2,
                   ),
                 ],
               ),
               value: FilteredOptions.ALTERNATE,
             )
           ],
         )
        ],
        title: Text('Ideas Control Screen',
          style: Theme.of(context).textTheme.headline5,),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    ideaActual.title.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    padresOHijas == 'ideasHijas' ? 'Ideas Hijas':'Ideas Padre',
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          Expanded(
            child: RefreshIndicator(
              child: SlideTransition(
                position: _slideAnimation,
                child: IdeaOverviewList(
                    ideaActual, questActual ),
              ),
              onRefresh: () =>
                  Provider.of<IdeasProvider>(context, listen: false)
                      .fetchAndSetLaunchedIdeasChildren(questActual, ideaActual.id),
            ),
          ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                heroTag: 'newIdea',
                mini: false,
                child: Icon(Icons.add),
                onPressed: (){
//                  Provider.of<IdeasProvider>(context, listen: false).addIdea(
//                      'Titulo de una idea 2',
//                      'Contenido de una idea2',
//                      [File('/data/user/0/com.example.gingersystem/cache/file_picker/The Fountainhead (Centennial Edition Hardcover) by Ayn Rand (z-lib.org).pdf'), File('/data/user/0/com.example.gingersystem/cache/file_picker/Ukulele Exercises For Dummies® by McQueen, Brett (z-lib.org).pdf')],
//                      questActual,
//                    ideaActual.id
//                  );
                  //File('Internal storage/Download/The Fountainhead (Centennial Edition Hardcover) by Ayn Rand (z-lib.org).pdf'),
                  Navigator.of(context).pushNamed(
                    AddIdeaScreen.routeName,
                    arguments: <String, String>{
                      'idIdea': ideaActual.id,
                      'idQuest': questActual,
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}


