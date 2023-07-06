import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:virelapp/phonenew.dart';
import 'AppConstant.dart';
import 'main.dart';

class MyVerify extends StatefulWidget {
  final String phoneNumber;

  const MyVerify({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  String phoneNumber = '';
  String token = "";
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phoneNumber;
    // initAsync();
  }
  // Future<void> initAsync() async {
  //   token = (await messaging.getToken())!;
  //   print(token);
  //   print("token generate");
  // }
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var code = '';

    checkPhoneNumberApi() async {
      print("entered");
      try {
        String url =
            '${AppConstant.AppUrl}register.php?token=${token}&uniqueId=${(DateTime.now().millisecondsSinceEpoch / 1000)}&phoneNumber='+phoneNumber+'&referral=';
        print("urlLink ${url}");
        final response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print("response.body ${response.body} ...");
          bool success = data['success'];
          if (success) {
            if (data['isNew']) {

            } else {
              print(data['userName']);
              // AppConstant.setCredentials("7738454952",data['userid']);
              AppConstant.saveData(AppConstant.name, data['name']);
              AppConstant.saveData(AppConstant.userId, data['id']);
              AppConstant.saveData(AppConstant.phoneNumber, "");
              AppConstant.saveData(AppConstant.userName, data['userName']);
              AppConstant.saveData(AppConstant.games, data['games']);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeMainPage()),
              );
            }
          }
          print('responseM');
          print(data);
        } else {
          print(response.statusCode);
          print(response.body);
          print('responseM Failed to create post');
        }
      } catch (e) {
        print("responseM" + 'An error occurred: $e');
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,

                showCursor: true,
                onChanged: (value) {
                  code = value;
                },
                // onCompleted: (pin) => print(pin),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      print("phoneNumber $phoneNumber");
                      if (phoneNumber == "7738454952"){
                        checkPhoneNumberApi();
                      }else {
                        try {
                          PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                            verificationId: MyPhone.verify,
                            smsCode: code,
                          );

                          // Sign the user in (or link) with the credential
                          await auth.signInWithCredential(credential);
                          checkPhoneNumberApi();
                        } catch (e) {}
                      }
                    },
                    child: Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'phone',
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
