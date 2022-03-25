import 'dart:ui';


import 'package:ecommerce_app/Widgets/CustomeButton.dart';
import 'package:ecommerce_app/view/Auth/register_screen.dart';
import 'package:ecommerce_app/view_model/AuthModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LoginScreen extends GetWidget<AuthViewModel> {
  
  TextEditingController _emailaddress = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(16, 45, 49, 30),
      ),
      body: Container(
        color: Color.fromRGBO(16, 45, 49, 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset("assets/images/chat-box.png",height: 40,),
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => RegisterScreen());
                  },
                  child: Text(
                    "Sign Up ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13),
                child: Text(
                  "Welcome Back,",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Sign in to Continue",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 0.1,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.white),
                    child: Column(children: [
                      
                      Column(
                        children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: TextFormField(
                            controller: _emailaddress,
                            validator: (value){
                               if(value!.isEmpty){
                
                                return " Enter Valid Email Address";
                               }
                               else
                              _emailaddress.text=value.toString();
                              
                            
                            },
                           
                            keyboardType: TextInputType.text,
                            decoration:
                                InputDecoration(labelText: "Email Address"),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          child: TextFormField(
                            controller: _password,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                             validator: (value){
                               if(value!.isEmpty){
                
                                return " passowrd  must be at least 6 charachters";
                               }
                               else
                              _password.text=value.toString();
                              
                            
                            },
                            decoration: InputDecoration(
                                labelText: "Password",
                                
                                 
                                labelStyle: TextStyle(
                                    
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            "Forgot Password ? ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Color.fromRGBO(207, 151, 70, 20)),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        CustomButton(
                          color: Color.fromRGBO(48, 96, 96, 30),
                          width: MediaQuery.of(context).size.width - 50,
                          height: 50,
                          text: "SIGN IN ",
                          onpress: () {
                            if (_formKey.currentState!.validate()) {
                              controller.email=_emailaddress.text.toString();
                              controller.password=_password.text.toString();
                              controller.signInWithEmailAndPassword();
                            }
                          },
                          borderradius: 12,
                          textstyle: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 50,
                          child: TextButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/facebook.png",
                                ),
                                SizedBox(
                                  width: 40.0,
                                ),
                                Text(
                                  ("SIGN IN WITH FACEBOOK "),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(width: 1),
                              ),
                              primary: Colors.black,
                              textStyle: TextStyle(fontSize: 15.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 50.0,
                          child: TextButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/google.png",
                                ),
                                SizedBox(
                                  width: 40.0,
                                ),
                                Text(
                                  "SIGN IN WITH GOOGLE ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(width: 1),
                              ),
                              primary: Colors.black,
                              textStyle: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                      ]),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
