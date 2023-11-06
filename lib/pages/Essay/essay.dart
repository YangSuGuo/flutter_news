import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

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

class _essayState extends State<essay> with SingleTickerProviderStateMixin {
  /// 文章
  Map<String, dynamic> items = {}; // 文章正文
  Map<String, dynamic> comments = {}; // 评论信息
  int id = 9766161; // 初始值 id
  // 按钮
  bool stars = false;
  /// 旋转动画
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: const Duration(seconds: 1));

  /// 浏览器
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
    print("获取传值:${Get.arguments["id"]}");
    id = Get.arguments["id"];
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
          await DioUtils.instance.dio.get('${HttpApi.zhihu_comments_info}$id');
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
            // 应该是解析转换为widget,根据图片与文字的间隙看出，
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
                      // isSelected: stars,
                      // selectedIcon: const Icon(Icons.star,size: 28,color: Colors.amber),
                      // highlightColor: Colors.amber,
                      // color: stars? Colors.black : Colors.amber ,
                      onPressed: () {
                        stars = !stars;
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
                  // todo 分享功能实现
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
