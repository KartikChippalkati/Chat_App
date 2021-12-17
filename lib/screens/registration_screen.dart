import 'package:flutter/material.dart';
import 'package:flash_chat/Rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'Registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                //This Flexible widget will make the widgets inside this widget flexible,i.e it will make the widgets inside this to make adjustments by themselves and adjust to the given screen size and aspect ratio and do not show that yellow zebra lines
                child: Hero(
                  tag: 'Logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType
                    .emailAddress, //this will make the keyboard suitable for typing the email.We can make the keyboard suitable for a particular user operation by keyword => keyBoard:TextInputType.
                textAlign: TextAlign
                    .center, //this will aiiogn the text or any data entering in the textfeild align in the center
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration:
                    kTextFeildStyling.copyWith(hintText: 'Enter Your Email iD'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText:
                    true, //this is used for password or any data which u want to hide from the user or hide from the user as he type or start entering the data
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration:
                    kTextFeildStyling.copyWith(hintText: 'Enter Your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.blueAccent,
                text: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });

                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password:
                            password); //We have to check the user has entered the email or not or entered the correct email id or not we have to chech that exception also.So we put this in the "try-catch " block.W put the _auth in the try block and if any error occurs catch in the catch block
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                      print(password);
                      print(email);
                    }
                    setState(
                      () {
                        showSpinner = false;
                      },
                    );
                  } catch (exception) {
                    print(exception);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//about Hero animations
/*

* The hero refers to the widget that flies between screens.
* Create a hero animation using Flutter’s Hero widget.
* Fly the hero from one screen to another.
* Animate the transformation of a hero’s shape from circular to rectangular while flying it from one screen to another.
* The Hero widget in Flutter implements a style of animation commonly known as shared element transitions or shared element animations.*/

/*
Below i have created the TextField class by extracting the widget method and i have created the constructors
But it is of use but it is little bit complex method

So i can write it as a constant (const)  taking the code from InputDecoration in the onstant file

But i want to change the hintText but in constants i can't create the constructors and add it like previous one

But i can do more fascinating than that
i.e while calling the constants ariable at a desird place i can use the .copyWith() keyword and can change any variable of that constant and add any disired value which is required in that place
.copyWith() cpies the entire code or class which u have assigned to the variable and allows u to  change the specific variable value

see code in location and registration screen


class TextFeild extends StatelessWidget {
  final String hintText;

  TextFeild({this.hintText});
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
//Do something with the user input.
      },
      decoration: InputDecoration(
        hintText: hintText,
//focusColor: Colors.red,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
*/
