import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewSimpleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: PhotoView(
                imageProvider: NetworkImage(Get.arguments['src'].toString()),
                minScale: 0.5,
                maxScale: 1.5,
              ),
            ),
            // 功能区
            Positioned(
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 50,
              child: Row(children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close),
                        SizedBox(width: 5),
                        Text('返回', style: TextStyle())
                      ]),
                  onPressed: () => Get.back(),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
