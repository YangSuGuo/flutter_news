import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String http;

  const CustomListTile({Key? key, required this.title, required this.http}) : super(key: key);

  Future<void> _launchInBrowser(Uri uri) async {
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('无法打开浏览器 $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // trailing: const Icon(Icons.arrow_forward_ios, size: 20),
      title: Text(title),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      contentPadding: const EdgeInsets.only(left: 10),
      onTap: () => _launchInBrowser(Uri.parse(http)),
    );
  }
}
