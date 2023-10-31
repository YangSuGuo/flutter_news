import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:item_news/pages/Widget/item.dart';

class app extends StatefulWidget {
  const app({super.key});

  @override
  State<app> createState() => _appState();
}

class _appState extends State<app> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Body());
  }

  /// Body
  Widget Body() {
    return Stack(
      children: [
        Padding(padding: const EdgeInsets.only(top: 95), child: item()),
        Header()
      ],
    );
  }

  /// 标题栏
  Widget Header() {
    DateTime dateTime = DateTime.now();
    // String img = 'assets/image/ColinNeumannJr.png';
    return Container(
        margin: const EdgeInsets.only(top: 45, left: 10, right: 10, bottom: 10),
        height: 50,
        child: Row(children: [
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd').format(dateTime),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(DateFormat('MM月').format(dateTime),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ])),
          const SizedBox(
            width: 1,
            height: 40,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.grey),
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                '知乎日报',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              )),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                print('设置');
              },
              icon: const Icon(Icons.settings, size: 26),
              tooltip: '设置',
              splashColor: Colors.transparent,
            ),
          )
        ]));
  }
}
