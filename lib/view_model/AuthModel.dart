
import 'package:ecommerce_app/Home/HomeScreen.dart';
import 'package:ecommerce_app/Model/UserModel.dart';
import 'package:ecommerce_app/services/Firestoreserv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewModel extends GetxController{
final GoogleSignIn googleSignIn =  GoogleSignIn(scopes: ['email']);
 final FirebaseAuth firebaseAuth=  FirebaseAuth.instance;
  late GoogleSignInAccount googleSignInAccount;



  //for email and password
   String email="";
   String password="";
   String name="";

   @override
  void onInit() {
  
    super.onInit();
  }


void googlesigninmethod() async
{



try
{
 

   final googleUser= await googleSignIn.signIn();
   if (googleUser!=null)
   {
     googleSignInAccount=googleUser;

   }

   GoogleSignInAuthentication googleAuth=await googleSignInAccount.authentication ;

   AuthCredential credential= GoogleAuthProvider.credential(
     accessToken: googleAuth.accessToken,
     idToken: googleAuth.idToken,
   );

   firebaseAuth.signInWithCredential(credential);
   print(credential);
   
}catch(e)
{

  print(e.toString());
}
}

void signInWithEmailAndPassword()async 

{
  
  
  try
  {

   
    await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    Get.offAll(()=>HomeScreen());

  }
  catch(e)
  {
    Get.snackbar("Error Login account", e.toString(),colorText: Colors.black,snackPosition: SnackPosition.BOTTOM);
    
  }


}


void registerInDatabase() async
{

  try{

    await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)
    .then((value)  async {

      UserModel usermodel=UserModel(userid: value.user!.uid, email: email, name: name, phone: "", photourl: "");
      await Firestoreservice().addUserToFirestore(usermodel);
    });
    Get.offAll(()=>HomeScreen());

  }catch(e)
  {

    Get.snackbar("User is Already Signed Up", e.toString(),snackPosition: SnackPosition.BOTTOM);

  }
}




 

}

