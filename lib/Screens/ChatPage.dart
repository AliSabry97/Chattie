import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Screens/ChatScreen.dart';
import 'package:ecommerce_app/services/MessageService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatsPage extends StatefulWidget {
  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  Stream<QuerySnapshot>? chatroomsStream;
  Stream<QuerySnapshot>? lastmessage;
  Stream<QuerySnapshot>? imgurl;

  var sendername,senderid,receiverName,reciverid,img;


  String imgphoto = ""; 
  var currentuserid = FirebaseAuth.instance.currentUser!.uid;
 var finalreciverid;
   
  
  var currentusername;
  @override
  void initState() {
    super.initState();
    retrieverooms();
  }


  Future retrieverooms() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentuserid)
        .get()
        .then((value) {
      currentusername = value.get("name");

      MessageService().getchatRooms(currentuserid).then((value) {
        if (mounted) {
          setState(() {
            chatroomsStream = value;
          });
        }
      });
    });
  }

  Future getlastmessage(roomname) async {
    await MessageService().getlastMessage(roomname).then((value) {
      if (mounted) {
        setState(() {
          lastmessage = value;
        });
      }
    });
  }

 

  Future getLastUpdatedImage(recieveruid) async {
    
    await MessageService().getUserImage(recieveruid).then((value) {
      if (mounted) {
        setState(() {
          imgurl = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Color.fromRGBO(16, 45, 49, 30),
      child: StreamBuilder<QuerySnapshot>(
        stream: chatroomsStream,
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting)
          {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 10,
              ),
            );
          }
          return snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) {
                            
                    var roomname =
                        snapshot.data!.docs[index].get("chatRoomId").toString();
                        

                    List reciverid;

                    reciverid = snapshot.data!.docs[index].get("users");
                   
                    if (reciverid.first == currentuserid) {
                     
                     
                       finalreciverid = reciverid.elementAt(1);
                       
                    
                      
                    } else {
                     
                        finalreciverid=reciverid.elementAt(0);
                      
                                        
                    }
               
                    
                    return Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                       
                        
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: StreamBuilder<QuerySnapshot>(
                                 stream: FirebaseFirestore.instance .collection("users").where("user_id",isEqualTo: finalreciverid) .snapshots(),
                                 
                                builder: (context, snapimage) {
                                
                                  
                                   if (snapimage.hasData ) {
                                   
                                
                                      imgphoto=snapimage.data!.docs.first.get("Photourl");
                                                       
                                    return ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: snapimage
                                                        .data!.docs.first
                                                        .get("Photourl")
                                                        .toString() ==
                                                    ""
                                                ? AssetImage(
                                                    "assets/images/avatar.jpg")
                                                : NetworkImage(imgphoto)
                                                    as ImageProvider,
                                            radius: 30,
                                          ),
                                          title: Row(
                                           
                                            children: [
                                              Text(
                                                "${roomname.toString().replaceAll("-", "").replaceAll(currentusername, "")}",
                                                style:
                                                    GoogleFonts.sourceSansPro(
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromRGBO(
                                                            251, 251, 251, 20)),
                                              ),
                                            ],
                                          ),
                                        );
                                    
                                      
                                  }
                                  else
                                      return Container();
                                    
                                },
                               
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream:  FirebaseFirestore.instance.collection("ChatRoom").doc(roomname.toString()).collection("chats") .orderBy("sentat",descending: false).limitToLast(1) .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var sentat=int.parse(snapshot.data!.docs.elementAt(0).get("sentat"));
                          
                                  Timestamp timestamp=Timestamp.fromMillisecondsSinceEpoch(sentat);
                                  DateTime dateTime=timestamp.toDate();
                                  return InkWell(
                                    onTap: () {
                                            Get.off(() => ChatScreen(
                                                senderid: snapshot.data!.docs.elementAt(0).get("senderid"),
                                                senderusername: snapshot.data!.docs.elementAt(0).get("sendername"),
                                                receiverid: snapshot.data!.docs.elementAt(0).get("reciverid"),
                                                receiverusername: roomname.toString().replaceAll("-", "").replaceAll( currentusername, ""),
                                                img:imgphoto));
                                          },
                                    child: Container(
                                          child: Row(
                                             mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 80),
                                                  child: Text(
                                                    
                                                    "${snapshot.data!.docs.elementAt(0).get("messagebody")}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                        maxLines:1,
                                                    style:
                                                        GoogleFonts.sourceSansPro(
                                                      fontSize: 16.0,
                                                      color: Colors.grey.shade400,
                                                    ),
                                                    
                                                                                           
                                                  ),
                                                ),
                                              ),
                                           
                                              Text(
                                                "${dateTime.toString().substring(10,16)}",
                                                style:
                                                    GoogleFonts.sourceSansPro(
                                                  fontSize: 16.0,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                  
                )
              : Container();
        },
      ),
    );
  }
}
