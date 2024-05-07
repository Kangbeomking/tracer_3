import 'package:get/get.dart';
import 'package:tracer_3/data/dataBase.dart';
import '../models/dataModel.dart';

class ActionxController extends GetxController {
  var actionList = <Actionx>[].obs;
  var selectedActions = <int>{}.obs;
  final DatabaseManager _databaseManager = DatabaseManager();

  @override
  void onInit() {
    super.onInit();
    loadActions();
  }

  // 데이터베이스로부터 모든 Actionx 객체를 로드
  void loadActions() async {
    final List<Map<String, dynamic>> actionMaps =
        await _databaseManager.getActions();

    // 데이터베이스에서 가져온 맵을 사용하여 Actionx 객체 리스트를 생성
    actionList.value = actionMaps.map((map) => Actionx.fromMap(map)).toList();
  }

  // 새로운 Actionx 객체를 데이터베이스에 삽입
  void addAction(Actionx action) async {
    await _databaseManager.insertAction(action);
    loadActions(); // 리스트를 다시 로드하여 갱신
  }

  // Actionx 객체의 진행 상태를 업데이트
  void updateActionProgress(int id, int progress) async {
    // 데이터베이스의 해당 Actionx 객체 진행 상태 업데이트 로직 추가 (데이터베이스 관리 클래스 수정 필요)
    // ...
    loadActions(); // 리스트를 다시 로드하여 갱신
  }

  void deleteSelectedActions() async {
    for (var actionId in selectedActions) {
      await _databaseManager.deleteAction(actionId);
    }
    selectedActions.clear(); // 선택된 액션 목록을 클리어
    loadActions(); // 리스트 갱신
    update(); // UI 갱신
  }
}
