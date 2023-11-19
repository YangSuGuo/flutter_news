import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentWidget extends StatelessWidget {
  final Map<String, dynamic> comment;

  const CommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12.5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // 评论人
          Row(children: [
            Text(
              comment['author'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
                width: 43,
                height: 43,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.short_text_rounded,
                    size: 30,
                  ),
                  splashColor: Colors.transparent,
                ))
          ]),
          // 评论内容
          Text(
            comment['content'],
            textAlign: TextAlign.left,
            softWrap: true,
          ),
          // 回复
          if (comment['reply_to'] != null)
            Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    padding: const EdgeInsets.only(
                        top: 5, left: 5, right: 6, bottom: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(233, 233, 233, 0.4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: RichText(
                        softWrap: true,
                        text: TextSpan(
                            text: '${comment['reply_to']['author']}︰',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                  text: comment['reply_to']['content'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ))
                            ])))),
          Row(children: [
            // 评论时间
            Text(
              DateFormat('MM-dd  hh∶mm').format(
                DateTime.fromMillisecondsSinceEpoch(comment['time'] * 1000),
              ),
              style: const TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            // 点赞数量
            IconButton(
              icon: const Icon(Icons.thumb_up_off_alt, size: 20),
              splashColor: Colors.transparent,
              onPressed: () {},
            ),
            if (comment['likes'] != 0) Text(comment['likes'].toString()),
            const SizedBox(width: 10),
          ])
        ]));
  }
}
