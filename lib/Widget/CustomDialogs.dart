import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialogs {
  static void confirmationDialog({
    required String title,
    required BuildContext context,
    String? content,
    required VoidCallback onConfirm,
    bool? onCancel,
  }) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(title),
              content: content != null ? Text(content) : null,
              actions: [
                if (onCancel!)
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: onConfirm,
                    child: const Text('确定'),
                  )
              ],
            ));
  }
}
