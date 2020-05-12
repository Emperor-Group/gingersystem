import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quests_provider.dart';
import 'package:gingersystem/screens/quest_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:gingersystem/screens/quest_overview_screen.dart';

void main() => runApp(Rhizome());

class Rhizome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: QuestsProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.amberAccent,
          fontFamily: 'Quicksand',
          textTheme: TextTheme(
            headline1: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey[700],
            ),
            headline2: TextStyle(),
            headline3: TextStyle(),
            headline4: TextStyle(),
            headline5: TextStyle(),
            headline6: TextStyle(),
            subtitle1: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 13,
              color: Colors.orange[500],
            ),
            subtitle2: TextStyle(),
            caption: TextStyle(),
            bodyText1: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.black,
            ),
            bodyText2: TextStyle(),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => QuestOverviewScreen(),
          QuestDetailScreen.routeName: (ctx) => QuestDetailScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => QuestOverviewScreen());
        },
      ),
    );
  }
}
