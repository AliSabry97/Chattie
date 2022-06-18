
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Screens/ChatScreen.dart';
import 'package:ecommerce_app/Widgets/CustomeButton.dart';
import 'package:ecommerce_app/services/Firestoreserv.dart';
import 'package:ecommerce_app/view_model/AuthModel.dart';
import 'package:ecommerce_app/view_model/SinglePerson_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SinglePerson extends StatelessWidget {
  final String img;
  final String name;
  final String askeduid;

  SinglePerson({
    required this.img,
    required this.name,
    required this.askeduid,
  });


  late double height;
  
 String senderusername="";

 
  String user = FirebaseAuth.instance.currentUser!.uid;

  

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(16, 45, 49, 30),
        title: Text("$name Profile "),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height:  MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(16, 45, 49, 30),
              Color.fromRGBO(16, 45, 49, 30),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Container(
          child: GetX(
            init: Get.put<SinglePersonController>(SinglePersonController(onetosearch: user, onetocheck: askeduid)),
            builder: (SinglePersonController singleperson)
            {
              return  SingleChildScrollView(
                child: Column(
                children: [
                  img.isEmpty
                      ? Container(child: Image.asset("assets/images/avatar.jpg" ,height: MediaQuery.of(context).size.height/2,width: 350,))
                      : Container(
                          child: Image.network(img),
                          height: 400,
                          width: MediaQuery.of(context).size.width,
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      color: Color.fromRGBO(212, 212, 212, 20),
                    ),
                    
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  
                         
                                      
                               CustomButton(
                                             width: 220,
                                             height: 40,
                                             
                                             text: singleperson.buttonstring,
                                             color: Color.fromRGBO(16, 45, 49, 30),
                                         
                                             onpress: () {
                            if (singleperson.buttonstring== "Add Friend") {
                              Firestoreservice().sendFriendRequest(askeduid);
                              singleperson.btnTxt.value="Cancel Request";
                            } 
                            else if (singleperson.buttonstring == "Cancel Request") {
                             
                              Firestoreservice().removeFriendRequest(user, askeduid);
                              Firestoreservice().removeFriendRequest(askeduid, user);
                              singleperson.btnTxt.value="Add Friend";
                            
                            } else if(singleperson.buttonstring=="Accept Request") {
                              
                              Firestoreservice().acceptRequest(askeduid);
                              singleperson.btnTxt.value="Send Sms";
                              singleperson.btnVisible.value=false;
                            }
                            else if(singleperson.buttonstring=="Send Sms")
                            {
                            
                              var userimage=img;
                            
                                         
                              Get.offAll(()=>ChatScreen(senderid: user, senderusername:senderusername,receiverid: askeduid,receiverusername: name.toString(),img: userimage,),);
                             
                            }
                                           
                                             },
                                             borderradius: 15.0,
                                             textstyle:GoogleFonts.sourceSansPro(
                            textStyle: TextStyle(fontSize: 20),
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                                             ),
                                           ),
                             
                  
                         SizedBox(
                  height: 30,
                ),   
                         Visibility(
                  visible: singleperson.buttonstring=="Accept Request"?true:false,
                  child: CustomButton(
                    text: "Refuse Request",
                    onpress: () {
                
                      Firestoreservice().removeFriendRequest(user, askeduid);
                      singleperson.btnTxt.value="Add Friend";
                      singleperson.btnVisible.value=false;
                    
                    },
                    textstyle: GoogleFonts.sourceSansPro(
                      textStyle: TextStyle(fontSize: 20),
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    height: 40,
                    width: 220,
                    borderradius: 25,
                    color: Color.fromRGBO(16, 45, 49, 30),
                  ),
                ),
                     
                ]
                )
                       );
       
      
            }
        ),
      ),
      )
    );
  }
}
