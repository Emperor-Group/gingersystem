import 'package:flutter/material.dart';
import 'package:gingersystem/providers/quests_provider.dart';
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
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          accentColor: Colors.amberAccent,
          primaryTextTheme: TextTheme(
            title: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          fontFamily: 'Quicksand',
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(
              title: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                fontSize: 20,
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => QuestOverviewScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => QuestOverviewScreen());
        },
      ),
    );
  }
}


