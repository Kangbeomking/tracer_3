import 'package:get/get.dart';
import 'package:tracer_3/data/dataBase.dart';
import 'package:tracer_3/models/dataModel.dart';

class KeyResultSubGoalController extends GetxController {
  var unlinkedSubGoals = <Sub_goal>[].obs;
  final DatabaseManager databaseManager = DatabaseManager();

  // 모든 SubGoal 중에서 KeyResult에 연결되지 않은 SubGoal을 찾아서 리스트를 갱신합니다.
  void loadUnlinkedSubGoals(int keyResultId) async {
    // 기존에 연결된 SubGoals을 가져옵니다.
    List<Map<String, dynamic>> linkedSubGoalsMaps =
        await databaseManager.getSubGoalsFor(keyResultId);
    List<Sub_goal> linkedSubGoals =
        linkedSubGoalsMaps.map((map) => Sub_goal.fromMap(map)).toList();

    // 모든 SubGoals을 가져옵니다.
    List<Map<String, dynamic>> allSubGoalsMaps =
        await databaseManager.getSubGoals();
    List<Sub_goal> allSubGoals =
        allSubGoalsMaps.map((map) => Sub_goal.fromMap(map)).toList();

    // linkedSubGoals의 ID만 추출하여 Set으로 변환합니다.
    var linkedIds = linkedSubGoals.map((sg) => sg.id).toSet();

    // allSubGoals에서 linkedSubGoals의 ID를 포함하지 않는 것들만 추려내어 unlinkedSubGoals를 업데이트합니다.
    unlinkedSubGoals.value =
        allSubGoals.where((sg) => !linkedIds.contains(sg.id)).toList();
  }

  // KeyResult와 SubGoal을 연결합니다.
  Future<void> linkSubGoalToKeyResult(
      int subGoalId, int keyResultId, int weight) async {
    await databaseManager.insertKeyResultSubGoal(
        keyResultId, subGoalId, weight);
    // 성공적으로 연결 후 unlinkedSubGoals 리스트를 갱신합니다.
    loadUnlinkedSubGoals(keyResultId);
  }

  Future<void> deleteSubGoal(int subGoalId) async {
    // 트랜잭션 시작
    await databaseManager.deleteSubGoal(subGoalId);
    // 해당 서브골과 연결된 모든 데이터를 KeyResult_SubGoal 테이블에서 삭제
    await databaseManager.deleteKeyResultSubGoalWithSubGoal(subGoalId);
    // 상태 업데이트
    update();
  }
}
