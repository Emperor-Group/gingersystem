import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:gingersystem/providers/quests_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddQuestScreen extends StatefulWidget {
  static const routeName = '/add-quest';

  AddQuestScreen({Key key}) : super(key: key);

  @override
  _AddQuestScreenState createState() => _AddQuestScreenState();
}

class _AddQuestScreenState extends State<AddQuestScreen> {
  final _questTitleFocusNode = FocusNode();
  DateTime _dateTime;
  final _ideaTitleFocusNode = FocusNode();
  final _ideaDescriptionNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  Quest _savedQuest = Quest.initializeQuest(
    "",
    "",
    id: "",
    title: "",
    launchedDate: DateTime.now(),
    deadline: DateTime.now(),
    initIdeaID: "",
  );
  Idea _savedIdea = Idea.createInitialIdea(
    id: "",
    title: "",
    content: "",
    published: DateTime.now(),
  );

  void dispose() {
    _questTitleFocusNode.dispose();
    _ideaTitleFocusNode.dispose();
    _ideaDescriptionNode.dispose();
    super.dispose();
  }

  void _presentDatePicker(BuildContext ctx) {
    showDatePicker(
      context: ctx,
      initialDate: DateTime.now().add(Duration(days: 2)),
      firstDate: DateTime.now().add(Duration(days: 2)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        } else {
          setState(
            () {
              _dateTime = pickedDate;
            },
          );
          _savedQuest = Quest.initializeQuest(
            "",
            "",
            id: "",
            title: _savedQuest.title,
            launchedDate: DateTime.now(),
            deadline: pickedDate,
            initIdeaID: "",
          );
        }
      },
    );
  }

  void _saveForm() async {
    final bool isValid = _form.currentState.validate();
    if (!isValid || _dateTime == null) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<QuestsProvider>(context, listen: false).addQuest(
        _savedQuest,
        _savedIdea,
      );
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
        title: Text('Add a new Quest'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () => _saveForm(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Quest Title',
                      ),
                      style: Theme.of(context).textTheme.headline6,
                      focusNode: _questTitleFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Title can not be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _savedQuest = Quest.initializeQuest(
                          "",
                          "",
                          id: "",
                          title: value,
                          launchedDate: DateTime.now(),
                          deadline: _savedQuest.deadline,
                          initIdeaID: "",
                        );
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _dateTime == null
                              ? Text(
                                  ('No deadline choosen yet!'),
                                  style: Theme.of(context).textTheme.headline1,
                                )
                              : Text(
                                  'Deadline: ${DateFormat('dd/MM/yyyy').format(_dateTime)}',
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                        ),
                        FlatButton(
                          child: Text(
                            'Choose Date',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onPressed: () => _presentDatePicker(context),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Card(
                      elevation: 10,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Idea',
                              ),
                              style: Theme.of(context).textTheme.headline6,
                              focusNode: _ideaTitleFocusNode,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Title can not be empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _savedIdea = Idea.createInitialIdea(
                                  id: "",
                                  title: value,
                                  content: _savedIdea.content,
                                  published: DateTime.now(),
                                );
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_ideaDescriptionNode);
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Description',
                              ),
                              style: Theme.of(context).textTheme.headline6,
                              focusNode: _ideaDescriptionNode,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Description can not be empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _savedIdea = Idea.createInitialIdea(
                                  id: "",
                                  title: _savedIdea.title,
                                  content: value,
                                  published: DateTime.now(),
                                );
                              },
                              onFieldSubmitted: (_) => _saveForm(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RaisedButton(
                        child: Text(
                          'Add New Quest!',
                          style: Theme.of(context).textTheme.button,
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () => _saveForm(),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
