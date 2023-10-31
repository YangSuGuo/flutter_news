import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../http/net.dart';
import 'PhotoViewSimpleScreen.dart';

// todo 如果flutter富文本不可以，就改为直接访问网页"url": "https://daily.zhihu.com/story/#{id}"
// todo 浏览器可行 webview_flutter 将json的数据组合下形成html文件渲染【这是在请求的情况下，自定义程度高！】不然的话直接访问地址也行

class essay extends StatefulWidget {
  @override
  State<essay> createState() => _essayState();
}

class _essayState extends State<essay> {
  Map<String, dynamic> items = {}; // 文章正文
  int id = 9766161; // 初始值 id
  @override
  void initState() {
    super.initState();
    // 初始化数据
    // todo 需要加载动画！！ok
    print("获取传值:${Get.arguments["id"]}");
    id = Get.arguments["id"];
    _getBody(id);
  }

  // 获取文章正文
  Future<void> _getBody(int id) async {
    try {
      final response =
          await DioUtils.instance.dio.get(HttpApi.zhihu_body + '$id');
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        setState(() {
          items = data;
        });
        print('获取正文数据成功');
      } else {
        throw Exception('获取正文数据失败');
      }
    } catch (e) {
      throw Exception('错误：$e');
    }
  }

  // 跳转文章原文
  Future<void> LaunchInBrowser(uni) async {
    if (!await launchUrl(
      uni,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('无法打开浏览器 $uni');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: items.isEmpty ? const GFLoader() : _buildBody());
  }

  Widget _buildBody() {
    return Stack(children: [
      // 图片
      SizedBox(
          height: 380,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/image/loading.gif',
            image: items['image'],
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          )),
      // 内容显示区
      ListView(children: [
        const SizedBox(height: 10),
        const SizedBox(height: 260),
        Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(75.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 文章标题
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 5, left: 20, right: 15),
                    child: Text(
                      items['title'] ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // 时间日期
                  if (items['publish_time'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 25),
                      child: Text(
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.fromMillisecondsSinceEpoch(
                                items['publish_time'] * 1000))
                            .toString(),
                        /*items['publish_time'].toString(),*/
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 18.0),
                      ),
                    ),
                  // 文章正文
                  // todo 段落首行缩进 主要文字基本为<p>,需要格式化但是排版就成问题了
                  // todo 优化文章排版 目前行高太矮
                  // todo 暂且不知道知乎日报的表格处理
                  // todo blockquote 标签样式参考https://daily.zhihu.com/story/9766035
                  // bug 优先级高的内联样式可能会导致溢出，会有部分不可见[宽度：500] 图片！！【用自定义渲染解决】
                  // bug 图片or链接在点击区域点击可能会失效 原因不明！
                  // bug 知乎日报数学符号是用<img>加载svg，不支持！！ 【自定义渲染失败时添加<svg>】
                  // bug 表格超宽会溢出
                  Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Html(
                        data: items['body'],
                        style: {
                          // 图片描述文本置灰
                          "figcaption": Style(
                              margin: Margins(
                                  top: Margin(8, Unit.px),
                                  left: Margin(8, Unit.px)),
                              color: Colors.grey),
                          // 摘要访谈
                          'blockquote': Style(
                            margin: Margins(
                                right: Margin(20, Unit.px),
                                left: Margin(20, Unit.px)),
                            color: Colors.grey,
                          ),
                          // 隐藏前后广告
                          "div.meta": Style(display: Display.none),
                          "div.view-more": Style(display: Display.none),
                          // 表格基本样式
                          "table": Style(
                            backgroundColor:
                                const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                          ),
                          "th": Style(
                            padding: HtmlPaddings.all(6),
                            backgroundColor: Colors.grey,
                          ),
                          "td": Style(
                            padding: HtmlPaddings.all(6),
                            border: const Border(
                                bottom: BorderSide(color: Colors.grey)),
                          ),
                          // 去除下划线
                          "a": Style(textDecoration: TextDecoration.none)
                        },
                        extensions: [
                          const TableHtmlExtension(),
                          const SvgHtmlExtension(),
                          // 自定义 table
                          TagWrapExtension(
                              tagsToWrap: {"table"},
                              builder: (child) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: child,
                                );
                              }),
                          // 自定义图像渲染
                          /* ImageExtension( // 官方示例
                              matchesAssetImages: false,
                              matchesDataImages: false,
                              networkSchemas: {"custom:"},
                              builder: (extensionContext) {
                                final element = extensionContext.styledElement as ImageElement;
                                return CustomImage.network(
                                  element.src.replace("custom:", ""),
                                  width: element.width,
                                  height: element.height,
                                );
                              }
                          ),*/
                          // 点击图片
                          OnImageTapExtension(
                              onImageTap: (src, imgAttributes, element) {
                            print('图片链接：' + src.toString());
                            Get.to(PhotoViewSimpleScreen(),
                                arguments: {'src': src});
                          }),
                          // 排除标签，并替换
                          TagExtension.inline(
                              tagsToExtend: {'script'},
                              child: const TextSpan(text: '')),
                        ],
                        onLinkTap: (url, _, __) {
                          debugPrint("链接为： $url...");
                          LaunchInBrowser(Uri.parse(url!));
                        },
                        // css错误
                        onCssParseError: (css, messages) {
                          debugPrint("css that errored: $css");
                          debugPrint("error messages:");
                          for (var element in messages) {
                            debugPrint(element.toString());
                          }
                          return '';
                        },
                      ))
                ],
              ),
            )),
      ]),
      // 功能区
      // todo 阅读原文 跳转浏览器打开 item['url'] 链接
      // todo 按钮组件替换为 MaterialButton
      // bug 无法点击 Stack组件问题
      Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 10),
        child: Row(children: [
          // 返回
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 1,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
              ),
            ),
            child: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          // 阅读原文
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                elevation: 1,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              ),
              child: const Icon(Icons.visibility_outlined),
              onPressed: () => LaunchInBrowser(Uri.parse(items['url']))),
        ]),
      ),
    ]);
  }
}
