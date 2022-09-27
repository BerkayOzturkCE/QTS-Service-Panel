import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Data/message.dart';
import 'package:technicalserviceadmin/Pages/Chat/Chat.dart';
import 'package:technicalserviceadmin/Pages/Chat/ChatPage/ChatPage.dart';

class Chats extends StatefulWidget {
  Chats(this.parentUpdate);

  @override
  State<Chats> createState() => _ChatsState();
  Function parentUpdate;
}

class _ChatsState extends State<Chats> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    getChatsFromFirebase();
    return Drawer(
      backgroundColor: selectedtheme == true
          ? Color.fromARGB(255, 29, 36, 51)
          : Colors.grey[300],
      child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(parentUpdate: widget.parentUpdate),
              SizedBox(
                height: defaultPadding,
              ),
              Flexible(
                child: getChats == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: chatList
                            .map((chatModel) => ChatWidget(chatModel))
                            .toList()),
              ),
            ],
          )),
    );
  }

  void getChatsFromFirebase() async {
    if (getChats == true) {
      chatList.clear();
      var veriler = await _firestore
          .collection("Chats")
          .where("ServiceId", isEqualTo: activeUser.uid)
          .get();
      print("/n/n/n/n");

      print(veriler.size);
      if (veriler.size != 0) {
        for (var veri in veriler.docs) {
          ChatModel chat = new ChatModel();

          chat.ChatId = veri.get("Id").toString();
          chat.ServiceId = veri.get("ServiceId").toString();
          chat.UserId = veri.get("UserId").toString();
          chat.UserImg = veri.get("UserImg").toString();
          chat.UserName = veri.get("UserName").toString();

          var veriler2 = await _firestore
              .collection("Chats")
              .doc(chat.ChatId)
              .collection('Messages')
              .orderBy('Time', descending: true)
              .limit(1)
              .get();
          String messageType =
              veriler2.docs.first.get('MessageType').toString();
          String message = veriler2.docs.first.get('Message').toString();
          if (messageType == "Image") {
            message = "Fotoğraf";
          }
          chat.LastMessage = message;

          chatList.add(chat);
        }
      }

      if (this.mounted) {
        setState(() {
          if (veriler.size != 0) {
            CurrentChat = chatList.first;
          }
          getChats = false;
          ChatRead = false;
          widget.parentUpdate();
        });
      }
      ;
    }
  }

  Widget ChatWidget(ChatModel chatModel) {
    print(chatList.length);
    return ListTile(
      onTap: () {
        if (CurrentChat.ChatId != chatModel.ChatId) {
          CurrentChat = chatModel;
          ChatRead = false;
          print(CurrentChat.UserName);
          widget.parentUpdate();
          setState(() {});
        }
      },
      selected: chatModel.ChatId == CurrentChat.ChatId,
      hoverColor: selectedtheme == true
          ? Color.fromARGB(255, 30, 33, 45)
          : Colors.grey[400],
      selectedTileColor: selectedtheme == true
          ? Color.fromARGB(255, 30, 33, 45)
          : Colors.grey[400],
      selectedColor: selectedtheme == true ? Colors.white : Colors.black,
      leading: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(180)),
          child: Image.network(
            chatModel.UserImg,
            height: 40,
            width: 40,
          )),
      title: Text(
        chatModel.UserName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .apply(
                bodyColor: selectedtheme == true ? Colors.white : Colors.black)
            .titleMedium,
      ),
      subtitle: Text(
        chatModel.LastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .apply(
                bodyColor:
                    selectedtheme == true ? Colors.white54 : Colors.black54)
            .subtitle2,
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.parentUpdate,
  }) : super(key: key);
  final Function parentUpdate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
              icon: Icon(Icons.menu,
                  color: selectedtheme == true ? Colors.white : Colors.black),
              onPressed: () {
                if (!scaffoldKey.currentState!.isDrawerOpen) {
                  scaffoldKey.currentState!.openDrawer();
                }
              }),
        Text(
          "Chat",
          style: Theme.of(context)
              .textTheme
              .apply(
                  bodyColor:
                      selectedtheme == true ? Colors.white : Colors.black)
              .headline6,
        ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        IconButton(
            onPressed: () {
              ChatRead = true;
              getChats = true;
              parentUpdate();
            },
            icon: Icon(
              Icons.refresh,
              color: selectedtheme == true ? Colors.white : Colors.black,
            ))
      ],
    );
  }
}
