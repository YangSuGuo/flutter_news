import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:share_plus/share_plus.dart';

import '../../db/db.dart';
import '../../http/net.dart';
import '../../models/stars.dart';
import '../Comments/comments.dart';
import 'Widget/_itemIconButton.dart';

// bug 在无网络的情况下，会持续进行加载页面，中间打开网络并不会更新状态，需要持续接口请求
// todo 分离操作列表

class essay extends StatefulWidget {
  @override
  State<essay> createState() => _essayState();
}

class _essayState extends State<essay> with SingleTickerProviderStateMixin {
  /// 文章
  Map<String, dynamic> comments = {}; // 评论信息
  int id = 9766161; // 初始值 id
  bool stars = false; // 收藏状态

  /// 旋转动画
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: const Duration(seconds: 1));

  /// 浏览器
  /// todo 添加加载图，增加用户体验，优化用户使用，避免闪屏！！！！！！超级重要
  /// js更改属性 data-theme="dark" 即为夜间模式（<html class="itcauecng" data-theme="dark">）,
  /// bug BLUETOOTH_CONNECT permission is missing
  /// bug setForceDark() is a no-op in an app with targetSdkVersion>=T
  /// bug Application attempted to call on a destroyed WebView【webview 版本 111.0.5563.116（556311633）】
  final urlController = TextEditingController();
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  late PullToRefreshController pullToRefreshController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        // 自动播放媒体
        mediaPlaybackRequiresUserGesture: false,
        // js
        javaScriptEnabled: true,
        // 垂直滚动
        verticalScrollBarEnabled: false,
        // 背景透明
        transparentBackground: true,
        // 清缓存
        clearCache: true,
        // 去广告
        // 根据 CSS选择器 ,设置display：none 【CSS_DISPLAY_NONE】
        /// **NOTE**: on Android, JavaScript must be enabled!!!
        contentBlockers: [
          ContentBlocker(
              trigger: ContentBlockerTrigger(urlFilter: ".*"),
              action: ContentBlockerAction(
                  type: ContentBlockerActionType.CSS_DISPLAY_NONE,
                  selector: '.Daily,.view-more'))
        ],
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
    id = Get.arguments["id"];
    InitialData(id);
    // 浏览器下拉刷新操作
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

  // 评论 收藏初始化
  Future<void> InitialData(int id) async {
    Map<String, dynamic> data = await HttpApi.getCommentsInfo(id); // 评论数据
    List result = await DB.db.selectStars(id); // 收藏状态
    print(result.isNotEmpty);
    setState(() {
      stars = result.isNotEmpty;
      comments = data;
    });
  }

  // 浏览器夜间模式实现 js 查找dom更改
  void changeDataTheme(InAppWebViewController controller) async {
    await controller.evaluateJavascript(source: """
    let elements = document.querySelectorAll('[data-theme="light"]');
    for (var i = 0; i < elements.length; i++) {
      elements[i].setAttribute('data-theme', 'dark');
    }
  """);
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
        // 用于添加集成到 flutter widget 树中的内联原生 WebView
        child: InAppWebView(
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
            if (Get.isDarkMode) {
              changeDataTheme(controller);
            }
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
                        Get.to(const comments_page(),
                            arguments: {'id': id, 'comments': comments});
                      }
                    },
                    data: comments['comments'].toString(),
                  ),
                  // 收藏动画
                  IconButton(
                      icon: const Icon(
                        Icons.star_border_rounded,
                        size: 28,
                      ),
                      splashColor: Colors.transparent,
                      color: Get.isDarkMode
                          ? (stars ? Colors.deepOrange : Colors.white) // 夜间模式
                          : (stars ? Colors.deepOrange : Colors.black), // 日间模式
                      onPressed: () {
                        // 初始化收藏信息
                        final StarsData star = StarsData();
                        star.id = id;
                        star.title = Get.arguments['title'];
                        star.url = Get.arguments['link'];
                        star.hint = Get.arguments['description'];
                        star.image = Get.arguments['images'];
                        star.collectTime = DateTime.now().toIso8601String();
                        // 收藏逻辑
                        if (stars == false) {
                          DB.db.insertStars(star); // 添加
                          setState(() {
                            stars = true;
                          });
                        } else {
                          DB.db.deleteStars(star); // 删除
                          setState(() {
                            stars = false;
                          });
                        }

                      }),
                  // 刷新按钮
                  RotationTransition(
                      turns:
                          CurvedAnimation(parent: _ctrl, curve: Curves.linear),
                      child: IconButton(
                        icon: const Icon(Icons.loop),
                        onPressed: () {
                          _ctrl.forward(from: 0);
                          webViewController?.reload();
                        },
                      )),
                  IconButton(
                    icon: const Icon(Icons.share_rounded),
                    onPressed: () {
                      Share.share('https://daily.zhihu.com/story/$id');
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
