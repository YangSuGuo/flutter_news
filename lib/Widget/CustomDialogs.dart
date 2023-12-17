import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialogs {
  static void confirmationDialog({
      required BuildContext context,
      required String title,
      String? content,
      bool? cancel,
      required bool confirm,
      required bool buttonMinWidth,
      required VoidCallback onConfirm}) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Center(child: Text(title)),
                content: content != null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(content)])
                    : null,
                elevation: 0,
                titlePadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
                contentPadding:
                    const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                actions: [
                  ButtonBar(
                      buttonMinWidth: buttonMinWidth
                          ? Get.width / 3
                          : Get.width,
                      alignment: MainAxisAlignment.center,
                      children: [
                        if (cancel!)
                          MaterialButton(
                              color: Get.isDarkMode
                                  ? Colors.black12
                                  : Colors.grey.shade100,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              elevation: 0,
                              onPressed: () => Get.back(),
                              child: const Text(
                                '取消',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )),
                        if (confirm)
                          MaterialButton(
                              color: Get.isDarkMode
                                  ? Colors.black12
                                  : Colors.lightBlue.shade50,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              elevation: 0,
                              onPressed: onConfirm,
                              child: Text(
                                '确定',
                                style: TextStyle(
                                    color: Colors.deepOrange.shade500,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ))
                      ])
                ]));
  }
}
