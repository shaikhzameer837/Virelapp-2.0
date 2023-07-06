import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../AppConstant.dart';
import 'PaymentHistory.dart';
import 'RequestPayment.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  void _handleApiCall() {
    setState(() {
      print("success i have been rec");
      AppConstant.showToast("Payment Requested successfully");
      _tabController?.index = 2;
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: "Payment\nWithdraw",
                ),
                Tab(
                  text: "Payment\nHistory",
                ),
                Tab(
                  text: "Payment\nStatus",
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              RequestPayment(onApiCall: _handleApiCall),
              PaymentHistory(),
              PaymentStatus(),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentStatus extends StatefulWidget {
  @override
  _PaymentStatusState createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConstant.lightBlack,
        body: FutureBuilder(
          future:
          // makePostRequest()
          http.get(
              Uri.parse("${AppConstant.AppUrl}get_status.php?user_id=95")),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.body);
              return SizedBox(
                  height: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                alignment: AlignmentDirectional.topStart,
                                child: CachedNetworkImage(
                                  memCacheHeight: 50,
                                  memCacheWidth: 50,
                                  imageUrl: data[index]["image_url"],
                                  width: 50,
                                  height: 50,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      ClipOval(
                                        child: Image.asset(
                                          "assets/avatar.jpeg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[index]["name"],
                                          style: TextStyle(color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          data[index]["status"],
                                          style: TextStyle(color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(right: 14),
                        ),
                      );
                    },
                  ));
            } else {
              return Container();
            }
          },
        ));
  }
}
