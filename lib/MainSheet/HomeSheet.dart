import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../AppConstant.dart';
import '../EventPage.dart';
import '../base/AppController.dart';

class HomeSheet extends StatefulWidget {
  @override
  _HomeSheetState createState() => _HomeSheetState();
}

class _HomeSheetState extends State<HomeSheet>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String _userId = "";
  List<Widget> tabViews = [];
  List<Tab> tabList = [Tab(text: "Free Fire"), Tab(text: "BGMI")];
  @override
  void initState() {
    super.initState();
    AppConstant.getData(AppConstant.userId).then((userId) {
      setState(() {
        _userId = userId!;
      });
    });
    tabViews.add(Container(
      child: Center(
        child: WebViewWidget(
          controller: WebViewController()
            ..loadRequest(
              Uri.parse(
                  "http://y-ral-gaming.com/admin/api/match/match_list.php?n=Free+Fire"),
            )
            ..setNavigationDelegate(
              NavigationDelegate(
                onNavigationRequest: (navigation) {
                  if (navigation.url.contains('redirect_to_app')) {
                    Uri uri = Uri.parse(navigation.url);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventPage(url: navigation.url)),
                    );
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            ),
        ),
      ),
    ));
    tabViews.add(Container(
      child: Center(
        child: WebViewWidget(
          controller: WebViewController()
            ..loadRequest(
              Uri.parse(
                  "http://y-ral-gaming.com/admin/api/match/match_list.php?n=BGMI"),
            )
            ..setNavigationDelegate(
              NavigationDelegate(
                onNavigationRequest: (navigation) {
                  if (navigation.url.contains('redirect_to_app')) {
                    Uri uri = Uri.parse(navigation.url);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventPage(url: navigation.url)),
                    );
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            ),
        ),
      ),
    ));
    _getTabs();
    _tabController = TabController(length: tabList.length, vsync: this);
  }

  void _getTabs() async {
    var response = await http.get(Uri.parse(
        "${AppConstant.AppUrl}V2/app_info.php?user_id=$_userId&&version=123"));
    if (response.statusCode == 200) {
      final responseObj = json.decode(response.body);
      // AppController().homeUrl = responseObj["mainTabs"];
      responseObj['tab'].forEach((tabName, tabUrl) {
        print("respo ${tabName} ${tabUrl}");
      });
      // Add the missing closing parenthesis here.
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: tabList,
            ),
            SizedBox(
              height: screenHeight,
              child: TabBarView(
                controller: _tabController,
                children: tabViews,
              ),
            )
          ],
        ));
  }
}
