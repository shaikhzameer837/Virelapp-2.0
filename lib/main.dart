import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virelapp/terms.dart';

import 'AppConstant.dart';
import 'MainSheet/HomeSheet.dart';
import 'MainSheet/RewardSheet.dart';
import 'onboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryTextTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.black),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<SharedPreferences>(
        future: _prefs,
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasData) {
            final SharedPreferences prefs = snapshot.data!;
            final bool hasOptedForConcern =
                prefs.getBool('termsAccepted') ?? false;

            if (hasOptedForConcern) {
              return HomeMainPage();
            } else {
              return TermCond();
            }
          } else {
            return Container(); // You can show a loading screen here if needed
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryTextTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.black),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeMain(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeMain extends StatefulWidget {
  @override
  _HomeMain createState() => _HomeMain();
}

class _HomeMain extends State<HomeMain> with SingleTickerProviderStateMixin {
  String _value = "";
  String _userId = "";
  List<Widget> TabPageList = [
    HomeSheet(),
    RewardSheet(),
    // TikTokPage(),
    // HomeSheet(),
    // HomeSheet()
  ];
  @override
  void initState() {
    super.initState();
    AppConstant.getData(AppConstant.name).then((value) {
      setState(() {
        _value = (value == "" ? "Player" : value)!;
      });
    });
    AppConstant.getData(AppConstant.userId).then((userId) {
      setState(() {
        _userId = userId!;
        print(_userId);
        print("_userId");
      });
    });
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getDestinationPage() {
    if (_userId != "") {
      return OnBoard();
    } else {
      return OnBoard();
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
                MaterialPageRoute(builder: (context) => getDestinationPage()),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Image(
                    image: AssetImage("assets/avatar.jpeg"),
                  ),
                  imageUrl: _userId == ""
                      ? "https://assets.entrepreneur.com/content/3x2/2000/1617286255-GettyImages-80145055.jpg?crop=1:1"
                      : "${AppConstant.AppUrl}images/$_userId.png",
                ),
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => getDestinationPage()),
              );
            },
            child: Text(
              _value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          actions: <Widget>[
            // Container(
            //   width: 50.0,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: const <Widget>[
            //       Icon(Icons.search, color: Colors.white),
            //       Text("Search", style: TextStyle(color: Colors.white)),
            //     ],
            //   ),
            // ),
            // Container(
            //   width: 50.0,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: const <Widget>[
            //       Icon(Icons.notifications, color: Colors.white),
            //       Text("Alert", style: TextStyle(color: Colors.white)),
            //     ],
            //   ),
            // ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => Payment()));
            //   },
            //   child: Container(
            //     width: 50.0,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         Image.asset("assets/coins.png", height: 25.0, width: 25.0),
            //         Text("14.k", style: TextStyle(color: Colors.white)),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   color: Colors.black,
            //   child: PopupMenuButton(
            //     onSelected: (value) {},
            //     itemBuilder: (BuildContext context) => [
            //       const PopupMenuItem(
            //         child:
            //             Text("Menu 1", style: TextStyle(color: Colors.white)),
            //         value: 1,
            //       ),
            //       const PopupMenuItem(
            //         child:
            //             Text("Menu 2", style: TextStyle(color: Colors.white)),
            //         value: 2,
            //       ),
            //       const PopupMenuItem(
            //         child:
            //             Text("Menu 3", style: TextStyle(color: Colors.white)),
            //         value: 3,
            //       ),
            //     ],
            //     icon: const Icon(Icons.more_vert, color: Colors.white),
            //   ),
            // ),
          ],
        ),
        body: Stack(
          children: [
            // Container(
            //   height: 40,
            //   width: double.infinity,
            //   color: Colors.red,
            //   child: Row(
            //     children: [
            //       Image.network(
            //         "https://cdn-icons-png.flaticon.com/512/6361/6361288.png",
            //         height: 30,
            //         width: 30,
            //       ),
            //       SizedBox(width: 10),
            //       const Text(
            //         "Refer a Friend and earn 10Rs",
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
                width: double.infinity,
                color: Colors.red,
                child: const Text(
                  "Apple Inc. is not involved in any way with this contest or sweepstakes",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                )),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(top: 35),
              child: const Text(
                "Top Popular of the week",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 60),
              height: 160,
              // child: Text("data")
              child: FutureBuilder(
                future: http.get(Uri.parse("${AppConstant.AppUrl}popular.php")),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    var data = json.decode(snapshot.data.body);
                    return SizedBox(
                        height: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data["info"].length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => ProfilePage(
                                //               userId: data["info"][index]
                                //                   ["userid"],
                                //             )));
                              },
                              child: Container(
                                color: AppConstant.lightBlack,
                                width: 130,
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      child: CachedNetworkImage(
                                        memCacheHeight: 80,
                                        memCacheWidth: 80,
                                        imageUrl: AppConstant.AppUrl +
                                            "images/" +
                                            data["info"][index]["userid"] +
                                            ".png",
                                        width: 80,
                                        height: 80,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
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
                                    Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          data["info"][index]["name"],
                                          style: TextStyle(color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            child:
                                                Image.asset("assets/coins.png"),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            data["info"][index]["amount"],
                                            style:
                                                TextStyle(color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Spacer(),
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.red[800],
                                            ),
                                            child: Center(
                                              child: Text(
                                                "#" + (index + 1).toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
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
              ),
            ),
            DraggableScrollableSheet(
              builder: (context, scrollController) {
                return Container(
                  color: Colors.black,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: scrollController,
                    child: TabPageList[_selectedIndex],
                  ),
                );
              },
              initialChildSize: 0.65,
              maxChildSize: 1,
              minChildSize: 0.65,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _selectedIndex == 0
                    ? const ImageIcon(AssetImage("assets/home_s.png"))
                    : const Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                  icon: _selectedIndex == 1
                      ? const ImageIcon(AssetImage("assets/box.png"))
                      : const Icon(Icons.card_giftcard_outlined,
                          color: Colors.white70),
                  label: "Rewards"),
              // BottomNavigationBarItem(
              //     icon: _selectedIndex == 2
              //         ? ImageIcon(AssetImage("assets/virelweb.png"))
              //         : ImageIcon(AssetImage("assets/virel.png")),
              //     label: "VirelWeb"),
              // BottomNavigationBarItem(
              //   icon: _selectedIndex == 3
              //       ? ImageIcon(AssetImage("assets/flag_s.png"))
              //       : ImageIcon(AssetImage("assets/flag.png")),
              //   label: "Mission",
              // ),
              // BottomNavigationBarItem(
              //   icon: _selectedIndex == 4
              //       ? ImageIcon(AssetImage("assets/chat_s.png"))
              //       : ImageIcon(AssetImage("assets/chat.png")),
              //   label: "Chat",
              // ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true),
      ),
    );
  }
}

class OtpLess extends StatefulWidget {
  const OtpLess({super.key});

  @override
  State<OtpLess> createState() => _OtpLessState();
}

class _OtpLessState extends State<OtpLess> {
  String _waId = 'Unknown';
  final _otplessFlutterPlugin = Otpless();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _otplessFlutterPlugin.authStream.listen((token) {
      setState(() {
        _waId = token ?? "Unknown";
// Send the waId to your server and pass the waId in getUserDetail API to retrieve the user detail.
// Handle the signup/signin process here
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
