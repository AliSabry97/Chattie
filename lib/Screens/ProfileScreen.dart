import 'dart:io';

import 'package:ecommerce_app/Home/HomeScreen.dart';
import 'package:ecommerce_app/view_model/AuthModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  

 
  late double height;
  late double width;
  int counter=0;
 
  String imagePath="";


  @override
  Widget build(BuildContext context) {
    
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color.fromRGBO(16, 45, 49, 30),
        title: Text(" Profile "),
        leading: BackButton(color: Colors.white,onPressed: ()  { Get.offAll(()=>HomeScreen());},),
      ),
      body: Container(
        width: width,
        height: height,
       
        decoration: BoxDecoration(
         color:Color.fromRGBO(16, 45, 49, 30),
        ),
        child: GetX(
          builder:(AuthViewModel authviewmodel){
            return Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image(
                      height: 400.0,
                      width: width,
                      fit: BoxFit.cover,
                      image:authviewmodel.isImageProfileSet.value==true?FileImage(File(authviewmodel.profileImagePath.value))as ImageProvider: AssetImage("assets/images/avatar.jpg")
                  ),
              ),
              SizedBox(
                height: 30,
              ),
        
               
             Container(
               width: MediaQuery.of(context).size.width-50,
               child: TextButton(
                                onPressed: () {
                                 authviewmodel.selectImage();
                                },
                                child: Text(
                                  ("Change Profile Photo"),
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(16, 45, 49, 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(width: 1),
                                    
                                  ),
                                  primary: Colors.black,
                                  textStyle: TextStyle(fontSize: 15.0),
                                ),
                              ),
             ),
            ],
          );
          }
          
        ),
      ),
    );
  }
 
}
