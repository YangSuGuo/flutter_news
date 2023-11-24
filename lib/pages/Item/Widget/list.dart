import 'package:flutter/material.dart';
import 'package:item_news/pages/Item/model/stories_model.dart';

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.item,
  }) : super(key: key);

  final StoriesData item;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                            child: Text(item.title ?? '',
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold))),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(item.hint ?? '',
                              softWrap: true,
                              maxLines: 3,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13.0)),
                        ))
                      ])))),
      if (item.image != null)
        Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 0.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0))),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/image/loading.gif',
              image: item.image ?? '',
              fit: BoxFit.cover,
              width: 80,
              height: 80,
            ))
    ]);
  }
}
