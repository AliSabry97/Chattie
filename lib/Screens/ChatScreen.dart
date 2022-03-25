import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Home/HomeScreen.dart';
import 'package:ecommerce_app/Model/MessageModel.dart';
import 'package:ecommerce_app/services/MessageService.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool showemoji=false;
  ScrollController scrollController = ScrollController();
  String img;
  late bool isSendByMe;
  FocusNode _focusNode=FocusNode();
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
      if(_focusNode.hasFocus){

        setState(() {
          showemoji=false;
        });
      }
    });
  }





  void getMessages() async {
            chatRoomId= await MessageService().checkExistanceofChannel(senderid, receiverid);
            
            if(chatRoomId!="")
            {
 await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).get().then((DocumentSnapshot documentSnapshot) {

      if(documentSnapshot.exists)
      {

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
        backgroundColor: Color.fromRGBO(21, 22, 45, 20),
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Text(
                        "online",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: (){
          if(showemoji){
            setState(() {
              showemoji=false;
            });
          }
          else
          {
            Navigator.pop(context);

          }
          return Future.value(false);
        },
        child: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: chatMessageStream,
              builder: (context, snapshot) {
             
                return snapshot.hasData
                    ? ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: snapshot.data!.docs.length + 1,
                        itemBuilder: (context, index) {
                          if (index == snapshot.data!.docs.length) {
                            return Container(
                              height: 70,
                            );
                          }
                          var sender = snapshot.data!.docs[index].get('senderid');
                          if (sender == FirebaseAuth.instance.currentUser!.uid.toString()) {
                           
                             isSendByMe = true; 
                            
                          } else
                          {
                            
                               isSendByMe = false;
                            
                          }
                           
                       
      
                          var messageToShow =
                              snapshot.data!.docs[index].get('messagebody');
                              print(messageToShow);
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            padding: EdgeInsets.only(
                                left: isSendByMe ? 0 : 24,
                                right: isSendByMe ? 24 : 0),
                            alignment: isSendByMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 24),
                              decoration: BoxDecoration(
                                color: isSendByMe ? Colors.blue : Colors.black,
                                borderRadius: isSendByMe
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(23),
                                        bottomLeft: Radius.circular(23),
                                        topRight: Radius.circular(23),
                                      )
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(23),
                                        topRight: Radius.circular(23),
                                        bottomRight: Radius.circular(23),
                                      ),
                              ),
                              child: isSendByMe
                                  ? Text(
                                      "$messageToShow",
                                      style: GoogleFonts.sourceSansPro(
                                          color: Colors.white),
                                    )
                                  : Text(
                                      "$messageToShow",
                                      style: GoogleFonts.sourceSansPro(
                                          color: Colors.white),
                                    ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                            "No Messages to Show Please Send Your First Message!!!"),
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
                        padding: EdgeInsets.only(left: 4, bottom: 4, right: 4),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(43, 50, 59, 20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
      
                                setState(() {
                                _focusNode.unfocus();
                                _focusNode.canRequestFocus=false;
                                  showemoji=true;
                                });
                              },
                              icon: Icon(
                                Icons.emoji_emotions_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                focusNode: _focusNode,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Message",
                                  hintStyle: TextStyle(color: Colors.white54),
                                  focusColor: Colors.white,
                                  border: InputBorder.none,
                                ),
                                cursorColor: Colors.white12,
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
                padding: const EdgeInsets.only(right: 4.0, bottom: 3),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(21, 22, 45, 20),
                    maxRadius: 25,
                    child: IconButton(
                      icon: someThingWritten ? sendIcon : micIcon,
                      color: Colors.white,
                      onPressed: () async {

                      
                        if (someThingWritten) {
                          MessageModel model = MessageModel(
                            loggedUserID: senderid,
                            loggedUserName: senderusername,
                            receiverID: receiverid,
                            receiverName: receiverusername,
                            messageBody: controller.text,
                            sentAt:
                               DateTime.now().millisecondsSinceEpoch.toString(),
                          );
                           
                          
                          if (controller.text.isNotEmpty) {

                          var  chatid= await MessageService().checkExistanceofChannel(senderid, receiverid);
                   if(chatid=="")
                   {
                     List users=[senderid,receiverid];
                         var roomid=senderusername+"-"+receiverusername;

                     Map<String,dynamic> chatRoomData=Map<String,dynamic>();
                    chatRoomData={
                      'users':users,
                      'chatRoomId':roomid,

                    };

                    MessageService().createChatRoom(roomid, chatRoomData);
                   }

                     chatRoomId=await MessageService().checkExistanceofChannel(senderid,receiverid);
                  
                            MessageService()
                                .sendMessagetoDatabase(chatRoomId, model);
                                
                                 
                            controller.clear();

                            setState(() {
                              someThingWritten = false;
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
                  showemoji? EmojiPicker(onEmojiSelected: (emoji,category){
                    setState(() {
                      controller.text=controller.text+emoji.emoji;
                      someThingWritten=true;
                    });
                  },rows: 3,columns: 7,): Container(),
                
                ],
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}

//
