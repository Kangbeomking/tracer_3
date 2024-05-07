import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/actionx_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  // GetX 컨트롤러 인스턴스를 가져옵니다.
  final ActionxController actionxController = Get.put(ActionxController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Action To Do')),
      body: Obx(() {
        if (actionxController.actionList.isEmpty) {
          // 데이터가 없을 경우 표시할 위젯
          return Center(child: Text('데이터가 없습니다.'));
        }
        return ListView.builder(
          itemCount: actionxController.actionList.length,
          itemBuilder: (context, index) {
            final action = actionxController.actionList[index];
            return ListTile(
              title: Text(action.contents),
              subtitle: Text('Progress: ${action.progress}%'),
              trailing: _buildWeightDisplay(action.weight),
            );
          },
        );
      }),
    );
  }

  // 가중치(weight)를 표시하기 위한 위젯을 생성합니다.
  Widget _buildWeightDisplay(int? weight) {
    return CircleAvatar(
      backgroundColor: Colors.blue,
      child: Text(weight?.toString() ?? '0'),
    );
  }
}
