import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../http/net.dart';
import '../Comments/comments.dart';
import 'Widget/_itemIconButton.dart';

// bug 在无网络的情况下，会持续进行加载页面，中间打开网络并不会更新状态，需要持续接口请求
// todo 去除文章页面的打开app广告
// todo 点击刷新按钮时，旋转动画

class essay extends StatefulWidget {
  @override
  State<essay> createState() => _essayState();
}

class _essayState extends State<essay> {
  Map<String, dynamic> items = {}; // 文章正文
  Map<String, dynamic> comments = {}; // 评论信息
  int id = 9766161; // 初始值 id

  final urlController = TextEditingController();
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  late PullToRefreshController pullToRefreshController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    super.initState();
    // 初始化数据
    // todo 需要加载动画！！ok
    print("获取传值:${Get.arguments["id"]}");
    id = Get.arguments["id"];
    // _getBody(id);
    _getComments(id);

    // 下拉刷新操作
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.black,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  // 获取文章额外信息【评论，点赞】
  Future<void> _getComments(int id) async {
    try {
      final response =
          await DioUtils.instance.dio.get(HttpApi.zhihu_comments_info + '$id');
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        setState(() {
          comments = data;
        });

        print('获取评论数据成功');
      } else {
        throw Exception('获取评论数据失败');
      }
    } catch (e) {
      throw Exception('错误：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: comments.isEmpty ? const GFLoader() : _buildBody());
  }

  Widget _buildBody() {
    return Column(children: [
      Expanded(
          child: Padding(
        padding: const EdgeInsets.only(top: 35),
        child:
            // 用于添加集成到 flutter widget 树中的内联原生 WebView
            // 应该是解析转换为widget
            InAppWebView(
          key: webViewKey,
          initialUrlRequest:
              URLRequest(url: Uri.parse("https://daily.zhihu.com/story/$id")),
          initialOptions: options,
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStop: (controller, url) async {
            pullToRefreshController.endRefreshing();
          },
          onLoadError: (controller, url, code, message) {
            pullToRefreshController.endRefreshing();
          },
        ),
      )),
      operate()
    ]);
  }

  /// 操作列表
  Widget operate() {
    return Container(
        height: 50,
        color: Get.isDarkMode ? Colors.black12 : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 4),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios),
                )),
            const SizedBox(
              width: 1,
              height: 30,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 评论
                  itemIconButton(
                    icon: Icons.messenger_outline,
                    onPressed: () {
                      if (comments['comments'] != 0) {
                        Get.to(comments_page(),
                            arguments: {'id': id, 'comments': comments});
                      }
                    },
                    data: comments['comments'].toString(),
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.star_border_rounded,
                        size: 28,
                      ),
                      onPressed: () => Get.back()),
                  IconButton(
                    icon: const Icon(Icons.loop),
                    onPressed: () {
                      webViewController?.reload();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
