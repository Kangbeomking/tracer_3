import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracer_3/models/dataModel.dart';
import 'package:tracer_3/views/link_pages/SubGoal_ActionsLinkPage.dart';
import 'package:tracer_3/controllers/ActionDetailConotroller.dart';

class SubGoalDetailPage extends StatelessWidget {
  final int subGoalId;

  SubGoalDetailPage({Key? key, required this.subGoalId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 컨트롤러 인스턴스를 생성하고 종속성 주입을 수행합니다.
    final SubGoalActionController subGoalActionController =
        Get.put(SubGoalActionController());

    // 비동기적으로 Actions 리스트를 로드합니다.
    return FutureBuilder<void>(
      future: subGoalActionController.loadActionsForSubGoal(subGoalId),
      builder: (context, snapshot) {
        // 로드 중인 경우 로딩 인디케이터를 보여줍니다.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('SubGoal Details')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 데이터 로딩이 완료되면 UI를 구성합니다.
        return Scaffold(
          appBar: AppBar(title: Text('SubGoal Details')),
          body: Column(
            children: [
              // Action 리스트를 표시합니다.
              Expanded(
                child: Obx(() {
                  if (subGoalActionController.actionsForSubGoal.isEmpty) {
                    return Center(child: Text('Actions이 없습니다.'));
                  }
                  return ListView.builder(
                    itemCount: subGoalActionController.actionsForSubGoal.length,
                    itemBuilder: (context, index) {
                      final action =
                          subGoalActionController.actionsForSubGoal[index];
                      return ListTile(
                        title: Text(action.contents),
                        subtitle: Text('Progress: ${action.progress}%'),
                        trailing: Text('가중치: ${action.weight}'),
                        onTap: () {
                          Get.to(() => SubGoalDetailPage(
                              subGoalId: action.id!)); //여기 액션버전으로
                        },
                      );
                    },
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialogToAddAction(
                          context, subGoalActionController, subGoalId);
                    },
                    child: Text('Add Action'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => LinkActionPage(
                            subGoalId: subGoalId,
                          ));
                    },
                    child: Text('Link Action'),
                  ),
                ],
              ),
              // 새로운 Action을 추가할 수 있는 버튼입니다.

              SizedBox(
                height: 40,
              ),
            ],
          ),
        );
      },
    );
  }

  // 사용자 입력을 받아 새로운 Action을 추가하는 다이얼로그를 표시하는 메소드입니다.
  void showDialogToAddAction(
      BuildContext context, SubGoalActionController controller, int subGoalId) {
    final TextEditingController contentController = TextEditingController();
    final TextEditingController weightController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('새로운 Action 추가'),
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
              final newAction = Actionx(
                contents: contentController.text,
                weight: int.tryParse(weightController.text) ?? 0,
              );
              await controller.addActionToSubGoal(newAction, subGoalId);
              Get.back(); // 다이얼로그를 닫습니다.
            },
          ),
        ],
      ),
    );
  }
}
