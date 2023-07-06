import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:virelapp/phonenew.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'AppConstant.dart';
import 'CreateTeamPage.dart';
import 'main.dart';

class EventPage extends StatefulWidget {
  final String url;
  EventPage({required this.url});
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>
    with SingleTickerProviderStateMixin {
  String myUserid = "";
  bool isRegistered = false;
  String userName = "";
  List<String> urlParts = [];
  List<Tab> tabList = [];
  TabController? _tabController;
  List<WebViewWidget> tabViews = [];
  void initState() {
    super.initState();
    print("Eobject ${widget.url}");
    urlParts = widget.url.split("/");
    isRegistered = urlParts[9] == "1";
    AppConstant.getData(AppConstant.userId).then((userId) {
      setState(() {
        myUserid = userId!;
        _getTabs();
      });
    });
    loadTeams();
  }

  Future<void> loadTeams() async {
    final _ListOfTeam = await AppConstant.getData(AppConstant.teamList);
    setState(() {
      teamList = _ListOfTeam!;
    });
    await _getTeams();
  }

  void _getTabs() async {
    var response = await http.get(Uri.parse(
        "${AppConstant.AppUrl}events/get_events_tab.php?u=$myUserid&&id=${urlParts[4]}&&t=789"));
    if (response.statusCode == 200) {
      final responseObj = json.decode(response.body);
      setState(() {
        responseObj['tab'].forEach((tabName, tabUrl) {
          tabList.add(Tab(text: tabName));
          String loadurl = tabUrl;
          tabViews.add(WebViewWidget(
            controller: WebViewController()
              ..loadRequest(
                Uri.parse(loadurl),
              ),
          ));
        });
        _tabController = TabController(length: tabList.length, vsync: this);
      });
    } else {
      // handle error
    }
  }

  final _textControllers = <TextEditingController>[];
  late List<String> _values;
  late List<String> theTag;
  late String teamName;
  var teamList = "";
  void _openBottomSheet(
      String theString, String theTags, String _teamName, String teamId) {
    _values = theString.split(",");
    theTag = theTags.split(",");
    teamName = _teamName;
    _values.removeWhere((value) => value.isEmpty);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Enter Team InGame Name',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _values.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (_textControllers.length < _values.length) {
                          _textControllers.add(TextEditingController());
                        }
                        return TextField(
                          controller: _textControllers[index],
                          decoration: InputDecoration(
                            // labelText: 'Value ${index + 1}',
                            hintText: _values[index],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.0),
                    MaterialButton(
                      onPressed: () {
                        // get all values

                        bool isEmpty = false;
                        for (int i = 0; i < _textControllers.length; i++) {
                          if (_textControllers[i].text.isEmpty) {
                            setState(() {
                              _textControllers[i].clear();
                              isEmpty = true;
                            });
                          }
                        }

                        // show error message
                        if (isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please fill all values",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          // Toast.show('Please fill all values', context);
                        } else {
                          // get all values
                          String encodedTeamName =
                          base64.encode(utf8.encode(teamName));
                          Map<String, dynamic> jsonRootObject3 = {};
                          for (int i = 0; i < _textControllers.length; i++) {
                            String value = _textControllers[i].text.trim();
                            if (value.isNotEmpty) {
                              Map<String, dynamic> jsonRootObject4 = {};
                              jsonRootObject4['ingName'] =
                                  base64.encode(utf8.encode(value));
                              jsonRootObject3[theTag[i]] = jsonRootObject4;
                            }
                          }
                          Map<String, dynamic> jsonRootObject2 = {};
                          Map<String, dynamic> jsonRootObject = {};
                          jsonRootObject2["teams"] = jsonRootObject3;
                          jsonRootObject2["name"] = encodedTeamName;
                          jsonRootObject2["teamId"] = teamId;
                          jsonRootObject2["group"] = "A";
                          jsonRootObject[teamId] = jsonRootObject2;
                          registerEvent(
                              json.encode(jsonRootObject), urlParts[4]);
                        }
                      },
                      child: Text('Register'),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void registerEvent(String userJson, String tid) async {
    String url = "${AppConstant.AppUrl}V2/delete.php";
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> data = {'userJson': userJson, 'tid': tid};
    print("before sending");
    print(userJson);
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // API call successful, handle the response
      print(response.body);
    } else {
      // API call failed, handle the error
      print('API call failed with status ${response.statusCode}');
    }
  }

  var _teamList = [];
  Future<void> _getTeams() async {
    print(teamList);
    var response = await http.get(Uri.parse(
        "${AppConstant.AppUrl}get_team_list.php?teamIdList=$teamList"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _teamList = data['teamList'];
      });
      print("dataResult");
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: ImageIcon(AssetImage("assets/back.png")),
              ),
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        memCacheHeight: 180,
                        memCacheWidth: 180,
                        imageUrl: utf8.decode(base64.decode(urlParts[10])),
                        width: double.infinity,
                        height: 180,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => ClipOval(
                          child: Image.asset(
                            "assets/avatar.jpeg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total team ${urlParts[6]}/${urlParts[8]}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Spacer(),
                          MaterialButton(
                            onPressed: () {
                              if (myUserid == ""){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyPhone()),
                                );
                              }else if (!isRegistered) {
                                showBottomSheetTeamList();
                              }
                            },
                            color: !isRegistered ? Colors.yellow : Colors.white,
                            textColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Shimmer.fromColors(
                                baseColor: Colors.black,
                                highlightColor: Colors.grey,
                                child: Text(
                                  !isRegistered ? 'Join Now' : "Registered",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Container(
                  color: AppConstant.lightBlack,
                ),
                height: 3,
              ),
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
                          indicatorColor: Colors.white,
                          unselectedLabelColor: Colors.white70,
                          isScrollable: true,
                          tabs: tabList,
                          controller: _tabController,
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: List.generate(tabList.length, (index) {
                            return Offstage(
                              offstage: false,
                              child: tabViews[index],
                            );
                          }),
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

  void showBottomSheetTeamList() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 550,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.purple[800]!, Colors.purple[500]!],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Lottie.asset('assets/gifts.json', height: 100),
              const SizedBox(height: 20),
              const Text("Tap to Select the team"),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _teamList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _openBottomSheet(
                              _teamList[index]["names"],
                              _teamList[index]["teamMember"],
                              _teamList[index]["teamName"],
                              _teamList[index]["teamId"]);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                memCacheHeight: 50,
                                memCacheWidth: 50,
                                imageUrl: "png",
                                width: 50,
                                height: 50,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) => ClipOval(
                                  child: Image.asset(
                                    "assets/avatar.jpeg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    _teamList[index]["teamName"],
                                    style: TextStyle(color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    _teamList[index]["names"],
                                    style: TextStyle(color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (myUserid == "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyPhone()),
                          );
                        }else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateTeamPage()),
                          ).then((result) {
                            if (result != null && result == 'FromNextPage') {
                              print("reloading reusme");
                              loadTeams();
                              Navigator.pop(context);
                              showBottomSheetTeamList();
                            }
                          });
                        }
                      },
                      child: Text('Create a New Team'),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
