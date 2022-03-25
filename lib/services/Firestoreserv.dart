import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'dart:async';
import 'package:firebase_storage/firebase_storage.dart';

class Firestoreservice{

  CollectionReference users=FirebaseFirestore.instance.collection("users");
  CollectionReference requests=FirebaseFirestore.instance.collection("requests");
  CollectionReference friends=FirebaseFirestore.instance.collection("Friends");

  //
    Reference firebaseStorage=FirebaseStorage.instance.ref();

  final List users_list=[];
   final List finalUsersList=[];

  final List getCounts=[];
  var object;
  List request_list=[];
  late String photourl;
  late String name;
    

  HashMap<String,String> request=HashMap<String,String>();

User? user=FirebaseAuth.instance.currentUser;


  Future<void> addUserToFirestore(UserModel userModel)
  async {

   return await users.doc(userModel.userid).set(userModel.toJson());
    
  }
Future get_users()async
{
  final String  userid=user!.uid;
    return  users.
     where("user_id",isNotEqualTo: userid)
     .snapshots();

        
}
  
Future sendFriendRequest(String askedid) async{
  final String? user_id=user!.uid;


  if(user_id!=null)
  {
    int count=0;
    Map<dynamic,dynamic> key=Map<String,dynamic> ();
    await requests.doc(askedid).get().then((DocumentSnapshot documentSnapshot) async {

      if(documentSnapshot.exists)
      {
       
        key.addAll(documentSnapshot.data()as Map);
      
        count=key.length;
      
      try{

        request[count.toString()]=user_id;
        await requests.doc(askedid).update(request);

      }catch(e)
      {
          print("you got an Error ! $e" );
      }


      }
      
      else
      {
        request['0']=user_id;
      
      
      try{

    await requests.doc(askedid).set(request);


      }catch(e){


        print("you got an Error! $e");
      }
        
      }
    });
  }
  
  }


Future checkFriendRequest(onetosearch ,onetocheck) async {
  bool isFound=false;
  
  Map <dynamic,dynamic> fetchRequests=Map <dynamic,dynamic> ();

 
  
   

    try{
      await requests.doc(onetosearch).get().then((DocumentSnapshot doc){


        if(doc.exists)
        fetchRequests.addAll(doc.data()as Map);
        else
        {
        isFound=false;
        return isFound;
        }


  } );

    }
    catch(e)
    {
      print("You Got An Error! $e");
    }

  fetchRequests.forEach((key, value) {
    if(value==onetocheck)
    isFound=true;
  });
 return isFound;
}


Future removeFriendRequest(firstuser,seconduser)async
{ 



  Map<dynamic,dynamic> fetch_request= Map<dynamic,dynamic>();
  await requests.doc(firstuser).get().then((DocumentSnapshot documentSnapshot) {

    if(documentSnapshot.exists)
    {
      fetch_request.addAll(documentSnapshot.data() as Map);

    }

  
    fetch_request.forEach((key, value) {
      
      if(value==seconduser)
      {
           requests.
           doc(firstuser).update({'$key':FieldValue.delete()}).then((value) => print("Successfully deleted From Request List"))
          .catchError((error)=>print("Failed to delete From Request List"));

              
      
    }});
    

} );
}




Future getIDs()async
{
  Map <dynamic,dynamic> getUids=Map<dynamic,dynamic>();


  String userID=user!.uid;

 await requests.doc(userID).get().then((DocumentSnapshot doc) async {

    if(doc.exists)
    {

      getUids.addAll(doc.data() as Map);
    
    }
      } );
    
  return getUids;

}

Future fetchRequests()async
{

  List<String> usersidlist=[];
  final usersDataList=[];
 
  Map<dynamic,dynamic> getuids;
  getuids=await getIDs();

 getuids.values.forEach((element) {
   
   usersidlist.add(element);
 });
  
   try{

     await users.where("user_id",whereIn: usersidlist).get().then((value) {


       value.docs.forEach((element) {
         
         usersDataList.add(element.data());
         

       });
     });

  return usersDataList;
     
   }catch(e)
{

  print("you got an error:  $e ");
}
   
   
   

}



Future uploadToDatabase(file)async
{
  String?userID=user!.uid;


   await firebaseStorage.child("images/$userID/profilepic").putFile(file);
   String downloadurl=await firebaseStorage.child("images/$userID/profilepic").getDownloadURL();

  await  users.doc(userID).update({"Photourl":downloadurl});

  return downloadurl;
}


  Future readPhotourl() async
  {
    String?userID=user!.uid;
        String url;
        DocumentSnapshot snapshot= await users.doc(userID).get();
        
        url=snapshot.get("Photourl");
        return url;
  }


   Future acceptRequest(requestuser) async{
  String userId=FirebaseAuth.instance.currentUser!.uid;

  
  

  

  int counter=0;

  Map<dynamic,dynamic> friendscurrentuserMap= Map<dynamic,dynamic>();
  Map<String,String> friendsCurrentUserList=Map<String,String>();
   Map<dynamic,dynamic> friendsRequestuserMap= Map<dynamic,dynamic>();
  Map<String,String> friendsRequestUserList=Map<String,String>();
 friends.doc(userId).get().then((DocumentSnapshot doc) async {

   if(doc.exists){

    friendscurrentuserMap= doc.data() as Map;
    counter=friendscurrentuserMap.length;

    try{


    friendsCurrentUserList[counter.toString()]=requestuser;

    await friends.doc(userId).update(friendsCurrentUserList).then((value) async{
     await removeFriendRequest(userId, requestuser);
     await removeFriendRequest(requestuser, userId);

    });
    


    }catch(e)
   {

     print("you Got and Error in accepting Freind $e");
   }

   }
   else
   {

     friendsCurrentUserList['0']=requestuser;
     await friends.doc(userId).set(friendsCurrentUserList);
     await removeFriendRequest(userId, requestuser);
     await removeFriendRequest(requestuser, userId);


   }
 });



//for other user establish him in database
 friends.doc(requestuser).get().then((DocumentSnapshot doc) async {

   if(doc.exists){

    friendsRequestuserMap= doc.data() as Map;
    counter=friendsRequestuserMap.length;

    try{


    friendsRequestUserList[counter.toString()]=userId;

    await friends.doc(requestuser).update(friendsRequestUserList).then((value) async{
     await removeFriendRequest(userId, requestuser);
     await removeFriendRequest(requestuser, userId);

    });
    


    }catch(e)
   {

     print("you Got and Error in accepting Freind $e");
   }

   }
   else
   {

     friendsRequestUserList['0']=userId;
     await friends.doc(requestuser).set(friendsRequestUserList);
     await removeFriendRequest(userId, requestuser);
     await removeFriendRequest(requestuser, userId);


   }
 });
}


Future checkFriendShipBetweenUs(firstuser,otheruser)async
{
  Map<dynamic,dynamic> fetchData=Map<dynamic,dynamic>();
  bool friendstatus=false;

  await friends.doc(firstuser).get().then((DocumentSnapshot doc){

if(doc.exists){

fetchData.addAll(doc.data()as Map);

}
});


fetchData.values.forEach((element) {
  
  if(element==otheruser)
  {
    friendstatus=true;
    
  }
});
return friendstatus;
}

 

}