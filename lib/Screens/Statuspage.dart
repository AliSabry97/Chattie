import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Screens/StoryPageView.dart';
import 'package:ecommerce_app/services/StoryServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_designer/story_designer.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPage();
}

class _StatusPage extends State<StatusPage> {
  String curentLoggedInUser = FirebaseAuth.instance.currentUser!.uid.toString();
  Stream<DocumentSnapshot>? _currentphoto;
  Stream<QuerySnapshot>? getstories;
  String? user_name, img_link;
  Stream<QuerySnapshot>? mystory;

  List getFriendUsers = [];
  List getusernmes = [];
  String photoUrl = "";

  @override
  void initState() {
    super.initState();
    getcurrentPhoto();
    getFriends();
    getmystory();
  }

  getmystory() async {
    StoryServices().getMyStory(curentLoggedInUser).then((value) {
      setState(() {
        mystory = value;
      });
    });
  }

  getcurrentPhoto() async {
    _currentphoto = FirebaseFirestore.instance
        .collection("users")
        .doc(curentLoggedInUser)
        .snapshots();
  }

  Future getFriends() async {
    StoryServices().getFriends().then((value) {
      setState(() {
        getFriendUsers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 48,
            child: FloatingActionButton(
              heroTag: Text("edit btn"),
              backgroundColor:Color.fromRGBO(16, 45, 49, 30),
              onPressed: () {},
              child: Icon(Icons.edit),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 48,
            child: FloatingActionButton(
              heroTag: Text("camera_alt"),
              backgroundColor:Color.fromRGBO(16, 45, 49, 30),
              onPressed: () {
                final picker = ImagePicker();
                picker
                    .pickImage(source: ImageSource.gallery, imageQuality: 40)
                    .then((file) async {
                  if (file == null) {
                    return null;
                  }

                  File editedfile =
                      await Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => StoryDesigner(
                                filePath: file.path,
                              )));

                  StoryServices().uploadToFirebaseStorage(editedfile);
                });
              },
              child: Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
      body: Container(
        color: Color.fromRGBO(16, 45, 49, 30),
        child: Padding(
          padding: const EdgeInsets.only(left: 2, top: 5),
          child: Column(children: [
            StreamBuilder<QuerySnapshot>(
              stream: mystory,
              builder: (context, snap) {
                if (snap.hasData &&snap.data!.docs.length !=0 && snap.connectionState == ConnectionState.active) {
                  var link = snap.data!.docs.last.get("storyLink");
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoryPageView(
                                    userid: curentLoggedInUser,
                                  )));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor:Colors.green,
                            child: CircleAvatar(
                          backgroundImage: NetworkImage(link),
                          radius: 28,
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "My status",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }
                {
                  return StreamBuilder<DocumentSnapshot>(
                      stream: _currentphoto,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 10,
                            ),
                          );
                        } else if (snapshot.connectionState ==ConnectionState.active && snapshot.hasData) {
                          photoUrl = snapshot.data!.get("Photourl");
                          return Column(
                            children: [
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.grey,
                                onTap: () {
                                  final picker = ImagePicker();
                                  picker
                                      .pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 40)
                                      .then((file) async {
                                    if (file == null) {
                                      return null;
                                    }

                                    File editedfile = await Navigator.of(
                                            context)
                                        .push(new MaterialPageRoute(
                                            builder: (context) => StoryDesigner(
                                                  filePath: file.path,
                                                )));

                                    StoryServices()
                                        .uploadToFirebaseStorage(editedfile);
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 70,
                                  child: ListTile(
                                    leading: Stack(children: [
                                      CircleAvatar(
                                        backgroundImage: photoUrl == ""
                                            ? AssetImage(
                                                "assets/images/avatar.jpg")
                                            : NetworkImage(photoUrl)
                                                as ImageProvider,
                                        radius: 30.0,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: CircleAvatar(
                                          radius: 12,
                                          child: Icon(
                                            Icons.add_circle,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ]),
                                    title: Text(
                                      "My Status ",
                                      style: GoogleFonts.firaSans(
                                        fontSize: 16,
                                        color:
                                            Color.fromRGBO(251, 251, 251, 20),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Tap to add status update",
                                      style: GoogleFonts.firaSans(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        } else
                          return Container();
                      });
                }
              },
            ),
            Container(
              height: 34,
              color: Color.fromRGBO(16, 45, 49, 30),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Recent Updates",
                    style: GoogleFonts.firaSans(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: getFriendUsers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Story")
                            .doc(getFriendUsers.elementAt(index))
                            .collection("Stories")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.length != 0 &&
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StoryPageView(
                                                  userid: getFriendUsers
                                                      .elementAt(index),
                                                )));
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.green,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(snapshot.data!.docs.first.get("storyLink"),
                                      ),radius: 28,),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${snapshot.data!.docs.first.get("username")}",
                                        style: GoogleFonts.firaSansCondensed(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          } else if (snapshot.hasError ||
                              snapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else
                            return Container();
                        }),
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
