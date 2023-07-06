import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../AppConstant.dart';
import '../Payment/Payment.dart';

class RewardSheet extends StatefulWidget {
  @override
  _RewardSheetState createState() => _RewardSheetState();
}

class _RewardSheetState extends State<RewardSheet>
    with SingleTickerProviderStateMixin {
  List<Tab> tabList = [Tab(text: "Rewards")];
  TabController? _tabController;
  String _userId = "";
  List<WebViewWidget> tabViews = [];
  @override
  void initState() {
    super.initState();
    AppConstant.getData(AppConstant.userId).then((userId) {
      setState(() {
        _userId = userId!;
        print("userIdzzz $userId");
        tabViews.add(
          WebViewWidget(
            controller: WebViewController()
              ..loadRequest(
                Uri.parse("http://y-ral-gaming.com/admin/api/reward/rewards.php?u=$_userId"),
              )
              ..setNavigationDelegate(
                NavigationDelegate(
                  onNavigationRequest: (navigation) {
                    if (navigation.url.contains('redirect_to_app')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Payment(),
                        ),
                      );
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                ),
              ),
          ),
        );
        _tabController = TabController(length: tabList.length, vsync: this);
      });
    });
  }

  String getDate() {
    var now = DateTime.now();
    var formatter = DateFormat("yyyy-MM-dd");
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabList.length,
      child: Container(
        height: 500,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 50),
              child: TabBar(
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                isScrollable: true,
                tabs: tabList,
                controller: _tabController,
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: List.generate(tabList.length, (index) {
                    return Offstage(
                      offstage: false,
                      child: tabViews[index],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
