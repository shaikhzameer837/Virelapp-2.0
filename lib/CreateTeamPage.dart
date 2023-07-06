import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppConstant.dart';

class CreateTeamPage extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CreateTeamPage> {
  late Contact _contact = Contact();
  Set<String> userIdList = {};
  Set<String> selectedIds = {};
  var countrCode = "";
  var teamList = "";
  TextEditingController _nameController = TextEditingController();
  var userId = "";
  final FlutterContactPicker _contactPicker = new FlutterContactPicker();
  void _selectContact() async {
    Contact? contact = await _contactPicker.selectContact();
    setState(() {
      _contact = contact!;
      print(cleanPhoneNumber((_contact.phoneNumbers).toString()));
      checkPhoneNumber(cleanPhoneNumber((_contact.phoneNumbers).toString()),
          (_contact.phoneNumbers).toString());
    });
  }

  @override
  void initState() {
    super.initState();
    AppConstant.getData(AppConstant.countryCode).then((value) {
      countrCode = "+91"; //value!;
    });
    AppConstant.getData(AppConstant.userId).then((_userId) {
      setState(() {
        userId = _userId!;
        selectedIds.add(userId);
      });
    });
    AppConstant.getData(AppConstant.teamList).then((_teamList) {
      setState(() {
        teamList = _teamList!;
      });
    });
    _loadUserIdList();
  }

  Future<void> _loadUserIdList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var decodedList =
          json.decode(prefs.getString(AppConstant.loyalFriends) ?? '');
      List<String> decodedUserId = json.decode(decodedList);
      userIdList = Set<String>.from(decodedUserId);
    });
  }

  void createTeam() async {
    var selected = selectedIds.join(',');
    String encodedString = base64.encode(utf8.encode(_nameController.text));
    var response = await http.get(Uri.parse(
        "${AppConstant.AppUrl}create_team.php?owner=$userId&teamMember=$selected&teamName=$encodedString"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(response.body);
      AppConstant.showToast("team created");
      AppConstant.saveData(AppConstant.teamList, "$teamList${data["id"]},");
      print("$teamList,${data["id"]}");
      print("before going next");
      Navigator.pop(context, 'FromNextPage');
    } else {
      AppConstant.showToast("something went wrong ");
    }
  }

  void checkPhoneNumber(String phoneNumber, String realNumber) async {
    phoneNumber = cleanPhoneNumber(phoneNumber);
    var response = await http.get(Uri.parse(
        "${AppConstant.AppUrl}V2/check_number.php?number=$phoneNumber"));
    if (response.statusCode == 200) {
      final responseObj = json.decode(response.body);
      if (!responseObj["success"]) {
        print("not found");
      } else {
        // Perform asynchronous work outside of setState()
        Map<String, String> toJson() {
          return {
            AppConstant.phoneNumber: realNumber,
          };
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String personJson = json.encode(toJson());
        prefs.setString(responseObj["userId"], personJson);
        setState(() {
          userIdList.add(responseObj["userId"]);
          selectedIds.add(responseObj["userId"]);
        });
        SharedPreferences loyalPref = await SharedPreferences.getInstance();
        String userIdJson = json.encode(userIdList.toList());
        loyalPref.setString(AppConstant.loyalFriends, userIdJson);

        // Update the state synchronously inside setState()

        print("found");
      }
    } else {
      print("error");
    }
  }

  Future<Map<String, String>> _getPersonFromPrefs(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String personJson = prefs.getString(userId) ?? '';
    if (personJson.isNotEmpty) {
      print(personJson);
      Map<String, dynamic> personData = json.decode(personJson);
      Map<String, String> personDataString = personData.cast<String, String>();
      return personDataString;
    } else {
      return {};
    }
  }

  String cleanPhoneNumber(String phoneNumber) {
    var countrCode = "+91";
    print("entering $countrCode -- $phoneNumber");
    if (phoneNumber.contains('+')) {
      print("found +");
      phoneNumber = phoneNumber.replaceAll(countrCode, "");
      print("phoneNumber $phoneNumber");
    }
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    return phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFAD5389),
              Color(0xFF240B36),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Lottie.asset(
                      'assets/chat.json', // Replace with your own Lottie file
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        child: TextField(
                          controller: _nameController,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny((RegExp('\n'))),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Enter your Team name',
                            labelStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: userIdList.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                              future: _getPersonFromPrefs(
                                  userIdList.elementAt(index)),
                              builder: (BuildContext context,
                                  AsyncSnapshot<Map<String, String>> snapshot) {
                                print("has data $snapshot.hasData");
                                if (snapshot.hasData) {
                                  String phoneNumber =
                                      snapshot.data?[AppConstant.phoneNumber] ??
                                          '';
                                  print("found number $phoneNumber");
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          leading: CachedNetworkImage(
                                            memCacheHeight: 50,
                                            memCacheWidth: 50,
                                            imageUrl:
                                                "${AppConstant.AppUrl}images/${userIdList.elementAt(index)}.png",
                                            width: 50,
                                            height: 50,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50)),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                              'Phone Number: $phoneNumber'),
                                          subtitle: Text(
                                              'User ID: ${userIdList.elementAt(index)}'),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (selectedIds.contains(
                                                userIdList.elementAt(index))) {
                                              selectedIds.remove(
                                                  userIdList.elementAt(index));
                                            } else {
                                              selectedIds.add(
                                                  userIdList.elementAt(index));
                                            }
                                          });
                                        },
                                        child: Text(
                                          selectedIds.contains(
                                                  userIdList.elementAt(index))
                                              ? 'Added'
                                              : 'Add',
                                          style: TextStyle(
                                            color: selectedIds.contains(
                                                    userIdList.elementAt(index))
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor: selectedIds.contains(
                                                  userIdList.elementAt(index))
                                              ? MaterialStateProperty.all<
                                                  Color>(Colors.white)
                                              : MaterialStateProperty.all<
                                                  Color>(Colors.red),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: const BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const CircularProgressIndicator(); // Show a loading indicator while waiting for data to be retrieved
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black),
                              ),
                              child: MaterialButton(
                                child: const Text('Select Friends'),
                                onPressed: () {
                                  _selectContact();
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black),
                              ),
                              child: MaterialButton(
                                child: const Text('Create team'),
                                onPressed: () {
                                  if (_nameController.text.isEmpty) {
                                    AppConstant.showToast(
                                        'Please enter a team name');
                                  } else {
                                    if (selectedIds.length < 2) {
                                      AppConstant.showToast(
                                          'Select at least one friend');
                                    } else {
                                      createTeam();
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
