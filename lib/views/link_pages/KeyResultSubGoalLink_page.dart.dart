//subgoal 리스트를 확인하고, 해당 keyresult와 연결되지 않은 subgoal을 표시하는 list가 나와야함,
//그리고 list에서 각 subgoal을 선택, weight를 추가해서 subgoalkeyresult에 삽입
//weight는 기존의 subgoal의 weight가 아닌 연결에서의 weight를 따로 처리해야함 keyresult와 subgoal의 조합마다 다른 weight가 있어야 한다는 말
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracer_3/controllers/KeyResultSubGoalLinkController.dart';
import 'package:tracer_3/models/dataModel.dart';

class LinkSubGoalPage extends StatelessWidget {
  final int keyResultId;
  LinkSubGoalPage({Key? key, required this.keyResultId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final KeyResultSubGoalController controller =
        Get.put(KeyResultSubGoalController());

    // 페이지가 로드될 때 unlinkedSubGoals 리스트를 불러옵니다.
    controller.loadUnlinkedSubGoals(keyResultId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Link SubGoal to KeyResult'),
      ),
      body: Obx(() {
        if (controller.unlinkedSubGoals.isEmpty) {
          return Center(child: Text('모든 Sub-goals가 이미 연결되었습니다.'));
        }
        return ListView.builder(
          itemCount: controller.unlinkedSubGoals.length,
          itemBuilder: (context, index) {
            final subGoal = controller.unlinkedSubGoals[index];
            return ListTile(
              title: Text(subGoal.contents),
              trailing: IconButton(
                icon: Icon(Icons.link),
                onPressed: () {
                  _showWeightDialog(context, subGoal, keyResultId, controller);
                },
              ),
            );
          },
        );
      }),
    );
  }

  // 사용자가 weight를 입력하고 SubGoal을 KeyResult에 연결할 수 있는 다이얼로그를 보여줍니다.
  void _showWeightDialog(BuildContext context, Sub_goal subGoal,
      int keyResultId, KeyResultSubGoalController controller) {
    final TextEditingController weightController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Set Weight for Linking'),
        content: TextField(
          controller: weightController,
          decoration: InputDecoration(
            labelText: 'Weight',
            hintText: 'Enter weight for this link',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text('Link'),
            onPressed: () async {
              final weight = int.tryParse(weightController.text) ?? 0;
              await controller.linkSubGoalToKeyResult(
                  subGoal.id!, keyResultId, weight);
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
