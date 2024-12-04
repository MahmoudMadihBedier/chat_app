import 'package:chat_app/theming/colors.dart';
import 'package:chat_app/widgets/massage_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChattScreen extends StatefulWidget {
  static const String routeName = "ChattScreen";

  @override
  State<ChattScreen> createState() => _ChattScreenState();
}

class _ChattScreenState extends State<ChattScreen> {
  TextEditingController messageController = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late User sinInUser;
  String? message;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrenntUser();
    
  }

  void getCurrenntUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        sinInUser = user;
        print(sinInUser.email);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // void getMassages() async {
  //  final messages =await firestore.collection("messages").get();

  //  for(var message in messages.docs){
  //    print(message.data());
  //  }

  // }
  void messageStream() async {
    await for (var snapshot in firestore.collection("messages").snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colortheme.sacond.withAlpha(150),
        title: Row(
          children: [
            Image.asset(
              "assets/images/message.png",
              height: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Chats"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // auth.signOut();
              // Navigator.pop(context);
              messageStream();
            },
            icon: Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
StreamBuilder<QuerySnapshot>(
  stream: firestore.collection("messages").snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Text("Error: ${snapshot.error}"),
      );
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return Center(
        child: Text("No messages yet. Start the conversation!"),
      );
    }

    final messages = snapshot.data!.docs; // Reversed to show the latest message on top
    List<Widget> messageWidgets = messages.map((message) {
      final messageText = message.get("text") as String;
      final messageSender = message.get("sender") as String;
      final isMe = sinInUser.email == messageSender;

      return MessageBubble(
        text: messageText,
        sender: messageSender,
        isMe: isMe,
      );
    }).toList();

    return Expanded(
      child: ListView(
        reverse: true, // Keeps the scroll at the bottom where new messages appear
        children: messageWidgets,
      ),
    );
  },
),

          Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colortheme.primary, width: 2)),
              child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                Expanded(
                    child: TextField(
                      controller: messageController,
                  onChanged: (value) {
                    message = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none,
                    hintText: "write your message",
                  ),
                )),
                TextButton(
                    onPressed: () {

                      firestore
                          .collection("new_messages")
                          .add({"text": message, "sender": sinInUser.email});
                      messageController.clear();
                    },
                    child: Text(
                      "Send",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colortheme.primary),
                    ))
              ]))
        ],
      )),
    );
  }
}
