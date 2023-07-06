import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'AppConstant.dart';
import 'ProfilePage.dart';

class EditProfile extends StatefulWidget {
  EditProfile();
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String dropdownValue = 'Noob'; // The initial value of the dropdown
  String _username = ''; // initial username
  String name = "";
  String _userId = "";
  String _errorText = "";
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _TitleController = TextEditingController();
  final TextEditingController _oldUsernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  void initState() {
    super.initState();
    AppConstant.getData(AppConstant.name).then((value) {
      setState(() {
        name = (value == "" ? "Player" : value)!;
        _nameController.text = name;
      });
    });
    AppConstant.getData(AppConstant.userId).then((userId) {
      setState(() {
        _userId = userId!;
      });
    });
    AppConstant.getData(AppConstant.userName).then((userName) {
      setState(() {
        _oldUsernameController.text = userName ?? "";
      });
    });
    AppConstant.getData(AppConstant.title).then((title) {
      setState(() {
        dropdownValue = (title == "" ? "Noob" : title)!;
        print("$dropdownValue");
        _TitleController.text = dropdownValue;
      });
    });
    AppConstant.getData(AppConstant.bio).then((bio) {
      setState(() {
        _bioController.text = bio!;
      });
    });
  }

  Future<void> _openGallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    String imagePath = path.basename(pickedFile?.path ?? "");
    print("imagePath $imagePath");
  }

  @override
  void dispose() {
    _oldUsernameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _updateUsername() {
    String newUsername = _usernameController.text;
    if (newUsername.isNotEmpty) {
      setState(() {
        _username = newUsername;
        updateUserName();
      });
    }
  }

  Future<void> updateUserName() async {
    try {
      String url = '${AppConstant.AppUrl}username.php?userName=$_username';

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        // final data = json.decode(response.body);
        // bool success = data['success'];
        if (response.body == "true") {
          _oldUsernameController.text = _username;
        } else {
          setState(() {
            _errorText = "UserName Already Exist try something else";
          });
        }
        print('responseM');
        print(response.body);
      } else {
        print(response.statusCode);
        print(response.body);
        print('responseM Failed to create post');
      }
    } catch (e) {
      print("responseM" + 'An error occurred: $e');
    }
  }

  Future<void> updateInfo() async {
    try {
      String url = '${AppConstant.AppUrl}V2/update_profile.php';
      print("Api Url \n $_userId \n");
      print(url);

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user_id": _userId,
          "name": _nameController.text,
          "userName": _usernameController.text,
        }),
      );

      if (response.statusCode == 200) {
        // final data = json.decode(response.body);
        // bool success = data['success'];
        if (response.body == "1") {
          AppConstant.saveData(AppConstant.name, _nameController.text);
          AppConstant.saveData(AppConstant.userName, _usernameController.text);
          AppConstant.saveData(AppConstant.bio, _bioController.text);
        }
        print('responseM-');
        print(response.body);
      } else {
        print(response.statusCode);
        print(response.body);
        print('responseM Failed to create post');
      }
    } catch (e) {
      print("responseM" + 'An error occurred: $e');
    }
  }

  void _showBottomSheet() {
    _usernameController.text = _oldUsernameController.text;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Enter New Username',
                  errorText: _errorText,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUsername,
                child: const Text('Check Username'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          _TitleController.text = dropdownValue;
        });
      },
      items: <String>[
        'Noob',
        'Sentinel',
        'Camper',
        'Ace',
        'Smurf',
        'Strategist'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
    // TODO: implement build
    return Theme(
        data: ThemeData(),
        child: Scaffold(
          backgroundColor: Color(0xFF240B36),
          appBar: AppBar(
            backgroundColor: Color(0xFFAD5389),
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(userId: "95")),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Container(
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
                    alignment: AlignmentDirectional.topCenter,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {},
                          child: CachedNetworkImage(
                            memCacheHeight: 160,
                            memCacheWidth: 160,
                            imageUrl:
                                "${AppConstant.AppUrl}images/$_userId.png",
                            width: 160,
                            height: 160,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(80)),
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
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Click on Photo to change DP",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                          child: TextField(
                        // controller: _TitleController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText:
                              'Select an option', // label for the text field
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          suffixIcon: Icon(Icons
                              .arrow_drop_down), // Icon for the dropdown button
                        ),
                        readOnly: true, // Make the text field non-editable
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.check),
                                    title: Text('Sniper'),
                                    onTap: () {
                                      setState(() {
                                        dropdownValue = 'Sniper';
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.check),
                                    title: Text('Noob'),
                                    onTap: () {
                                      setState(() {
                                        dropdownValue = 'Noob';
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.check),
                                    title: Text('Sentinel'),
                                    onTap: () {
                                      setState(() {
                                        dropdownValue = 'Sentinel';
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.check),
                                    title: Text('Camper'),
                                    onTap: () {
                                      setState(() {
                                        dropdownValue = 'Camper';
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.check),
                                    title: Text('Ace'),
                                    onTap: () {
                                      setState(() {
                                        dropdownValue = 'Ace';
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.check),
                                    title: Text('Smurf'),
                                    onTap: () {
                                      setState(() {
                                        dropdownValue = 'Smurf';
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.check),
                                    title: Text('Strategist'),
                                    onTap: () {
                                      setState(() {
                                        dropdownValue = 'Strategist';
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )),
                      SizedBox(height: 10),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Enter Name',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _oldUsernameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Username ',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        readOnly: true, // disable editing
                        onTap:
                            _showBottomSheet, // open the bottom sheet on click
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _bioController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Enter Bio',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                          width: 180,
                          height: 50,
                          child: MaterialButton(
                            onPressed: () {
                              updateInfo();
                            },
                            color: Colors.black,
                            elevation: 4,
                            padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ' Update Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
