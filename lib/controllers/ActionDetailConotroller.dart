import 'package:get/get.dart';
import 'package:tracer_3/data/dataBase.dart';
import 'package:tracer_3/models/dataModel.dart';

class SubGoalActionController extends GetxController {
  var actionsForSubGoal = <Actionx>[].obs; // 특정 서브골에 연결된 액션들
  var allActions = <Actionx>[].obs; // 모든 액션들
  final DatabaseManager databaseManager = DatabaseManager();

  // 특정 서브골에 연결된 액션들을 로드합니다.
  Future<void> loadActionsForSubGoal(int subGoalId) async {
    print("Loading Actions for SubGoal ID: $subGoalId");
    final List<Map<String, dynamic>> actionsFor =
        await databaseManager.getActionsFor(subGoalId);
    actionsForSubGoal.value =
        actionsFor.map((map) => Actionx.fromMap(map)).toList();
    print("Actions loaded for the SubGoal: ${actionsForSubGoal.length}");
  }

  // 모든 액션들을 로드합니다.
  Future<void> loadAllActions() async {
    final List<Map<String, dynamic>> actions =
        await databaseManager.getActions();
    allActions.value = actions.map((map) => Actionx.fromMap(map)).toList();
  }

  // 서브골에 새로운 액션을 연결합니다.
  Future<void> addActionToSubGoal(Actionx action, int subGoalId) async {
    print("Adding Action with contents: ${action.contents}");
    await databaseManager.insertAction(action);
    await loadAllActions(); // 리스트가 업데이트될 때까지 기다립니다.

    print("Loaded Actions count: ${allActions.length}");

    if (allActions.isNotEmpty) {
      var actionId = allActions.last.id;
      var actionWeight = allActions.last.weight;
      print("Last Action ID: $actionId, Weight: $actionWeight");

      if (actionId != null && actionWeight != null) {
        print("Inserting into SubGoal_Action");
        await databaseManager.insertSubGoalAction(
            subGoalId, actionId, actionWeight);
      } else {
        print("Action ID or weight is null");
      }
    } else {
      print("Actions list is empty");
    }

    loadActionsForSubGoal(subGoalId); // 갱신된 리스트를 다시 로드합니다.
  }
}
