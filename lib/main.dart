import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*initialRoute: '/welcome_screen',
      routes: {
        '/welcome_screen': (context) => WelcomeScreen(),
        '/registration_screen': (context) => RegistrationScreen(),
        '/login_screen': (context) => LoginScreen(),
        '/chat_screen': (context) => ChatScreen(),
      },*/

      //here if we mess up with the key values while defining the routes , then the android studio does not show it and suppose if mess up then the app will crash
      // so we create a static id variable in the screen where we want to navigate and call that variable in the route mapping instead of keys
// if we did this compiler will automatically suggest us that key if we just start typing that key, but this is not in the case of String keywords which we used to define earlier

      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) =>
            WelcomeScreen(), // if does'nt use that static keyword in the declaring og the variable "id" then we have to create an object every time  like  WelcomeScreen().id
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },

      home: WelcomeScreen(),
    );
  }
}
