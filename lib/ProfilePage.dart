import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'AppConstant.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  ProfilePage({required this.userId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final WebViewController controller;
  String myUserid = "";
  String userName = "";

  void initState() {
    super.initState();

    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://flutter.dev'),
      );

    AppConstant.getData(AppConstant.userId).then((userId) {
      setState(() {
        myUserid = userId!;
        _getUn();
      });
    });
  }

  void _getUn() {
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('users/{$myUserid}/un/');
    starCountRef.onValue.listen((DatabaseEvent event) {
      // userName = "@" + event.snapshot.value.toString();
      print("maps ${myUserid}");
      print("maps ${event.snapshot.value}");
      Map value = event.snapshot.value as Map;
      print("maps ${value}");
      //bio = value['bio'] ?? 'no bio';
    }).onError((error) {
      print("Error retrieving data from Firebase: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    String userId = widget.userId;
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
      ),
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeMainPage()),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: ImageIcon(AssetImage("assets/back.png")),
              ),
            ),
            title: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Username',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          body: Column(
            children: [
              // ... (Other widgets)

              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: TabBar(
                          tabs: [
                            Tab(text: 'Tab 1'),
                            Tab(text: 'Tab 2'),
                            Tab(text: 'Tab 3'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            WebViewWidget(controller: controller),
                            WebViewWidget(controller: controller),
                            WebViewWidget(controller: controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class WebViewWidget extends StatelessWidget {
  late final WebViewController controller;
  WebViewWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
        controller : controller
    );
  }
}
