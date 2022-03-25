import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Screens/SinglePerson.dart';
import 'package:ecommerce_app/services/Firestoreserv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class PeoplePage extends StatefulWidget {
  @override
  _PeoplePageState createState() => _PeoplePageState();
  
}

class _PeoplePageState extends State<PeoplePage> {

  // ignore: non_constant_identifier_names
  late String user_clicked;
  late String image_url;
Stream <QuerySnapshot>? getUsers;
  @override
  void initState() {
    super.initState();
    getFettched();
  }

  void getFettched() async {
     await Firestoreservice().get_users().then((value){

        if(value==null){

          return "No Users Registered Yet";
        }
        else
        {

          if(mounted){

            setState(() {
              getUsers=value;
            });
          }
        }


    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(16, 45, 49, 30),
      child: Padding(
        padding: const EdgeInsets.only(left: 7.0, top: 12),
        child: StreamBuilder<QuerySnapshot>(
          stream: getUsers,
          builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting)
          {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 10,
              ),
            );
          }
            return snapshot.hasData?
               AnimationLimiter(
                 child: ListView.separated(
                  itemBuilder: (context, index) {
                    image_url = snapshot.data!.docs[index].get("Photourl");
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const  Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: InkWell(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SinglePerson(
                                            img:snapshot.data!.docs[index].get("Photourl"),
                                            name: snapshot.data!.docs[index].get("name"),
                                            askeduid: snapshot.data!.docs[index].get("user_id"),
                                          )));
                            },
                            child: (Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:snapshot.data!.docs[index].get("Photourl") == ""
                                      ? AssetImage("assets/images/avatar.jpg")
                                      : NetworkImage(snapshot.data!.docs[index].get("Photourl"))as ImageProvider,
                                  radius: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  snapshot.data!.docs[index].get("name"),
                                  style: GoogleFonts.firaSans(
                                      fontSize: 23,
                                      color: Color.fromRGBO(251, 251, 251, 20)),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
               
                      height: 15,
                    );
                  },
                  itemCount: snapshot.data!.docs.length),
               )
                :Container();
          }
        ),
      ),
    );
  }
}
