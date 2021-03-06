import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:gingersystem/providers/quests_provider.dart';
import 'package:gingersystem/screens/quest_overview_screen.dart';
import 'package:gingersystem/widgets/quest_overview_item.dart';
import 'package:provider/provider.dart';

class QuestOverviewList extends StatelessWidget {
  final FilteredOptions showByUpComingDeadline;

  QuestOverviewList(this.showByUpComingDeadline);

  @override
  Widget build(BuildContext context) {
    final QuestsProvider questManager = Provider.of<QuestsProvider>(context);
    final List<Quest> questToList =
        showByUpComingDeadline == FilteredOptions.UPCOMING
            ? questManager.upComingQuests
            : showByUpComingDeadline == FilteredOptions.FAVOURITES
                ? questManager.favouritedQuests
                : questManager.launchedQuests;

    return ListView.builder(
      itemCount: questToList.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: questToList[index],
          child: QuestOverviewItem(),
        );
      },
    );
  }
}
