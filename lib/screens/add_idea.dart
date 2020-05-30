import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/idea_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddIdeaScreen extends StatefulWidget {
  static const routeName = '/add-quest';

  @override
  _AddIdeaScreenState createState() => _AddIdeaScreenState();
}

class _AddIdeaScreenState extends State<AddIdeaScreen> {
  final _questTitleFocusNode = FocusNode();
  DateTime _dateTime;
  final _ideaTitleFocusNode = FocusNode();
  final _ideaDescriptionNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;

  Idea _savedIdea=Idea.addIdea(
      id: '',
      title: '',
      content: '',
      owner: '',
      supportData: [],
      published: DateTime.now());

  void _saveForm() async{
    final bool isValid = _form.currentState.validate();
    if (!isValid || _dateTime == null) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, String> obj = ModalRoute.of(context).settings.arguments;
//      await Provider.of<IdeasProvider>(context, listen: false).addIdea(
//        _savedQuest,
//        _savedIdea,
//      );
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Error',
          ),
          content: Text(
            'Something went wrong',
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } finally {
      setState(
            () {
          _isLoading = false;
        },
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new Idea'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: (_saveForm()),
          )
        ],
      ),
    );
  }
}
