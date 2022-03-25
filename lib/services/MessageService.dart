import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Model/MessageModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageService{

String senderid=FirebaseAuth.instance.currentUser!.uid;


Future createChatRoom(String chatRoomid,Map<String,dynamic> chatRoomData)async{

await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomid).set(chatRoomData);
}



Future sendMessagetoDatabase(String chatRoomid,MessageModel messageModel)async
{

try{

  FirebaseFirestore.instance.collection("ChatRoom")
  .doc(chatRoomid).collection("chats").add(messageModel.toJson());

}catch(e)
{

  Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_SHORT);
}
}

Future readMessages(chatRoomid)async{
  
  return  FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomid).collection("chats")
  .orderBy("sentat",descending: false)
  .snapshots();


}

Future <String> checkExistanceofChannel(senderid,reciverid)async{
  
  var chatchhanel="";
    
  
                 
                                 
 await FirebaseFirestore.instance.collection("ChatRoom").where('users',isEqualTo: [senderid,reciverid]).get().then((QuerySnapshot querySnapshot)  {

   if(querySnapshot.docs.isNotEmpty)

   {
      querySnapshot.docs.forEach((element) {
       chatchhanel= element.get("chatRoomId");
    

     });
   }
   
   
 });


 if(chatchhanel==""){
await FirebaseFirestore.instance.collection("ChatRoom").where('users',isEqualTo: [reciverid,senderid]).get().then((QuerySnapshot querySnapshot)  {

   if(querySnapshot.docs.isNotEmpty)

   {
      querySnapshot.docs.forEach((element) {
       chatchhanel= element.get("chatRoomId");

     });
   }
   
   
 });

 }

   return chatchhanel;

}


Future getchatRooms(cuurentuser)async{


  return  FirebaseFirestore.instance.
  collection("ChatRoom")
  .where('users',arrayContainsAny:[cuurentuser] )
  .snapshots();
}

Future getlastMessage(chatroomid)async{

  return   FirebaseFirestore.instance.
  collection("ChatRoom")
  .doc(chatroomid)
  .collection("chats")
  .orderBy("sentat",descending: false)
  .limitToLast(1)
  .snapshots();


}

 Future  getUserImage(recieveruid) async {

    return  FirebaseFirestore.instance
        .collection("users")
        .where("user_id",isEqualTo: recieveruid)
        .snapshots();

      

  }



}





