import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracer_3/controllers/SubGoalDetailController.dart';
import 'package:tracer_3/models/dataModel.dart';
import 'package:tracer_3/views/detail_pages/subGoalDetail_page.dart';
import 'package:tracer_3/views/link_pages/KeyResultSubGoalLink_page.dart.dart';

class KeyResultDetailPage extends StatelessWidget {
  final int keyResultId;

  KeyResultDetailPage({Key? key, required this.keyResultId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 컨트롤러 인스턴스를 생성하고 종속성 주입을 수행합니다.
    final SubGoalDetailController subGoalDetailController =
        Get.put(SubGoalDetailController());

    // 비동기적으로 Sub_goals 리스트를 로드합니다.
    return FutureBuilder<void>(
      future: subGoalDetailController.loadSubGoalsFor(keyResultId),
      builder: (context, snapshot) {
        // 로드 중인 경우 로딩 인디케이터를 보여줍니다.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('KeyResults Details')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 데이터 로딩이 완료되면 UI를 구성합니다.
        return Scaffold(
          appBar: AppBar(title: Text('KeyResults Details')),
          body: Column(
            children: [
              // Sub_goal 리스트를 표시합니다.
              Expanded(
                child: Obx(() {
                  if (subGoalDetailController.subGoalsforList.isEmpty) {
                    return Center(child: Text('Sub-goals이 없습니다.'));
                  }
                  return ListView.builder(
                    itemCount: subGoalDetailController.subGoalsforList.length,
                    itemBuilder: (context, index) {
                      final subGoal =
                          subGoalDetailController.subGoalsforList[index];
                      return ListTile(
                        title: Text(subGoal.contents),
                        subtitle: Text('Progress: ${subGoal.progress}%'),
                        trailing: Text('가중치: ${subGoal.weight}'),
                        onTap: () {
                          Get.to(() => SubGoalDetailPage(
                              subGoalId: subGoal.id!)); //여기 액션버전으로
                        },
                      );
                    },
                  );
                }),
              ),
              // 새로운 Sub_goal을 추가할 수 있는 버튼입니다.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialogToAddSubGoal(
                          context, subGoalDetailController, keyResultId);
                    },
                    child: Text('Add Sub-goal'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // null 체크를 추가하였습니다.
                      Get.to(() => LinkSubGoalPage(
                            keyResultId: keyResultId,
                          ));
                    },
                    child: Text('Link Sub-goal'),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        );
      },
    );
  }

  // 사용자 입력을 받아 새로운 Sub_goal을 추가하는 다이얼로그를 표시하는 메소드입니다.
  void showDialogToAddSubGoal(BuildContext context,
      SubGoalDetailController controller, int keyResultId) {
    final TextEditingController contentController = TextEditingController();
    final TextEditingController weightController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('새로운 Sub-goal 추가'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: '내용'),
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: '가중치'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('취소'),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text('추가'),
            onPressed: () async {
              try {
                print("Adding SubGoal button pressed");
                final newSubGoal = Sub_goal(
                  contents: contentController.text,
                  weight: int.tryParse(weightController.text) ?? 0,
                );
                print(
                    "New SubGoal to be added: ${newSubGoal.contents}, Weight: ${newSubGoal.weight}");
                await controller.addSubGoal(newSubGoal, keyResultId);
                print("addSubGoal function called");
                Get.back(); // 다이얼로그를 닫습니다.
              } catch (e) {
                print("An error occurred: $e");
              }
            },
          ),
        ],
      ),
    );
  }
}
