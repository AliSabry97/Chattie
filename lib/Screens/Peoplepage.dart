
import 'package:ecommerce_app/Screens/SinglePerson.dart';
import 'package:ecommerce_app/view_model/People_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class PeoplePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(16, 45, 49, 30),
      child: Padding(
        padding: const EdgeInsets.only(left: 7.0, top: 12),
        child: GetX<PeopleController>(
          init: Get.put<PeopleController>(PeopleController()),
          builder: (PeopleController peopleController) {
              if( peopleController.users!=null)
          {
           
          return ListView.separated(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      Get.to(()=>SinglePerson(
                        img: peopleController.users![index].photo, 
                        name:  peopleController.users![index].name, 
                        askeduid:  peopleController.users![index].userid),);
                          
                    },
                    child: (Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:peopleController.users![index].photo == ""
                              ? AssetImage("assets/images/avatar.jpg")
                              : NetworkImage(peopleController.users![index].photo)as ImageProvider,
                          radius: 27,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                         peopleController.users![index].name ,
                          style: GoogleFonts.ubuntu(
                              fontSize: 23,
                              color: Color.fromRGBO(251, 251, 251, 20)),
                        ),
                      ],
                    )),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
               
                    height: 15,
                  );
                },
                itemCount: peopleController.users!.length);
          }
          else return Container();
          }
        ),
      ),
    );
  }
}
