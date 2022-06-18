import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Home/HomeScreen.dart';
import 'package:ecommerce_app/Model/MessageModel.dart';
import 'package:ecommerce_app/services/Firestoreserv.dart';
import 'package:ecommerce_app/services/MessageService.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  String receiverusername, senderusername, senderid, receiverid, img;

  ChatScreen(
      {required this.senderid,
      required this.senderusername,
      required this.receiverid,
      required this.receiverusername,
      required this.img});
  @override
  _ChatScreenState createState() => _ChatScreenState(
      senderid, senderusername, receiverid, receiverusername, img);
}

class _ChatScreenState extends State<ChatScreen> {
  String receiverusername, senderusername, senderid, receiverid;
  Stream<QuerySnapshot>? chatMessageStream;
  bool showemoji = false;
  ScrollController scrollController = ScrollController();
  String img;
  late bool isSendByMe;
  FocusNode _focusNode = FocusNode();
  Icon sendIcon = Icon(Icons.send);
  Icon micIcon = Icon(Icons.mic);
  TextEditingController controller = TextEditingController();
  bool someThingWritten = false;
  var chatRoomId;
  _ChatScreenState(this.senderid, this.senderusername, this.receiverid,
      this.receiverusername, this.img);

  @override
  void initState() {
    getMessages();
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          showemoji = false;
        });
      }
    });
  }

  void getMessages() async {
    chatRoomId =
        await MessageService().checkExistanceofChannel(senderid, receiverid);

    if (chatRoomId != "") {
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(chatRoomId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          MessageService().readMessages(chatRoomId).then((value) {
            setState(() {
              chatMessageStream = value;
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(1, 92, 84, 20),
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.offAll(() => HomeScreen());
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              CircleAvatar(
                backgroundImage: img.isEmpty
                    ? AssetImage("assets/images/avatar.jpg")
                    : NetworkImage(img) as ImageProvider,
                maxRadius: 20,
              ),
              SizedBox(
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "$receiverusername",
                      style: GoogleFonts.sourceSansPro(
                        textStyle: TextStyle(color: Colors.white),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(receiverid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            if (snapshot.data!.get("status") == "online") {
                              return Text(
                                "online",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 230, 230, 230)),
                              );
                            } else
                              return Container();
                          } else
                            return Container();
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: WillPopScope(
          onWillPop: () {
            if (showemoji) {
              setState(() {
                showemoji = false;
              });
            } else {
              Navigator.pop(context);
            }
            return Future.value(false);
          },
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: chatMessageStream,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
                            itemCount: snapshot.data!.docs.length + 1,
                            itemBuilder: (context, index) {
                              if (index == snapshot.data!.docs.length) {
                                return Container(
                                  height: 80,
                                );
                              }
                              var sender =
                                  snapshot.data!.docs[index].get('senderid');

                              if (sender ==
                                  FirebaseAuth.instance.currentUser!.uid
                                      .toString()) {
                                isSendByMe = true;
                              } else {
                                isSendByMe = false;
                              }

                              var messageToShow =
                                  snapshot.data!.docs[index].get('messagebody');

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.only(
                                    left: isSendByMe ? 0 : 24,
                                    right: isSendByMe ? 24 : 0),
                                alignment: isSendByMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    borderRadius: isSendByMe
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(-10),
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12))
                                        : BorderRadius.only(
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12)),
                                    color: isSendByMe
                                        ? Color.fromRGBO(222, 247, 204, 20)
                                        : Colors.white,
                                  ),
                                  child: Text(
                                    "$messageToShow",
                                    style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: Colors.black,


                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Expanded(
                          child: Center(
                            child: Text(
                                "No Messages to Show Please Send Your First Message!!!"),
                          ),
                        );
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width - 60,
                          margin: EdgeInsets.only(bottom: 10, left: 4),
                          padding:
                              EdgeInsets.only(left: 4, bottom: 4, right: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _focusNode.unfocus();
                                    _focusNode.canRequestFocus = false;
                                    showemoji = true;
                                  });
                                },
                                icon: Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  focusNode: _focusNode,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Message",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    focusColor: Colors.white,
                                    border: InputBorder.none,
                                  ),
                                  cursorColor: Colors.black,
                                  controller: controller,
                                  onChanged: (String value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        someThingWritten = false;
                                      });
                                    } else
                                      setState(() {
                                        someThingWritten = true;
                                      });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 4.0, bottom: 3),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(24, 139, 125, 20),
                                maxRadius: 25,
                                child: IconButton(
                                  icon: someThingWritten ? sendIcon : micIcon,
                                  color: Colors.white,
                                  onPressed: () async {
                                    if (someThingWritten) {
                                      var sender = FirebaseAuth
                                          .instance.currentUser!.uid
                                          .toString();
                                      var otheruser, username, otherusername;
                                      if (sender == senderid) {
                                        otheruser = receiverid;
                                      } else
                                        otheruser = senderid;

                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .where("user_id", isEqualTo: sender)
                                          .get()
                                          .then((value) {
                                        username = value.docs.first.get("name");
                                      });

                                      if (username == senderusername) {
                                        otherusername = receiverusername;
                                      } else
                                        otherusername = senderusername;
                                      MessageModel model = MessageModel(
                                        loggedUserID: sender,
                                        loggedUserName: username,
                                        receiverID: otheruser,
                                        receiverName: otherusername,
                                        messageBody: controller.text,
                                        sentAt: DateTime.now().toString(),
                                      );

                                      if (controller.text.isNotEmpty) {
                                        var chatid = await MessageService()
                                            .checkExistanceofChannel(
                                                senderid, receiverid);
                                        if (chatid == "") {
                                          List users = [senderid, receiverid];
                                          var roomid = senderusername +
                                              "-" +
                                              receiverusername;

                                          Map<String, dynamic> chatRoomData =
                                              Map<String, dynamic>();
                                          chatRoomData = {
                                            'users': users,
                                            'chatRoomId': roomid,
                                          };

                                          MessageService().createChatRoom(
                                              roomid, chatRoomData);
                                        }

                                        chatRoomId = await MessageService()
                                            .checkExistanceofChannel(
                                                senderid, receiverid);

                                        MessageService().sendMessagetoDatabase(
                                            chatRoomId, model);

                                        controller.clear();

                                        setState(() {
                                          someThingWritten = false;
                                          if (scrollController.hasClients) {
                                            scrollController.animateTo(
                                                scrollController
                                                    .position.maxScrollExtent,
                                                curve: Curves.easeOut,
                                                duration: Duration(
                                                    milliseconds: 200));
                                          }
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    showemoji
                        ? EmojiPicker(
                            onEmojiSelected: (emoji, category) {
                              setState(() {
                                controller.text = controller.text + emoji.emoji;
                                someThingWritten = true;
                              });
                            },
                            rows: 3,
                            columns: 7,
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
