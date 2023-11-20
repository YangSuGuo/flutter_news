import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Essay/essay.dart';

class starsitem extends StatelessWidget {
  const starsitem({
    super.key,
    required this.item,
  });

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Get.to(() => essay(), arguments: {
              'id': item['starsID'],
              'title': item['title'],
              'link': item['link'],
              'description': item['description'],
              'images': item['images']
            }),
        /*onLongPress: () {
          CustomDialogs.confirmationDialog(
              title: '是否删除？',
              content: '从数据库中删除，此操作不可逆❗',
              context: context,
              onCancel: true,
              onConfirm: () {
                // todo 实现从列表中删除 or 重新加载
                final StarsData star = StarsData();
                star.starsID = item['starsID'];
                DB.db.deleteStars(star);
              });
        },*/
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: SizedBox(
                  height: 108,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 2, left: 3, right: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // 主要文本
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 5),
                                child: Text(item['title'],
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold))),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(item['description'],
                                  softWrap: true,
                                  maxLines: 3,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 13.0)),
                            ))
                          ])))),
          if (item['image'].isNotEmpty)
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 0.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0))),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/image/loading.gif',
                image: item['image'],
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              ),
            )
        ]));
  }
}
