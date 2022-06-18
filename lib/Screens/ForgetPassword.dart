import 'package:ecommerce_app/Widgets/CustomeButton.dart';
import 'package:ecommerce_app/view_model/AuthModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPassword extends GetView<AuthViewModel> {
   TextEditingController emailcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(16, 45, 49, 30),
      ),
      body: Container(
        color: Color.fromRGBO(16, 45, 49, 30),
        child: Column( 
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              controller: emailcontroller,
              decoration: InputDecoration(
                hintText: "Enter Your Email",
                hintStyle: GoogleFonts.ubuntu(color: Colors.grey),
                
                prefixIcon: Icon(Icons.email_outlined,color: Colors.white,)
              ),
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              
            ),
          ),


          SizedBox(
            height: 40,
          ),


          Align(
            alignment: Alignment.center,
            child: CustomButton(
                text: "Reset Passowrd",
                onpress: () {
                  controller.resetPassword(emailcontroller.text.toString());
                },
                borderradius: 20,
                textstyle: GoogleFonts.ubuntu(
                  color: Colors.white,
                ),
                width: 250,
                height: 50,
                color: Color.fromRGBO(16, 45, 49, 30)),
          )
        ]),
      ),
    );
  }
}
