import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/idea_provider.dart';
import 'package:gingersystem/screens/idea_overview_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:gingersystem/widgets/idea_overview_list.dart';
import 'package:gingersystem/providers/idea.dart';

class AddIdeaScreen extends StatefulWidget {
  static const routeName = '/add-idea';

  @override
  _AddIdeaScreenState createState() => _AddIdeaScreenState();
}

class _AddIdeaScreenState extends State<AddIdeaScreen> {
  final _ideaTitleFocusNode = FocusNode();
  final _ideaContentNode = FocusNode();
  final _ideaSDFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  List<File> allFiles;
  bool _isLoading = false;
  String idIdeaPadre;
  String idQuest;
  String _type;
  List<String> padresId = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, String> obj = ModalRoute.of(context).settings.arguments;
    idIdeaPadre = obj['idIdea'];
    idQuest = obj['idQuest'];
    _type = obj['type'];

    if (_type!="MIX")
      Provider.of<IdeasProvider>(context, listen: false)
        .addParent(idIdeaPadre);
  }

  void dispose() {
    _ideaTitleFocusNode.dispose();
    _ideaSDFocusNode.dispose();
    _ideaContentNode.dispose();
    super.dispose();
  }

  Idea _savedIdea = Idea.addIdea(
      id: '',
      title: '',
      content: '',
      owner: '',
      supportData: [],
      published: DateTime.now());

  Future<List<File>> _presentFilePicker(List<File> files) async {
    return await FilePicker.getMultiFile(type: FileType.any);
  }

  void _saveForm() async {
    final bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<IdeasProvider>(context, listen: false).addIdea(
          _savedIdea.title,
          _savedIdea.content,
          allFiles,
          idQuest,
          _type);
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
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new Idea'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () => _saveForm(),
          )
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
                    _type == "MIX"
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 100),
                            child: RaisedButton(
                              elevation: 8.0,
                              child: Text(
                                'Add Parents!',
                                style: Theme.of(context).textTheme.button,
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (_) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, left: 15, right: 15),
                                        height: deviceSize.height,
                                        child: IdeaOverviewList(
                                            null, idQuest, "todas", true),
                                      );
                                    });
                              },
                            ),
                          )
                        : Container(),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Idea Title'),
                      style: Theme.of(context).textTheme.headline6,
                      focusNode: _ideaTitleFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Title can not be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _savedIdea = Idea.addIdea(
                          id: '',
                          title: value,
                          content: '',
                          owner: '',
                          supportData: [],
                          published: DateTime.now(),
                        );
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Idea Content'),
                      style: Theme.of(context).textTheme.headline6,
                      focusNode: _ideaContentNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Content can not be empty';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _savedIdea = Idea.addIdea(
                          id: '',
                          title: _savedIdea.title,
                          content: value,
                          owner: '',
                          supportData: [],
                          published: DateTime.now(),
                        );
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    RaisedButton(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                            Text(
                              'Attach files',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        onPressed: () async {
                          List<File> files;
                          files = await _presentFilePicker(files);
                          setState(() {
                            allFiles = [...?files];
                          });
                          _savedIdea = Idea.addIdea(
                            id: '',
                            title: _savedIdea.title,
                            content: _savedIdea.content,
                            owner: '',
                            // supportData: files,
                            published: DateTime.now(),
                          );
                        }),
                    SizedBox(
                      height: 50,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RaisedButton(
                        child: Text(
                          'Add New Idea!',
                          style: Theme.of(context).textTheme.button,
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          _saveForm();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
