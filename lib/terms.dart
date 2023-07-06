import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virelapp/main.dart';

class TermCond extends StatefulWidget {
  const TermCond({Key? key});

  @override
  State<TermCond> createState() => _TermCondState();
}

class _TermCondState extends State<TermCond> {
  bool acceptButtonClicked = false;
  bool acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        elevation: 0,
        backgroundColor: Color.fromRGBO(37, 35, 35, 1.0),
      ),
      backgroundColor: Color.fromRGBO(37, 35, 35, 1.0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "VirelApp Terms and Conditions",
                style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 17,
                  color: Colors.yellow[800],
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.asset(
                    'assets/terms.json', // Replace with your own Lottie file
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Text(
                  "Terms and Conditions:\n\n1. Eligibility: The tournament is open to all players who meet the age and geographical requirements as specified in the app.\n\n2. Contest Period: The tournament will take place within the specified dates and times as announced by the organizers. The duration of the tournament may be subject to change at the discretion of the organizers.\n\n3. Entry: To participate, players must register for the tournament within the designated registration period. Players may be required to provide their in-game username or other relevant information during registration. Only one entry per player is permitted.\n\n4. Tournament Format: The tournament will be conducted in a specific game mode or a series of game modes as determined by the organizers. The rules and scoring system will be explained in detail within the app.\n\n5. Prizes: The prizes for the tournament will be announced prior to the commencement of the tournament. The prize distribution will be based on the final rankings or performance of the participants. Prizes are non-transferable and may not be exchanged for cash or other goods.\n\n6. Fair Play and Conduct: All participants must adhere to the fair play policies and rules of the game. Any form of cheating, hacking, or exploiting game mechanics is strictly prohibited. Participants must demonstrate good sportsmanship and respectful behavior towards other players. The organizers reserve the right to disqualify any participant for violating the rules or engaging in inappropriate behavior.\n\n7. Disputes and Decisions: Any disputes or concerns regarding the tournament should be addressed to the organizers through the provided contact information. The organizers' decisions regarding any matters related to the tournament, including disqualifications or rule interpretations, are final and binding.\n\n8. Liability and Disclaimer: The organizers shall not be held responsible for any technical issues, disruptions, or network failures that may affect the tournament. Participants acknowledge and agree that their participation in the tournament is at their own risk. The organizers shall not be liable for any damages, losses, or injuries arising from participation in the tournament.\n\n9. Apple Disclaimer: Apple Inc. is not an official sponsor of the tournament and has no involvement in the organization, promotion, or execution of the tournament. Participants acknowledge and agree that Apple is not responsible for any aspect of the tournament, including the prizes or any technical issues. The tournament is not endorsed, sponsored, or affiliated with Apple Inc. in any way.\n\n10. Modification or Termination: The organizers reserve the right to modify, suspend, or terminate the tournament at any time without prior notice. In the event of modification or termination, the organizers will make reasonable efforts to communicate the changes to the participants.\n\nBy participating in the tournament, all players agree to abide by these terms and conditions and any additional rules or instructions provided by the organizers.",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() async {
                          acceptButtonClicked = true;
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('termsAccepted', true);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                          );
                        });
                        // Handle Accept button press
                      },
                      style: ElevatedButton.styleFrom(
                        primary: acceptButtonClicked
                            ? Colors.yellow[700]
                            : Colors.transparent,
                        side: BorderSide(
                          color: Colors.yellow[800]!,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        "Accept",
                        style: TextStyle(
                          color: Colors.yellow[800],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
