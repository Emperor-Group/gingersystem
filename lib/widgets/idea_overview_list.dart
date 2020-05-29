import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:provider/provider.dart';
import 'package:gingersystem/providers/idea_provider.dart';

class IdeaOverviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IdeasProvider ideaManager = Provider.of<IdeasProvider>(context);
    final List<Idea> questToList = ideaManager.launchedIdeas;
    return Container();
  }
}
