import 'package:flutter/material.dart';
import 'package:gingersystem/providers/idea.dart';
import 'package:gingersystem/providers/quest.dart';
import 'package:gingersystem/providers/quests_provider.dart';
import 'package:provider/provider.dart';
import 'package:gingersystem/providers/idea_provider.dart';
import 'package:gingersystem/widgets/idea_overview_item.dart';

class IdeaOverviewList extends StatefulWidget {
  Idea ideaActual;
  String idQuest;
  String padresOHijasOTodas;
  bool onlyShow;

  IdeaOverviewList(
      this.ideaActual, this.idQuest, this.padresOHijasOTodas, this.onlyShow);

  @override
  _IdeaOverviewListState createState() => _IdeaOverviewListState(onlyShow);
}

class _IdeaOverviewListState extends State<IdeaOverviewList> {
  Idea ideaActual;
  String idQuest;
  String padresOHijasOTodas;
  bool _isInit = false;
  bool _isLoading = false;
  List<Idea> listas;
  Quest selectedQuest;
  bool onlyShow;

  _IdeaOverviewListState(this.onlyShow);

  @override
  void initState() {
    super.initState();
    idQuest = widget.idQuest;
    ideaActual = widget.ideaActual;
    padresOHijasOTodas = widget.padresOHijasOTodas;
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
        },
      );
      if (padresOHijasOTodas == 'todas') {
        selectedQuest = Provider.of<QuestsProvider>(context).getByID(idQuest);
        selectedQuest.setInitialIdea().then((_) {
          setState(() {
            _isLoading = false;
            listas = selectedQuest.ideasToDisplay;
          });
        });
      } else {
        IdeasProvider ideaManager =
            Provider.of<IdeasProvider>(context, listen: true);
        ideaManager
            .fetchAndSetLaunchedIdeasChildren(
                idQuest, ideaActual.id, padresOHijasOTodas)
            .then((_) {
          setState(() {
            _isLoading = false;
            listas = ideaManager.ideasparentsOchildren;
          });
        });
      }
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : listas.isNotEmpty
            ? ListView.builder(
                itemCount: listas.length,
                itemBuilder: (ctx, index) {
                  return ChangeNotifierProvider.value(
                    value: listas[index],
                    child: IdeaOverviewItem(
                      idQuest,
                      onlyShow,
                    ),
                  );
                },
              )
            : Container(
                child: Text('NO HAY IDEAS EN ESTE GRUPO.'),
              );
  }
}
//Widget vistaLista(){
//  if(selectedQuest!=null && ideaActual!=null && padresOHijasOTodas!=null){
//    ideaManager
//        .fetchAndSetLaunchedIdeasChildren(
//        idQuest, ideaActual.id, padresOHijasOTodas)
//        .then((_) {
//      setState(() {
//        listas = ideaManager.ideasparentsOchildren;
//      });
//    });
//  }
//  return ListView.builder(
//    itemCount: listas.length,
//    itemBuilder: (ctx, index) {
//      return ChangeNotifierProvider.value(
//        value: listas[index],
//        child: IdeaOverviewItem(
//          idQuest,
//          onlyShow,
//        ),
//      );
//    },
//  );
//}