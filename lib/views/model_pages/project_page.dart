import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracer_3/views/model_pages/KeyResult_page.dart';
import 'package:tracer_3/views/model_pages/actions_page.dart';
import 'package:tracer_3/views/model_pages/subGoal_page.dart';

class ProjectPage extends StatelessWidget {
  ProjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 컨트롤러 인스턴스를 생성하고 종속성 주입을 수행합니다.
    // 데이터 로딩이 완료되면 UI를 구성합니다.
    return Scaffold(
      appBar: AppBar(title: Text('KeyResults Details')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // null 체크를 추가하였습니다.
                  Get.to(() => KeyResultPage());
                },
                child: Text('KeyResults'),
              ),
              ElevatedButton(
                onPressed: () {
                  // null 체크를 추가하였습니다.
                  Get.to(() => SubGoalPage());
                },
                child: Text('SubGoals'),
              ),
              ElevatedButton(
                onPressed: () {
                  // null 체크를 추가하였습니다.
                  Get.to(() => ActionPage());
                },
                child: Text('Actions'),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
