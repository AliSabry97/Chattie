import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecommerce_app/services/StoryServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:story_view/story_view.dart';

class StoryPageView extends StatefulWidget {
  String userid;

  StoryPageView({required this.userid});

  @override
  State<StoryPageView> createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  Stream<QuerySnapshot>? userstories;
  Stream<DocumentSnapshot>? userinfo;
  StoryController storyController = StoryController();
  Future getStories() async {
    print(widget.userid);
    StoryServices().getAllStoriesForFriends(widget.userid).then((value) {
      setState(() {
        userstories = value;
      });
    });
  }

  Future getUserInfo() async {
    StoryServices().getUserInfo(widget.userid).then((value) {
      setState(() {
        userinfo = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getStories();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: StreamBuilder<DocumentSnapshot>(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData) {
              return Row(children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data!.get("Photourl")),
                  radius: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("${snapshot.data!.get("name")}",
                    style:
                        GoogleFonts.ubuntu(color: Colors.white, fontSize: 20))
              ]);
            } else
              return Container();
          },
          stream: userinfo,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: StreamBuilder<QuerySnapshot>(
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.active &&
                snap.hasData) {
              List<String> links = [];

              snap.data!.docs.forEach((element) {
                links.add(element.get("storyLink"));
              });

              List<StoryItem> stories = [];
              links.forEach((element) {
                stories.add(StoryItem.pageImage(
                    url: element, controller: storyController));
              });

              print(stories.length);

              return StoryView(
                storyItems: stories,
                controller: storyController,
                onComplete: () => Navigator.pop(context),
              );
            } else
              return Container();
          },
          stream: userstories,
        ),
      ),
    );
  }
}
