import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technicalserviceadmin/Data/Controller.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Pages/Chat/ChatPage/ChatPage.dart';
import 'package:technicalserviceadmin/Pages/Chat/Chats/Chats.dart';
import 'package:technicalserviceadmin/Pages/MainMenu/Menu.dart';

class Chat extends StatefulWidget {
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  void updatePage() {
    print("*-*-*-*-*-*-*-*--*-*-*-*-*-");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: selectedtheme == true
            ? Color.fromARGB(255, 23, 28, 40)
            : Colors.white,
        body: SafeArea(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 1,
              child: Chats(this.updatePage),
            ),
            SizedBox(
              width: defaultPadding,
            ),
            Expanded(flex: 2, child: ChatPage())
          ]),
        ));
  }
}
