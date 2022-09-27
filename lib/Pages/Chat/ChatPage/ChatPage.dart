import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technicalserviceadmin/Data/Data.dart';
import 'package:technicalserviceadmin/Data/Responsive.dart';
import 'package:technicalserviceadmin/Data/message.dart';
import 'package:date_format/date_format.dart';
import 'package:technicalserviceadmin/Widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  List<Message> messageList = [];
  bool ChatWrite = true;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatTextContr = TextEditingController();
  late Stream<QuerySnapshot> _MessageStream;

  @override
  Widget build(BuildContext context) {
    StreamSetup();
    return chatList.isEmpty
        ? Scaffold(
            backgroundColor: selectedtheme == true
                ? Color.fromARGB(255, 29, 36, 51)
                : Colors.grey[300],
          )
        : Scaffold(
            appBar: widget.ChatWrite == true
                ? AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  )
                : AppBar(
                    toolbarHeight: 100,
                    foregroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(CurrentChat.UserImg),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              CurrentChat.UserName,
                              style: Theme.of(context)
                                  .textTheme
                                  .apply(
                                      bodyColor: selectedtheme == true
                                          ? Colors.white
                                          : Colors.black)
                                  .titleLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                    backgroundColor: selectedtheme == true
                        ? Color.fromARGB(255, 23, 28, 40)
                        : Colors.grey[300],
                  ),
            backgroundColor: selectedtheme == true
                ? Color.fromARGB(255, 29, 36, 51)
                : Colors.grey[300],
            body: widget.ChatWrite == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: selectedtheme == true
                                  ? Color.fromARGB(255, 29, 36, 51)
                                  : Colors.grey[300],
                            ),
                            child: StreamBuilder(
                              stream: _MessageStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text("Loading");
                                }

                                return ListView(
                                  reverse: true,
                                  children: snapshot.data!.docs
                                      .map((message) => MessageWidget(message))
                                      .toList(),
                                );
                              },
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        color: selectedtheme == true
                            ? Color.fromARGB(255, 29, 36, 51)
                            : Colors.grey[300],
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: chatTextContr,
                                        autofocus: false,
                                        maxLines: 6,
                                        minLines: 1,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Mesajını Yaz...',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[500]),
                                        ),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                onPressed: () {
                                  if (chatTextContr.text != "") {
                                    Message message = new Message();
                                    message.sender = activeUser.uid;
                                    message.text = chatTextContr.text;
                                    message.time = DateTime.now();
                                    message.messageType = "Text";
                                    message.url = "";
                                    message.imageHeight = 0;
                                    message.imageWidth = 0;
                                    LoadMessagetoFirebase(message);
                                    chatTextContr.text = "";
                                    setState(() {});
                                  }
                                },
                                icon: Icon(Icons.check),
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          );
  }

  void LoadMessagetoFirebase(Message message) async {
    try {
      DocumentReference ref = FirebaseFirestore.instance
          .collection("Chats")
          .doc(CurrentChat.ChatId)
          .collection('Messages')
          .doc();

      Map<String, dynamic> eklenecek = Map();
      eklenecek["Sender"] = message.sender;
      eklenecek["MessageType"] = message.messageType;
      eklenecek["Message"] = message.text;
      eklenecek["Time"] = message.time;
      eklenecek["Url"] = message.url;
      eklenecek["ImgHeight"] = message.imageHeight;
      eklenecek["ImgWidth"] = message.imageWidth;
      ref.set(eklenecek);
    } catch (e) {
      WarningWidget(e.toString() + " Hatası Alındı", "Hata", context);
    }
  }

  Message msgSnapToMsg(QueryDocumentSnapshot snapshot) {
    Message message = new Message();

    message.sender = snapshot['Sender'];
    message.text = snapshot['Message'].toString();
    message.url = snapshot['Url'].toString();
    Timestamp timestamp = snapshot['Time'];
    message.time = timestamp.toDate();
    message.messageType = snapshot['MessageType'].toString();
    message.imageHeight = snapshot['ImgHeight'];
    message.imageWidth = snapshot['ImgWidth'];

    return message;
  }

  Widget MessageWidget(
    QueryDocumentSnapshot messageSnap,
  ) {
    Message message = msgSnapToMsg(messageSnap);
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: message.sender == activeUser.uid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                padding: message.messageType == "Text"
                    ? EdgeInsets.all(10)
                    : EdgeInsets.all(2),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6),
                decoration: BoxDecoration(
                    color: message.sender == activeUser.uid
                        ? Colors.green
                        : Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(
                          message.sender == activeUser.uid ? 12 : 0),
                      bottomRight: Radius.circular(
                          message.sender == activeUser.uid ? 0 : 12),
                    )),
                child: message.messageType == "Text"
                    ? Text(message.text,
                        style: Theme.of(context)
                            .textTheme
                            .apply(bodyColor: Colors.white)
                            .bodyLarge)
                    : Container(
                        height:
                            (message.imageHeight - message.imageWidth).abs() >
                                    150
                                ? (message.imageHeight > message.imageWidth
                                    ? 320
                                    : 200)
                                : 250,
                        width:
                            (message.imageHeight - message.imageWidth).abs() >
                                    150
                                ? (message.imageWidth > message.imageHeight
                                    ? 320
                                    : 200)
                                : 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: Image.network(
                            message.url,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: message.sender == activeUser.uid
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  DateFormat('Hm', 'en_US').format(message.time).toString(),
                  style: Theme.of(context)
                      .textTheme
                      .apply(
                          displayColor: selectedtheme == true
                              ? Colors.white
                              : Colors.black)
                      .bodySmall,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<Image> getImage(String url) async {
    return Future.delayed(Duration(milliseconds: 2000), () {
      return Image.network(url);
    });
  }

  void StreamSetup() {
    print(ChatRead);
    if (chatList.isNotEmpty) {
      if (ChatRead == false) {
        _MessageStream = FirebaseFirestore.instance
            .collection('Chats')
            .doc(CurrentChat.ChatId)
            .collection('Messages')
            .orderBy('Time', descending: true)
            .snapshots();
        ChatRead = true;

        print("/n/n/n");
        widget.ChatWrite = false;
      }
    }
  }
}
