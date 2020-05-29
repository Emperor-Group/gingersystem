import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/idea_provider.dart';
import 'package:gingersystem/widgets/idea_overview_list.dart';
import 'package:provider/provider.dart';


class IdeaOverviewScreen extends StatefulWidget {
  static String routeName='/idea-overview-screen';

  @override
  _IdeaOverviewScreenState createState() => _IdeaOverviewScreenState();
}

class _IdeaOverviewScreenState extends State<IdeaOverviewScreen> with SingleTickerProviderStateMixin {
  bool _isInit = false;
  bool _isLoading = false;
  Idea ideaActual;
  String questActual;

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
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
      print('deaActual.id.toString() '+ideaActual.id.toString());
      print('questActual '+questActual);
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Idea Control Screen',
          style: Theme.of(context).textTheme.headline5,),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(50),
            child: Center(
              child: Text(ideaActual.title,textAlign: TextAlign.center,)
            ),
          ),
//          Expanded(
//            child: RefreshIndicator(
//              child: SlideTransition(
//                position: _slideAnimation,
//                child: IdeaOverviewList(
//                    ideaActual, questActual ),
//              ),
//              onRefresh: () =>
//                  Provider.of<IdeasProvider>(context, listen: false)
//                      .fetchAndSetLaunchedQuests(),
//            ),
//          ),
        ],
      ),
    );
  }
}


