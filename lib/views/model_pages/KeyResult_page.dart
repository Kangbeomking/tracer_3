import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracer_3/controllers/key_results_controller.dart';
import 'package:tracer_3/models/dataModel.dart';
import 'package:tracer_3/views/delete_pages/keyResult_delete_page.dart';
import 'package:tracer_3/views/detail_pages/keyResultDetail_page.dart';

class KeyResultPage extends StatelessWidget {
  KeyResultPage({Key? key}) : super(key: key);
  final KeyResultsController keyResultsController =
      Get.put(KeyResultsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Key Results'),
      ),
      body: Obx(() {
        if (keyResultsController.isLoading.isTrue) {
          // 로딩 인디케이터를 표시합니다.
          return Center(child: CircularProgressIndicator());
        } else if (keyResultsController.keyResultsList.isEmpty) {
          // 데이터가 비어 있을 때 메시지를 표시합니다.
          return Center(child: Text('키 결과가 없습니다.'));
        }
        // 데이터가 있는 경우, 리스트 뷰를 표시합니다.
        return ListView.builder(
          itemCount: keyResultsController.keyResultsList.length,
          itemBuilder: (context, index) {
            final keyResult = keyResultsController.keyResultsList[index];
            return ListTile(
              title: Text(keyResult.contents),
              onTap: () {
                Get.to(() => KeyResultDetailPage(keyResultId: keyResult.id!));
              },
              trailing: IconButton(
                icon: Icon(Icons.delete_rounded),
                onPressed: () {
                  //삭제 or 연결된 keyresult or 연결된 actions
                  Get.to(() => KeyResultDeletePage()); //이거는 삭제페이지로
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddKeyResultDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Add a new key result',
      ),
    );
  }

  Widget _buildWeightDisplay(int? weight) {
    return CircleAvatar(
      backgroundColor: Colors.blueAccent,
      child: Text(weight?.toString() ?? '0'),
    );
  }

  void _showAddKeyResultDialog(BuildContext context) {
    final TextEditingController contentController = TextEditingController();
    final TextEditingController weightController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('새로운 Key Result 추가'),
        content: SingleChildScrollView(
          child: Column(
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
        ),
        actions: [
          TextButton(
            child: Text('취소'),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text('추가'),
            onPressed: () {
              final newKeyResult = KeyResults(
                contents: contentController.text,
                weight: int.tryParse(weightController.text) ?? 0,
              );
              keyResultsController.addKeyResult(newKeyResult);
              Get.back(); // 다이얼로그를 닫습니다.
            },
          ),
        ],
      ),
    );
  }
}
