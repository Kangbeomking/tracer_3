import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracer_3/controllers/actionx_controller.dart';

class ActionDeletePage extends StatelessWidget {
  final ActionxController controller = Get.put(ActionxController());

  ActionDeletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 페이지가 로드될 때 모든 액션을 불러옵니다.
    controller.loadActions();

    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Actions'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // 사용자가 선택한 액션을 삭제합니다.
              controller.deleteSelectedActions();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.actionList.isEmpty) {
          return Center(child: Text('There are no actions to delete.'));
        }
        return ListView.builder(
          itemCount: controller.actionList.length,
          itemBuilder: (context, index) {
            final action = controller.actionList[index];
            return ListTile(
              title: Text(action.contents),
              leading: Obx(() => Checkbox(
                    value: controller.selectedActions.contains(action.id),
                    onChanged: (bool? value) {
                      if (value == true) {
                        controller.selectedActions.add(action.id!);
                      } else {
                        controller.selectedActions.remove(action.id);
                      }
                      // Force the UI to update
                      controller.update();
                    },
                  )),
              onTap: () {
                final isCurrentlySelected =
                    controller.selectedActions.contains(action.id);
                if (isCurrentlySelected) {
                  controller.selectedActions.remove(action.id);
                } else {
                  controller.selectedActions.add(action.id!);
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
