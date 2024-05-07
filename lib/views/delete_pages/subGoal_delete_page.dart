import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracer_3/controllers/SubGoalDetailController.dart';

class SubGoalDeletePage extends StatelessWidget {
  final SubGoalDetailController controller = Get.put(SubGoalDetailController());

  SubGoalDeletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 페이지가 로드될 때 모든 서브골 리스트를 불러옵니다.
    controller.loadSubGoals();

    return Scaffold(
      appBar: AppBar(
        title: Text('Delete SubGoals'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // 사용자가 선택한 서브골을 삭제합니다.
              controller.deleteSelectedSubGoals();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.subGoalsList.isEmpty) {
          return Center(child: Text('There are no sub-goals to delete.'));
        }
        return ListView.builder(
          itemCount: controller.subGoalsList.length,
          itemBuilder: (context, index) {
            final subGoal = controller.subGoalsList[index];
            return ListTile(
              title: Text(subGoal.contents),
              leading: Obx(() => Checkbox(
                    value: controller.selectedSubGoals.contains(subGoal.id),
                    onChanged: (bool? value) {
                      if (value == true) {
                        controller.selectedSubGoals.add(subGoal.id!);
                      } else {
                        controller.selectedSubGoals.remove(subGoal.id);
                      }
                      // Force the UI to update
                      controller.update();
                    },
                  )),
              onTap: () {
                final isCurrentlySelected =
                    controller.selectedSubGoals.contains(subGoal.id);
                if (isCurrentlySelected) {
                  controller.selectedSubGoals.remove(subGoal.id);
                } else {
                  controller.selectedSubGoals.add(subGoal.id!);
                }
                // Force the UI to update
                controller.update();
              },
            );
          },
        );
      }),
    );
  }
}
