import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:item_news/pages/App.dart';

void main() {
  // 显式调用
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
  // 沉浸式状态栏
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit( // 屏幕适配
        designSize: const Size(750.0, 1334.0),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'news',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.light,
            initialRoute: "/",
            defaultTransition: Transition.cupertino,
            transitionDuration: const Duration(milliseconds: 450),
            home: const app(),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}
