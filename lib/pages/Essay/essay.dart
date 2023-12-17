import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:item_news/pages/Essay/model/commentsinfo_model.dart';

import '../../db/db.dart';
import '../../http/net.dart';
import '../Comments/comments.dart';
import '../Item/model/stories_model.dart';
import '../Stars/model/stars_model.dart';
import 'Widget/operate.dart';

// bug 在无网络的情况下，会持续进行加载页面，中间打开网络并不会更新状态，需要持续请求

class essay extends StatefulWidget {
  @override
  State<essay> createState() => _essayState();
}

class _essayState extends State<essay> with TickerProviderStateMixin {
  /// 文章
  late StoriesData items; // 知乎日报
  CommentInfoData? comments; // 评论信息
  int id = 9766161; // 初始值 id
  bool stars = false; // 收藏状态

  /// 浏览器
  /// todo 添加加载图，避免闪屏！
  /// todo 增加离线下载浏览
  /// bug W/System  (23056): A resource failed to call response.body().close().
  final urlController = TextEditingController();
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  late PullToRefreshController pullToRefreshController;
  late InAppWebViewGroupOptions options;

  @override
  void initState() {
    super.initState();
    // 初始化数据
    setState(() {
      items = Get.arguments['item'];
      id = items.id!;
    });
    // 评论 收藏
    InitialData(id);
    // 浏览器设置
    options = InAppWebViewGroupOptions(
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
            geolocationEnabled: false,
            saveFormData: false,
            thirdPartyCookiesEnabled: false,
            disableDefaultErrorPage: true),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        ));
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
    CommentInfoData data = await HttpApi.getCommentsInfo(id); // 评论数据
    List result = await DB.db.selectStars(id); // 收藏状态
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
    return Scaffold(body: comments == null ? const GFLoader() : _buildBody());
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
          onLoadStart: (controller, url) async {},
          onLoadStop: (controller, url) async {
            if (Get.isDarkMode) {
              changeDataTheme(controller);
            }
            // controller.clearCache();
            pullToRefreshController.endRefreshing();
          },
        ),
      )),
      OperateBar(
        stars: stars,
        url: 'https://daily.zhihu.com/story/$id',
        ctrl: AnimationController(
            vsync: this, duration: const Duration(seconds: 1)),
        comments: comments,
        webViewController: webViewController,
        onStarChange: (newStarState) {
          final StarsData star = StarsData(
            id: id,
            title: items.title,
            url: items.url,
            hint: items.hint,
            image: items.image,
            ga_prefix: items.ga_prefix,
            collectTime: DateTime.now().toString(),
          );
          newStarState ? DB.db.insertStars(star) : DB.db.deleteStars(star);
          setState(() {
            stars = newStarState;
          });
        },
        onPressed: () {
          if (comments!.comments != 0) {
            Get.to(const comments_page(),
                arguments: {'id': id, 'comments': comments});
          }
        },
      )
    ]);
  }
}
