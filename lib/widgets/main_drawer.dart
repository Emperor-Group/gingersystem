import 'package:flutter/material.dart';
import 'package:gingersystem/providers/auth.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: size.height * 0.15,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomCenter,
            color: Theme.of(context).primaryColor,
            child: Text(
              'Dynamic Forums',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Container(
            color: Colors.grey[200],
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Log out',
                style: Theme.of(context).textTheme.headline4,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(
                top: 100,
                left: 80,
                right: 80,
                bottom: 20,
              ),
              child: Image.asset(
                'assets/images/ImagotipoEmperorgroup.png',
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
    );
  }
}
