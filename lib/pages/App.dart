import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class app extends StatefulWidget {
  const app({super.key});

  @override
  State<app> createState() => _appState();
}

class _appState extends State<app> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

/// Body
class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 45, left: 10, right: 10, bottom: 10),
        child: Column(
          children: [Header()],
        ));
  }

  Widget Header() {
    DateTime dateTime = DateTime.now();
    return Row(mainAxisSize: MainAxisSize.max, children: [
      Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              DateFormat('dd').format(dateTime),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(DateFormat('MM月').format(dateTime),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ])),
      const SizedBox(
        width: 1,
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.grey),
        ),
      ),
      const Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                '知乎日报',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ))),


    ]);
  }
}
