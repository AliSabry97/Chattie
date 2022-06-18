
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Screens/ChatPage.dart';
import 'package:ecommerce_app/Screens/Peoplepage.dart';
import 'package:ecommerce_app/Screens/ProfileScreen.dart';
import 'package:ecommerce_app/Screens/RequestPage.dart';
import 'package:ecommerce_app/Screens/Statuspage.dart';
import 'package:ecommerce_app/services/Firestoreserv.dart';
import 'package:ecommerce_app/view/Auth/Login_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with  WidgetsBindingObserver {
late  SharedPreferences sharedPreferences;
  
   String imageUrl="";
   File? file;
   String userID=FirebaseAuth.instance.currentUser!.uid;
    String status="offline";
  CollectionReference users=FirebaseFirestore.instance.collection("users");
  


 FirebaseAuth _auth=FirebaseAuth.instance;
 


@override
  void initState() {
    
    status="online";
    WidgetsBinding.instance!.addObserver(this);
    loadphoto();
    super.initState();

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    
    super.didChangeAppLifecycleState(state);
    if(state==AppLifecycleState.resumed){

      status="online";
      setStatus(status);
      
    }
    else
    {
      status="offline";
  setStatus(status);
    }
    
  }

  void setStatus(String status)async{

   await users.doc(userID).update(
      {
"status":status,
      }
      
    );

  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(5,80,82,10),
            bottom: TabBar(tabs: [
              Tab(
                text: "Chats",
              ),
              Tab(
                text: "Status",
              ),
              Tab(
                text: "People",
              ),
            ]),
            elevation: 0,
            title: Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Text(
                  "Chattie",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                )),
            actions: [
              Icon(Icons.add),
            ],
          ),
          drawer: Drawer(
          
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Color.fromRGBO(16, 45, 49, 30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                      
                        backgroundImage: (imageUrl=="" )?AssetImage("assets/images/avatar.jpg") :NetworkImage(imageUrl) as ImageProvider,
                                      
                        radius: 42.0, 
                       
                      ),
                     
                    ],
                  ),
                ),
                
                InkWell(
                  splashColor: Colors.blueAccent,
                  mouseCursor: MaterialStateMouseCursor.clickable,
                    onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen())).then((value) {

                        setState(() {
                          loadphoto();
                        });

                    });
                  
                  },
                  child: ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text("Profile"),
                    selected: true,
                    
                    
                  ),
                ),
                InkWell(
                  onTap: (){

                    Get.off(()=>RequestPage());
                  },
                  child: ListTile(
                    leading: Icon(Icons.message),
                    title: Text("Friend Requests"),
                    selected: true,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                  selected: true,
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  selected: true,
                  onTap: () async {
                    try {
                      await _auth.signOut();
                      Get.offAll(() => LoginScreen());
                    } catch (e) {
                      print("Can't log out");
                    }
                  },
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(children: [
                  ChatsPage(),
                  StatusPage(),
                  PeoplePage(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

 


Future loadphoto()async
 {
   String img;
  img=await Firestoreservice().readPhotourl();

  if(img.isNotEmpty&& mounted)
  {
    setState(() {
      imageUrl=img;
    });
  }
  
 }


 
}
