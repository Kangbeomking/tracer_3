import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracer_3/controllers/key_results_controller.dart';

class KeyResultDeletePage extends StatelessWidget {
  final KeyResultsController controller = Get.put(KeyResultsController());

  KeyResultDeletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 페이지가 로드될 때 모든 키 리절트를 불러옵니다.

    return Scaffold(
      appBar: AppBar(
        title: Text('Delete KeyResults'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // 사용자가 선택한 키 리절트를 삭제합니다.
              controller.deleteSelectedKeyResults();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading()) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.keyResultsList.isEmpty) {
          return Center(child: Text('There are no key results to delete.'));
        }
        return ListView.builder(
          itemCount: controller.keyResultsList.length,
          itemBuilder: (context, index) {
            final keyResult = controller.keyResultsList[index];
            return ListTile(
              title: Text(keyResult.contents),
              leading: Obx(() => Checkbox(
                    value: controller.selectedKeyResults.contains(keyResult.id),
                    onChanged: (bool? value) {
                      if (value == true) {
                        controller.selectedKeyResults.add(keyResult.id!);
                      } else {
                        controller.selectedKeyResults.remove(keyResult.id);
                      }
                      // Force the UI to update
                      controller.update();
                    },
                  )),
              onTap: () {
                final isCurrentlySelected =
                    controller.selectedKeyResults.contains(keyResult.id);
                if (isCurrentlySelected) {
                  controller.selectedKeyResults.remove(keyResult.id);
                } else {
                  controller.selectedKeyResults.add(keyResult.id!);
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
