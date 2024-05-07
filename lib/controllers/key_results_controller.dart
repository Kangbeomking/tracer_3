import 'package:get/get.dart';
import '../models/dataModel.dart';
import '../data/database.dart';

class KeyResultsController extends GetxController {
  var isLoading = true.obs; // 로딩 상태를 추가
  var keyResultsList = <KeyResults>[].obs;
  var selectedKeyResults = <int>{}.obs;
  final DatabaseManager _databaseManager = DatabaseManager();

  @override
  void onInit() {
    super.onInit();
    loadKeyResults();
  }

  // 데이터베이스로부터 모든 KeyResults 객체를 로드
  void loadKeyResults() async {
    isLoading(true); // 데이터 로딩 시작
    try {
      final List<Map<String, dynamic>> keyResultsMaps =
          await _databaseManager.getKeyResults();

      // 데이터베이스에서 가져온 맵을 사용하여 KeyResults 객체 리스트를 생성
      keyResultsList.value =
          keyResultsMaps.map((map) => KeyResults.fromMap(map)).toList();
    } finally {
      isLoading(false); // 데이터 로딩 종료
    }
  }

  // 새로운 KeyResults 객체를 데이터베이스에 삽입하고 리스트를 업데이트
  void addKeyResult(KeyResults keyResult) async {
    await _databaseManager.insertKeyResult(keyResult);
    loadKeyResults(); // 리스트를 다시 로드하여 갱신
  }

  void deleteSelectedKeyResults() async {
    for (var keyResultId in selectedKeyResults) {
      await _databaseManager.deleteKeyResult(keyResultId);
      await _databaseManager.deleteKeyResultSubGoalWithKeyResult(keyResultId);
    }
    selectedKeyResults.clear(); // 선택된 키 리절트 목록을 클리어
    loadKeyResults(); // 리스트 갱신
    update(); // UI 갱신
  }
}
