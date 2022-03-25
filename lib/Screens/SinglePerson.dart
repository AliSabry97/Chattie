import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Constants/MyColors.dart';
import 'package:ecommerce_app/Screens/ChatScreen.dart';
import 'package:ecommerce_app/Widgets/CustomeButton.dart';
import 'package:ecommerce_app/services/Firestoreserv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SinglePerson extends StatefulWidget {
  final String img;
  final String name;
  final String askeduid;

  SinglePerson({
    required this.img,
    required this.name,
    required this.askeduid,
  });
  @override
  _SinglePersonState createState() => _SinglePersonState(img, name, askeduid);
}

class _SinglePersonState extends State<SinglePerson> {
  CollectionReference users=FirebaseFirestore.instance.collection("users");
  


  late double height;
  late String img;
  late String name;
  final String askeduid;
  String btn_text = "Add Friend";
  String senderid=FirebaseAuth.instance.currentUser!.uid;
 String senderusername="";
  bool friendShipChecked = false;
  bool btnVisible=false;
  String user = FirebaseAuth.instance.currentUser!.uid;
  _SinglePersonState(this.img, this.name, this.askeduid);

  Future getSendername()async{
    await users.doc(senderid).get().then((value) {
   
    senderusername=value.get('name');
    });
    return senderusername;
  }

  @override
  void initState() {
    super.initState();
    checkFriendRequest();
    checkFriendShip();
    getSendername();
  }
  void checkFriendShip()async
  {

    bool friendstatus;
    friendstatus=await Firestoreservice().checkFriendShipBetweenUs(user,askeduid);
 
    if(friendstatus)
    {
      setState(() {
        btnVisible=false;
        btn_text="Send Sms";
      });
      
    }
    else
    {
      bool checkagain=false;
     checkagain= await Firestoreservice().checkFriendShipBetweenUs(askeduid, user);
     if(checkagain){

       setState(() {
         btnVisible=false;
         btn_text="Send Sms";
       });
     }
   
  
   
  }
  }

  void checkFriendRequest() async {
    bool check;
    bool btnflag;
    check = await Firestoreservice().checkFriendRequest(askeduid, user);
    btnflag = await Firestoreservice().checkFriendRequest(user, askeduid);
    setState(() {
      friendShipChecked = check;
      if (friendShipChecked) {
        btn_text = "Cancel Request";

      } else if (friendShipChecked == false) {
        if (btnflag) {
          setState(() {
            btnVisible=true;
          });
          btn_text = "Accept Friend Request";
        } 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(16, 45, 49, 30),
        title: Text("$name Profile "),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
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
                child: Text(
                  "$name",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              CustomButton(
                width: 220,
                height: 40,
                
                text: btn_text,
                color: Color.fromRGBO(16, 45, 49, 30),

                onpress: () {
                  if (btn_text == "Add Friend") {
                    Firestoreservice().sendFriendRequest(askeduid);
                    setState(() {
                      btn_text = "Cancel Request";
                    });
                  } else if (btn_text == "Cancel Request") {
                    Firestoreservice().removeFriendRequest(user, askeduid);
                    Firestoreservice().removeFriendRequest(askeduid, user);
                    setState(() {
                      btn_text = "Add Friend";
                    });
                  } else if(btn_text=="Accept Friend Request") {

                  
                    Firestoreservice().acceptRequest(askeduid);
                    setState(() {
                      
                      btn_text="Send Sms";
                      btnVisible=false;
                    });
                
                  }
                  else if(btn_text=="Send Sms")
                  {
                  
                    var userimage=img;

                    Get.offAll(()=>ChatScreen(senderid: senderid, senderusername:senderusername,receiverid: askeduid,receiverusername: name.toString(),img: userimage,));
                   
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
                visible: btnVisible?true:false,
                child: CustomButton(
                  text: "Refuse Request",
                  onpress: () {

                    Firestoreservice().removeFriendRequest(user, askeduid);
                    setState(() {
                      btnVisible=false;
                      btn_text="Add Friend";
                    });
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
            ],
          ),
        ),
      ),
    );
  }
}
