import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/theme.dart';

import '../general_widgets/back_button_widget/back_button_widget.dart';

///Description
///UI to open a webside in the app.
///
///Author: J. Anders
///created: 30-11-2022
///changed: 02-02-2023
///
///History:
///02-02-2023 Change wbeview structure because of changing of library
///
///Notes:
///
class WebViewPage extends StatelessWidget {
  static const String routname = "/web_view_page";

  ///title is displayed on appbar
  final String title;
  //web url which should be opened
  final String webUrl;

  const WebViewPage({super.key, required this.title, required this.webUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Text(title),
      ),
      body: WebViewWidget(controller: _buildControler(context)),
    );
  }

  WebViewController _buildControler(BuildContext context) {
    return WebViewController()
      ..setBackgroundColor(AppTheme.hintergrund)
      ..loadRequest(UriParser.createBasicUri(url: webUrl));
  }
}
