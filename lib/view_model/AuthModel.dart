
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Home/HomeScreen.dart';
import 'package:ecommerce_app/Model/UserModel.dart';
import 'package:ecommerce_app/services/Firestoreserv.dart';
import 'package:ecommerce_app/view/Auth/Login_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends GetxController{
final GoogleSignIn googleSignIn =  GoogleSignIn(scopes: ['email']);
 final FirebaseAuth firebaseAuth=  FirebaseAuth.instance;
  late GoogleSignInAccount googleSignInAccount;
  Reference firebaseStorage=FirebaseStorage.instance.ref();

  //Rx Data
  late  Rx<User?> _user;
  var isImageProfileSet=false.obs;
  var profileImagePath="".obs;
   File? file;

  User? get currentUser =>_user.value; 
 


  //for email and password
   String email="";
   String password="";
   String name="";
   String phone="";

  @override
  void onReady() {
    super.onReady();
    _user=Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user,setInitialScreen );
  }
  setInitialScreen(User? user){
      if(user==null){
      Get.offAll(()=>LoginScreen());
    }
    else
    Get.offAll(()=>HomeScreen());
  }
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
    SharedPreferences profileprefs=await SharedPreferences.getInstance();
    

    await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)  .then((value)  async {

      UserModel usermodel=UserModel(userid: value.user!.uid, email: email, name: name, phone: phone, photourl: "");
      
  
      await Firestoreservice().addUserToFirestore(usermodel);
          if(isImageProfileSet.value==true){
        uploadImagetoDatabase(value.user!.uid,file);
        profileprefs.setString(value.user!.uid,profileImagePath.value );
      }
    });
  

    Get.offAll(()=>HomeScreen());

  }catch(e)
  {

    Get.snackbar("User is Already Signed Up", e.toString(),snackPosition: SnackPosition.BOTTOM);

  }
}
void selectImage()async{
  final imageChosen;
 
 
  imageChosen=await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 100);
  if(imageChosen!=null){
file=File(imageChosen.path);
  profileImagePath.value=file!.path;
  isImageProfileSet.value=true;


  }
}
  Future uploadImagetoDatabase(userID,profile)async{
   


   await firebaseStorage.child("images/$userID/profilepic").putFile(profile);
   String downloadurl=await firebaseStorage.child("images/$userID/profilepic").getDownloadURL();
  await  FirebaseFirestore.instance.collection("users").doc(userID).update({"Photourl":downloadurl});
return downloadurl;
  }


  Future resetPassword(email)async{

  try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email:email ).then((value) {
      Get.snackbar("ResetPassword", "An Email Sent With Password Reset Process" ,duration: Duration(seconds: 3),snackPosition: SnackPosition.BOTTOM);
    });
  }catch(e){
    Get.snackbar("Error Message","please Enter Valid Email Address" ,duration: Duration(seconds: 3) ,snackPosition: SnackPosition.BOTTOM);
  }
  }

}




 



