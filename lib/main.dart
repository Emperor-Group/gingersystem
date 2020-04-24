import 'package:flutter/material.dart';

void main() => runApp(Rhizome());

class Rhizome extends StatelessWidget {
  const Rhizome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TheRhizomeApp(),
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.amberAccent[400],

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
    );
  }
}

class TheRhizomeApp extends StatelessWidget {
  const TheRhizomeApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Rhizome'),
      ),
      body: Text(
        "Display your app here",
        style: Theme.of(context).primaryTextTheme.title,
      ),
    );
  }
}
