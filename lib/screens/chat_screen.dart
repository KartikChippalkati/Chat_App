import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User LoggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'Chat_Screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController =
      TextEditingController(); //this variable will controll the text  . This controller variable must be used inside a nay textfield or in the place where the text is going to be added or taken input from the user
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth
      .instance; // we have to create this Firebase instance auth where we can access many other properties of authentication
  //use only User to access the currentuser and should not use FirebaseUser.It will throw an error
  String messageText;
  @override
  void initState() {
    super.initState();

    getCurrentUSer();
  }

  //this has to be done because when I send the message  the the receiver should get to know my registered email id
  var myEmail;
  void getCurrentUSer() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        LoggedInUser = user as User;

        myEmail = LoggedInUser.email;

        print(myEmail);
      }
    } catch (e) {
      print(e);
    }
  }

  //retriving or getting back the data from the Firestore

  //In this getMessages() method ,when we add data to the firebase, if we want to see or retrive the data , then by this method,we have to keep pressing thT CLOSE BUTTON or the BUTTON where we have specified this getMessages() method and it takes large time to retrive and also it will show up the whole data from the first.So we should use the Streams and snapshots to do retrive the data
/*
  void getMessages() async {
    final messages = await _firestore.collection('messages').get();

    //as in firestore the documents is a List,we have to use for-in loop to get all the data from the documents

      for (var message in messages.docs) {
        print(message.data());
      };


  }*/

  //this snapshots(); will give us a live data which is being stored in the firestore
  //this snapshots(); will retrivr the  live data which is being stored in the firestore and use it.

  //by this below method, the firebase is notifying our app of any new messages via the stream of data snapshots.
  //for the above getMessages() method if we want to see the updated messages we have to press the button where we have called this method but by below method, once we update or send or receive any messages , the message or console get updated automatically wih the help of snapshots and streams

  void messageStreams() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      // this line will give me the list of futures.To traverse through that whole list of futures(snapshots) below we use another for-in loop.We have to loop through the snapshots which are basically a list of futures
      for (var messages in snapshot.docs) {
        print(messages.data());
      }
    }
  }

  //our dart snapshots gives us a stream.So we need a something that can handle the stream and create the list of text widgets and update that widget every time a new message is added to the widget.That something is StreamBuilder widget
  //StreamBuilder will default call the setState method which will call the whole "build" method if any updates come up

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: MessageStream(
                myselfEmail: myEmail,
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    //Implement send functionality.
                    //once we hit the send button the messagetext and sender  email id should be stored in the cloud firestore data base
                    //messageText + LoggedInUser.email
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'sender email id': LoggedInUser.email,
                        'text': messageText
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//this I am doing to improve the UI of the app

class MessageStream extends StatelessWidget {
  //const MessageStream({Key? key}) : super(key: key);
  MessageStream({this.myselfEmail});
  final String myselfEmail;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //we have to define the QuerySnapshot because we have to tell the StreamBuilder to take the data from the cloud firestore
      //stream is property which tells the streambuilder where from the data has to be taken
      stream: _firestore.collection('messages').snapshots(),

      // "builder" property , whenever a new message is being is sent,our stream builder receives a "AsyncSnapshot".At this point the builder function needs to update the list of messages displayed on the screen.In other words the builder need to rebuild all the children of the stream builder."builder"  will return the actual widget
      // the stream snapshots(firebase query snappshot) is totally different from the builder snapshot(flutter snapshot)
      // AsyncSnapshot represents the most recent interaction with the stream
      //query snapshot is from firebase cloud firestore

      builder: (context, snapshot) {
        //builder function will always return a widget or anything.totally a builder function will retrun anything
        //we have to check if the snapshot is giving the data or not and handle it yt adding the Circularprogressindicator
        //bcz of weak internet or if the firebase has no any data yet then snap shot will not give any data
        if (!snapshot.hasData) {
          // the spinner will show only when the firestore does not return or not have any data .If it has data then it will read that coloumn code and this if() code will be destroyed
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot
            .data.docs.reversed; // this reversed is added bcz of ListView
        //this is a List of documents    // this .data is of flutter
        //our AsyncSnapshot from the stream builder contains the QuerySnapshot from Firebase.The Querysnapshot contains the list of document snapshot

        List<MessageBubbleDecoration> messageBubbler = [];
        for (var message in messages) {
          final messageText = message.data()[
              'text']; //Do not write only  message.data['text'];   It will throw an error
          //this .data is of firebase and above .data is of flutter

          final senderEmailId = message.data()['sender email id'];
          // print(messageText);
          // print(senderEmailId);

          // final currentUserloggedInUserEmailId =
          //this i am creating to differentiating the messages based upon our messages and the sender

          final messageBubble = MessageBubbleDecoration(
            text: messageText,
            email: senderEmailId,
            isSenderMe: myselfEmail == senderEmailId,

            //isSenderMe: currentUserloggedInUserEmailId == senderEmailId,
          );
          // print(mEmail);
          messageBubbler.add(messageBubble);
        }

        // To have a "Scrolling" effect we have to add the widget to be scrolled inside the "ListView"

        return Expanded(
          child: ListView(
            //As we add message to the list or we send message , that message will go down and the screen will not automatically slide down when the new message arrives,To make the Screen automatically slide down when the new message arrives is add "reverse = true" property to the ListView.
            //this reverse will make the ListView to stick up to the bottom of the screen
            //But adding "reverse = true" property is that whenever new message arrives that message will go to the top of the screen or to top of the list of messages.To avoid this we have to add   ".reversed" property to the this    final messages = snapshot.data.docs.   this will reverse the lsit and make the new message to go the bottom of the screen
            children: messageBubbler,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            reverse: true,
          ),
        );
      },
    );
  }
}

class MessageBubbleDecoration extends StatelessWidget {
  //const MessageBubbleDecoration({Key? key}) : super(key: key);
  MessageBubbleDecoration({this.email, this.text, this.isSenderMe});

  final String text;
  final String email;
  bool isSenderMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            //In CrossAxisAlignment   .start means to the left of the screen and .end means to the right of the screen

            isSenderMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            // Here I dont want to color the email , add elevation to email,add borderRadius to email text, So i will not wrap this email with Material Widget.If I want to modify the oter portion of the widget , then i add the Material Widget
            email,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 5,
            //borderRadius: BorderRadius.circular(30.0),
            //for making the border of the bubble arrow type at one end i will do this below one
            borderRadius: isSenderMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),

            color: isSenderMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isSenderMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
