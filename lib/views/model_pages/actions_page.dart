import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracer_3/controllers/actionx_controller.dart';
import 'package:tracer_3/views/delete_pages/action_delete_page.dart';

class ActionPage extends StatelessWidget {
  ActionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ActionxController controller = Get.put(ActionxController());

    // 페이지가 로드될 때 unlinkedSubGoals 리스트를 불러옵니다.
    controller.loadActions();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'your Actions!',
        ),
      ),
      body: Obx(() {
        if (controller.actionList.isEmpty) {
          return Center(child: Text('action이 없습니다.'));
        }
        return ListView.builder(
          itemCount: controller.actionList.length,
          itemBuilder: (context, index) {
            final subGoal = controller.actionList[index];
            return ListTile(
              title: Text(subGoal.contents),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Get.to(() => ActionDeletePage());
                  //삭제 or 연결된 keyresult or 연결된 actions
                },
              ),
            );
          },
        );
      }),
    );
  }
}
