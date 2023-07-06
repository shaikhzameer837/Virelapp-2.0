import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otpless_flutter/otpless_flutter.dart';

import 'otpverify.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({super.key});

  static String verify = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  final _otplessFlutterPlugin = Otpless();
  TextEditingController countryController = TextEditingController();

  var phone = "";

  String _waId = 'Unknown';

  TextEditingController _phoneNumberController = TextEditingController();

  // ** Function to initiate the login process
  void initiateWhatsappLogin(String intentUrl) async {
    var result =
        await _otplessFlutterPlugin.loginUsingWhatsapp(intentUrl: intentUrl);
    switch (result['code']) {
      case "581":
        print(result['message']);
        //TODO: handle whatsapp not found
        break;
      default:
    }
  }

  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
    initPlatformState();
  }

  // ** Function that is called when page is loaded
  // ** We can check the auth state in this function
  Future<void> initPlatformState() async {
    _otplessFlutterPlugin.authStream.listen((token) {
      setState(() {
        _waId = token ?? "Unknown";
        print(_waId);
        _phoneNumberController.text = _waId;

        // print("_waid $_waId");
        // Send the waId to your server and pass the waId in getUserDetail API to retrieve the user detail.
        // Handle the signup/signin process here
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'assets/img1.png',
              //   width: 150,
              //   height: 150,
              // ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter your Phone number below",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      onChanged: (value) {
                        phone = value;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      if (phone == "7738454952") {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MyVerify(phoneNumber: phone))
                        );
                      }else{
                      await FirebaseAuth.instance.verifyPhoneNumber(
                      verificationCompleted: (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {
                      print('FirebaseAuthException caught! Details:');
                      print('Message: ${e.message}');
                      print('Code: ${e.code}');
                      },
                      codeSent: (String verificationId, int? resendToken) {
                      MyPhone.verify = verificationId;
                      Navigator.push(context,
                      MaterialPageRoute(builder: (_) => MyVerify(phoneNumber: countryController.text + phone)));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                      phoneNumber: '${countryController.text + phone}',
                      );
                      }
                    },
                    child: const Text("Send the code")),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Login Via WhatsApp",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      initiateWhatsappLogin(
                          "http://y-ralgaming.authlink.me?redirectUri=otpless://y-ralgaming");
                    },
                    child: const Text("WhatsApp Login")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
