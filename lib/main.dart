import 'package:flutter/material.dart';
import 'package:gingersystem/providers/auth.dart';
import 'package:gingersystem/providers/quests_provider.dart';
import 'package:gingersystem/screens/add_quest.dart';
import 'package:gingersystem/screens/auth_screen.dart';
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
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, QuestsProvider>(
          create: (ctx) => QuestsProvider('', '', []),
          update: (ctx, auth, previousQuest) => QuestsProvider(
            auth.token,
            auth.userId,
            previousQuest.launchedQuests,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.orange[500],
            fontFamily: 'Quicksand',
            textTheme: TextTheme(
              headline1: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey[700],
              ),
              headline2: TextStyle(
                fontFamily: 'RobotoCondensed',
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
              headline3: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
              headline4: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
              headline5: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              subtitle1: TextStyle(
                fontFamily: 'Quicksand',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.orange[500],
              ),
              subtitle2: TextStyle(),
              caption: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.orange,
              ),
              bodyText1: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.black,
              ),
              bodyText2: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.deepOrange,
              ),
              button: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          home: auth.isAuth
              ? QuestOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogIn(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Center()
                          : AuthScreen(),
                ),
          routes: {
            QuestDetailScreen.routeName: (ctx) => QuestDetailScreen(),
            AddQuestScreen.routeName: (ctx) => AddQuestScreen(),
          },
        ),
      ),
    );
  }
}
