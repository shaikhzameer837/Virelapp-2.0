import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../AppConstant.dart';

class RequestPayment extends StatefulWidget {
  final Function onApiCall;
  RequestPayment({required this.onApiCall});
  @override
  _RequestPaymentState createState() => _RequestPaymentState();
}

class _RequestPaymentState extends State<RequestPayment> {
  int _selectedValue = 25;
  String _selectedGame = "BGMI";
  String _selectedPaymentProvider = 'Paytm';

// Modify the _buildPaymentButton function
  Widget _buildPaymentButton(String provider, bool isSelected) {
    String iconPath = '';
    BorderSide borderSide = BorderSide.none;

    switch (provider) {
      case 'Paytm':
        iconPath = 'assets/paytm.png';
        break;
      case 'UPI Pay':
        iconPath = 'assets/upi.png';
        break;
    }

    if (isSelected) {
      borderSide = BorderSide(color: Colors.blueAccent, width: 5.0);
    }

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentProvider = provider;
        });
      },
      child: Container(
        height: 60,
        width: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: borderSide),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Image.asset(
            iconPath,
            width: 60,
            height: 60,
          ),
        ),
      ),
    );
  }

  void requestMoney(
      String upi, String wAmount, String paymentType, String gameplay) async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    Map<String, String> params = {
      'upi': upi,
      'userid': 'MrShazam',
      'id': '95',
      'amount': wAmount,
      'type': 'Redeem Money',
      'paymentType': paymentType,
      'gameplay': gameplay,
      'time': (DateTime.now().millisecondsSinceEpoch).toString(),
      'userName': 'MrSazam'
    };
    try {
      final response = await http.post(
          Uri.parse("${AppConstant.AppUrl}request_payment.php"),
          headers: headers,
          body: params);
      final responseJson = json.decode(response.body);
      print("responseJson");
      print(responseJson);
      if (responseJson['success']) {
        widget.onApiCall();
      } else {
        AppConstant.showToast('Something Went wrong');
        //TODO: show error message
      }
    } catch (e) {
      AppConstant.showToast('Something Went wrong');
      //TODO: show error message
      print(e.toString());
    }

    // Navigator.of(context).pop();
  }

  bool isValidUPIOrPhoneNumber(String input) {
    // UPI address pattern
    RegExp upiRegExp = RegExp(r'^\w+@\w+$');
    // Indian phone number pattern
    RegExp phoneNumberRegExp = RegExp(r'^\d{10}$');

    return upiRegExp.hasMatch(input) || phoneNumberRegExp.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController paymentController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Select Amount , Enter UPi & click WithDraw',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: double.infinity - 10,
              height: 220,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFFB92B27),
                  ],
                ),
              ),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildButton(25),
                      _buildButton(50),
                      _buildButton(100),
                      _buildButton(150),
                      _buildButton(200),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  transformAlignment: AlignmentDirectional.bottomCenter,
                  child: Column(
                    children: [
                      TextField(
                        controller: paymentController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your PayTM number / UPI id",
                          hintStyle: TextStyle(color: Colors.white),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/sim.png',
                            width: 50,
                            height: 50,
                          ),
                          const Expanded(
                            child: Text(
                              "Success",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ]),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Receive Payment on",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildPaymentButton(
                    'Paytm', _selectedPaymentProvider == 'Paytm'),
                const SizedBox(width: 8.0),
                _buildPaymentButton(
                    'UPI Pay', _selectedPaymentProvider == 'UPI Pay'),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "   Games You Played",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: AlignmentDirectional.topStart,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                value: _selectedGame,
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGame = newValue!;
                  });
                },
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                selectedItemBuilder: (BuildContext context) {
                  return [
                    'BGMI',
                    'Free Fire',
                    'Valorant',
                  ].map<Widget>((String item) {
                    return Text(item);
                  }).toList();
                },
                items: [
                  DropdownMenuItem(
                    value: 'BGMI',
                    child: Row(
                      children: [
                        Icon(Icons.games, color: Colors.black),
                        SizedBox(width: 8),
                        Text("BGMI"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Free Fire',
                    child: Row(
                      children: const [
                        Icon(Icons.fire_extinguisher, color: Colors.black),
                        SizedBox(width: 8),
                        Text("Free Fire"),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Valorant',
                    child: Row(
                      children: const [
                        Icon(Icons.security, color: Colors.black),
                        SizedBox(width: 8),
                        Text("Valorant"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.attach_money),
                onPressed: () {},
              ),
              MaterialButton(
                onPressed: () {
                  if (isValidUPIOrPhoneNumber(paymentController.text)) {
                    print('UPI ID: ${paymentController.text}');
                    requestMoney(
                        paymentController.text,
                        _selectedValue as String,
                        _selectedPaymentProvider,
                        "Valorant");
                  } else {
                    print('UPI ID is empty.');
                  }
                },
                child: const Text(
                  'Withdraw Amount',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                icon: Icon(Icons.attach_money),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(int value) {
    bool isSelected = _selectedValue == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedValue = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.grey,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          '$value',
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
