import 'package:get/get.dart';
import 'package:tracer_3/data/dataBase.dart';
import 'package:tracer_3/models/dataModel.dart';

class SubGoalActionController extends GetxController {
  var unlinkedActions = <Actionx>[].obs; // 연결되지 않은 액션들의 목록
  final DatabaseManager databaseManager = DatabaseManager();

  // 특정 서브골에 연결되지 않은 액션들을 로드합니다.
  Future<void> loadUnlinkedActions(int subGoalId) async {
    // 서브골에 이미 연결된 액션들을 가져옵니다.
    List<Map<String, dynamic>> linkedActionsMaps =
        await databaseManager.getActionsFor(subGoalId);
    List<Actionx> linkedActions =
        linkedActionsMaps.map((map) => Actionx.fromMap(map)).toList();

    // 모든 액션을 가져옵니다.
    List<Map<String, dynamic>> allActionsMaps =
        await databaseManager.getActions();
    List<Actionx> allActions =
        allActionsMaps.map((map) => Actionx.fromMap(map)).toList();

    // linkedActions의 ID만 추출하여 Set으로 변환합니다.
    var linkedIds = linkedActions.map((action) => action.id).toSet();

    // allActions에서 linkedActions의 ID를 포함하지 않는 액션들만 추려내어 unlinkedActions를 업데이트합니다.
    unlinkedActions.value =
        allActions.where((action) => !linkedIds.contains(action.id)).toList();
  }

  // 서브골과 액션을 연결합니다.
  Future<void> linkActionToSubGoal(
      int actionId, int subGoalId, int weight) async {
    await databaseManager.insertSubGoalAction(subGoalId, actionId, weight);
    // 성공적으로 연결 후 unlinkedActions 리스트를 갱신합니다.
    loadUnlinkedActions(subGoalId);
  }

  // 서브골과 연결된 액션을 삭제합니다.
  Future<void> unlinkActionFromSubGoal(int actionId, int subGoalId) async {
    await databaseManager.deleteSubGoalAction(subGoalId, actionId);
    // 성공적으로 연결 해제 후 unlinkedActions 리스트를 갱신합니다.
    loadUnlinkedActions(subGoalId);
  }
}
