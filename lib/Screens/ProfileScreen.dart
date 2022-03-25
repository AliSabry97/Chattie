import 'dart:io';

import 'package:ecommerce_app/Constants/MyColors.dart';
import 'package:ecommerce_app/Home/HomeScreen.dart';
import 'package:ecommerce_app/Widgets/CustomeButton.dart';
import 'package:ecommerce_app/services/Firestoreserv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double height;
  late double width;
  String imgurl = "";
  File? file;
ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    readphoto();
  }

  void readphoto() async {
    String url;
    url = await Firestoreservice().readPhotourl();
    if (url.isEmpty)
    {

      print("no photos found");
    }
    setState(() {
      imgurl = url;

    });
  }

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
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image(
                    height: 400.0,
                    width: width,
                    fit: BoxFit.cover,
                    image: imgurl.isEmpty
                        ? AssetImage("assets/images/avatar.jpg")
                        : NetworkImage(imgurl) as ImageProvider)),
            SizedBox(
              height: 30,
            ),

             
           Container(
             width: MediaQuery.of(context).size.width-50,
             child: TextButton(
                              onPressed: () {
                                select_Image();
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
        ),
      ),
    );
  }



  Future select_Image() async {
   final imageFile;
   String downloadurl;
   SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    

    try {
      imageFile = await imagePicker.pickImage(source: ImageSource.gallery,imageQuality: 20);

    
      
      file=File(imageFile.path);
    
      
     downloadurl= await Firestoreservice().uploadToDatabase(file);
     
     setState(() {
       imgurl=downloadurl;
       sharedPreferences.setString("photourl", imgurl);
     });
   

    } catch (e) { 
      print("You Got an Error! $e");
    }
  }

 
}
