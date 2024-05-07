import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracer_3/controllers/SubGoalDetailController.dart';
import 'package:tracer_3/views/delete_pages/subGoal_delete_page.dart';
import 'package:tracer_3/views/detail_pages/subGoalDetail_page.dart';

class SubGoalPage extends StatelessWidget {
  SubGoalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SubGoalDetailController controller =
        Get.put(SubGoalDetailController());

    // 페이지가 로드될 때 unlinkedSubGoals 리스트를 불러옵니다.
    controller.loadSubGoals();

    return Scaffold(
      appBar: AppBar(
        title: Text('your subGoals!'),
      ),
      body: Obx(() {
        if (controller.subGoalsList.isEmpty) {
          return Center(child: Text('sub-goal이 아직 없습니다'));
        }
        return ListView.builder(
          itemCount: controller.subGoalsList.length,
          itemBuilder: (context, index) {
            final subGoal = controller.subGoalsList[index];
            return ListTile(
              title: Text(subGoal.contents),
              trailing: IconButton(
                icon: Icon(Icons.delete_rounded),
                onPressed: () {
                  //삭제 or 연결된 keyresult or 연결된 actions
                  Get.to(() => SubGoalDeletePage()); //이거는 삭제페이지로
                },
              ),
              onTap: () {
                Get.to(() => SubGoalDetailPage(subGoalId: subGoal.id!));
              },
            );
          },
        );
      }),
    );
  }
}
