

import 'package:cloud_firestore/cloud_firestore.dart';

class People {

late String photo;
late String userid;
late String name;

People(
  {
    required this.photo,
    required this.userid,
    required this.name
  }
);

People.fromDocumentsnapshot(DocumentSnapshot documentSnapshot){

  photo=documentSnapshot.get("Photourl");
  userid=documentSnapshot.get("user_id");
   name=documentSnapshot.get("name");
}
  
}
