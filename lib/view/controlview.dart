import 'package:ecommerce_app/Home/HomeScreen.dart';
import 'package:ecommerce_app/view/Auth/Login_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ControlView extends StatelessWidget {
  final User? user =FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

   if(user!=null)
   {
     return HomeScreen();
   }
   else
   return LoginScreen();
   
}
}