
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StoryServices{

final userid=FirebaseAuth.instance.currentUser!.uid.toString();
String? username;


CollectionReference _storyCollection=FirebaseFirestore.instance.collection("Story");
Map<String,dynamic>sendData=Map<String,dynamic>();

Future uploadToFirebaseStorage(File file)async{
  String getDownloadurl;

await FirebaseStorage.instance.ref().child("Stories/$file").putFile(file);

String currentTime=DateTime.now().millisecondsSinceEpoch.toString();
Map <String ,String> setData=Map <String ,String>();

getDownloadurl=await FirebaseStorage.instance.ref().child("Stories/$file").getDownloadURL();

await FirebaseFirestore.instance.collection("users").doc(userid).get().then((value) {

  username=value.get("name");
});
print(getDownloadurl);
sendData={

  "user_id":userid,
  "username":username,
  "storyLink":getDownloadurl,
  "uploadTime":currentTime,
};
setData={
  "UserID":userid,
};
_storyCollection.doc(userid).set(setData);
_storyCollection.doc(userid).collection("Stories").add(sendData);




}
 uploadStory(Map<String,String>mystory)async{
await _storyCollection.doc(userid).collection("MyStories").add(mystory);

}

Future getFriends()async{
 
 Map<dynamic ,dynamic> listFreinds= Map<dynamic ,dynamic >();
 List savefriends=[];
 List friendsnames=[];
 var username;

await FirebaseFirestore.instance.collection("Friends").doc(userid).get().then((value) {


  if(value.data()!=null){
  listFreinds=value.data() as Map;
 listFreinds.values.forEach((element) {
   savefriends.add(element);
 });
  }



 });



return savefriends;

}

Future getAllStoriesForFriends( user)async{

 
  return  FirebaseFirestore.instance.collection("Story")
   .doc(user)
   .collection("Stories")
   .snapshots();



}

Future getUserInfo(user) async {


  return FirebaseFirestore.instance.collection("users").doc(user).snapshots();  
}

Future getMyStory(currentuserid) async {


  return FirebaseFirestore.instance.collection("Story")
  .doc(currentuserid)
  .collection("Stories")
  .snapshots();
  
}
}