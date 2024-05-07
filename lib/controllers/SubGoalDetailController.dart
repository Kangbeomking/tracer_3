import 'package:get/get.dart';
import 'package:tracer_3/data/dataBase.dart';
import 'package:tracer_3/models/dataModel.dart';

class SubGoalDetailController extends GetxController {
  var subGoalsforList = <Sub_goal>[].obs;
  var subGoalsList = <Sub_goal>[].obs;
  var selectedSubGoals = <int>{}.obs;
  final DatabaseManager databaseManager = DatabaseManager();

  Future<void> loadSubGoalsFor(int keyResultId) async {
    print("Loading SubGoals for KeyResult ID: $keyResultId");
    final List<Map<String, dynamic>> subGoalsfor =
        await databaseManager.getSubGoalsFor(keyResultId);
    subGoalsforList.value =
        subGoalsfor.map((map) => Sub_goal.fromMap(map)).toList();
    print("SubGoals loaded: ${subGoalsforList.length}");
  }

  Future<void> loadSubGoals() async {
    final List<Map<String, dynamic>> subGoals =
        await databaseManager.getSubGoals();
    subGoalsList.value = subGoals.map((map) => Sub_goal.fromMap(map)).toList();
  }

  Future<void> addSubGoal(Sub_goal sub_goal, int keyResultId) async {
    print("Adding subGoal with contents: ${sub_goal.contents}");
    await databaseManager.insertSubGoal(sub_goal);
    await loadSubGoals(); // 리스트가 업데이트될 때까지 기다립니다.

    print("Loaded subGoals count: ${subGoalsList.length}");

    if (subGoalsList.isNotEmpty) {
      var sub_goalId = subGoalsList.last.id;
      var sub_goalWeight = subGoalsList.last.weight;
      print("Last subGoal ID: $sub_goalId, Weight: $sub_goalWeight");

      if (sub_goalId != null && sub_goalWeight != null) {
        print("Inserting into KeyResult_SubGoal");
        await databaseManager.insertKeyResultSubGoal(
            keyResultId, sub_goalId, sub_goalWeight);
      } else {
        print("SubGoal ID or weight is null");
      }
    } else {
      print("SubGoals list is empty");
    }

    // 서브골을 삭제하는 메서드

    loadSubGoalsFor(keyResultId);
  }

  Future<void> deleteSubGoal(int subGoalId) async {
    final db = await databaseManager.database;
    // 트랜잭션 시작
    await db.transaction((txn) async {
      // 서브골과 연결된 KeyResult_SubGoal 데이터를 삭제
      await txn.delete('KeyResult_SubGoal',
          where: 'subGoalId = ?', whereArgs: [subGoalId]);

      // 서브골과 연결된 SubGoal_Action 데이터를 삭제
      await txn.delete('SubGoal_Actions',
          where: 'subGoalId = ?', whereArgs: [subGoalId]);

      // 마지막으로 서브골 자체를 삭제
      await txn.delete('Sub_goals', where: 'id = ?', whereArgs: [subGoalId]);
    });

    // 상태를 업데이트하여 UI에 반영
    loadSubGoals();
    update();
  }

  // 선택된 서브골을 삭제하는 메서드
  Future<void> deleteSelectedSubGoals() async {
    for (var subGoalId in selectedSubGoals) {
      await deleteSubGoal(subGoalId);
    }
    // 선택된 서브골 목록을 클리어
    selectedSubGoals.clear();
  }
}
