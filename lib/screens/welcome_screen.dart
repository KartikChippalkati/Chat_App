import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/Rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'Welcome_screen'; //so that no can change these value

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  //the SingleTickerProviderStateMixin is used when we have a single animation
//if we have a multiple animations then we use TickerProviderStateMixin

  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    controller.forward();
    //animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    // while defining the above curved animation, we should not define the upper and lower bound bcz the curved anmtion range is compulsory between 0 to 1

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);

/*
    if controller.forward(); is called then  animation status will print Animation completed
    if controller.reverse(from: ); is called then  animation status will print Animation dismissed



    animation.addStatusListener((status) {
      // this will return the status of the animation wheather it is completed or not
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
*/

    //  controller.addListener this will trace the value of the Controller
    // by default(without defining the upper bound and lower bound properties) the controller value travels between 0 to 1 in dicimals
    controller.addListener(() {
      setState(() {});
    });
  }

  //whenever we are using animation controller remember to write the dispose method
  //when the screen is exited then it will dispose that animation
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'Logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    //height: animation.value * 100,
                    height: 60.0,
                  ),
                ),

                //we can apply the animation on texts by importing the animated_text_kit pacakage from flutter.dev

                //to implement below animation first start with the DefaultTextStyle and the compiler will automatically generate the AnimatedTextKit child and complete as u desire
                DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('Flash Chat'),
                      ],
                      onTap: () {},
                    )

                  /*textStyle: TextStyle(
                    fontSize: 45.0,
                     fontWeight: FontWeight.w900,
                  ),*/
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              colour: Colors.lightBlueAccent,
              text: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              colour: Colors.lightBlueAccent,
              text: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
