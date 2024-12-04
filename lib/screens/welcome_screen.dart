import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/sinup_screen.dart';
import 'package:chat_app/theming/colors.dart';
import 'package:chat_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
static const String routeName = "WelcomeScreen";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/message.png'),
                          fit: BoxFit.cover)),
                ),
                Text(
                  'Welcome to Chat App',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ButtonWidget(
              text: 'Login',
              color: Colortheme.primary,
              onPressrd: () {
               Navigator.pushNamed(context, LoginScreen.routeName);

              },
            ),
            SizedBox(
              height: 10,
            ),
            ButtonWidget(
              text: "registration",
              color:  Colortheme.sacond,
              onPressrd: () {
                Navigator.pushNamed(context, SignupScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
