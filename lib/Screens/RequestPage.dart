import 'package:ecommerce_app/Home/HomeScreen.dart';
import 'package:ecommerce_app/services/Firestoreserv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  List requestList = [];
  var finalvalue;
  bool addfriend=false;
  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  void fetchRequests() async {
    dynamic usersList;

    usersList = await Firestoreservice().fetchRequests();
    if (usersList == null) {
      print("no users found");
    } else {
      setState(() {
        requestList = usersList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
       Scaffold(
         appBar: AppBar(backgroundColor:  Color.fromRGBO(16, 45, 49, 30),title: Text("Friend Requests"),leading:IconButton(

           icon: Icon(Icons.arrow_back,color: Colors.white,),
           onPressed: (){

             Get.offAll(()=>HomeScreen());
           },
         )),
          body:  Container(
          color:Color.fromRGBO(16, 45, 49, 30),
          child: Padding(
            padding: const EdgeInsets.only(left: 7.0, top: 12, right: 10),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: (Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: (requestList[index]['Photourl'] == "")
                            ? AssetImage("assets/images/avatar.jpg")
                            : NetworkImage(requestList[index]['Photourl'])
                                as ImageProvider,
                        radius: 35,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        requestList[index]["name"],
                        style: GoogleFonts.firaSans(
                          fontSize: 23,
                          color: Color.fromRGBO(255, 255, 255, 40),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        child: Image.asset(
                          "assets/images/accept.png",
                          width: 40,
                          height: 50,
                          color: Colors.white,
                        ),
                        
                        mouseCursor: MaterialStateMouseCursor.clickable,
                        onTap: (){
                        Firestoreservice().acceptRequest(requestList[index]["user_id"]);
                            setState(() {
                              requestList.removeAt(index);
                            });
                          
                        } ,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        mouseCursor: MaterialStateMouseCursor.clickable,
                        onTap: (){
           
                        },
                        child: Image.asset(
                          "assets/images/no-touch.png",
                          width: 40,
                          height: 50,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
                );
              },
              separatorBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.white,
                      height: 10,
                    ),
                  ],
                );
              },
              itemCount: requestList.length,
            ),
          ),
             
           ),
       );
  }
 


}






