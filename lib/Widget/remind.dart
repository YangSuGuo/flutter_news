import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemindWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '(¬‿¬)',
            style: TextStyle(
                color: Colors.grey, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '没有数据哦',
            style: TextStyle(
                color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: Get.height / 3,
          )
        ],
      ),
    );
  }
}
