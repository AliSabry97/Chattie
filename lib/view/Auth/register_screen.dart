import 'dart:io';

import 'package:ecommerce_app/Widgets/CustomeButton.dart';
import 'package:ecommerce_app/view_model/AuthModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegisterScreen extends GetWidget<AuthViewModel> {
  final register_key = GlobalKey<FormState>();
  var _namecontroller = TextEditingController();
  var _emailcontroller = TextEditingController();
  var _passwordcontroller = TextEditingController();
  var _retypedpassword = TextEditingController();
  var _phonenumber=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(16, 45, 49, 30),
      ),
      body: Container(
        color: Color.fromRGBO(16, 45, 49, 30),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "CREATE NEW ACCOUNT, ",
                style: GoogleFonts.ubuntu(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Column(
                  children: [
                    GetX(builder: (AuthViewModel authviewmodel) {
                      return Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                authviewmodel.isImageProfileSet.value == true
                                    ? FileImage(File(
                                        authviewmodel.profileImagePath.value))as ImageProvider
                                    : AssetImage("assets/images/avatar.jpg"),
                            radius: 33,
                          ),
                          Positioned(
                            child: InkWell(
                              onTap: () {
                                authviewmodel.selectImage();
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                            bottom: 0,
                            right: 6,
                          ),
                        ],
                      );
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: register_key,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 550,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                        ),
                        child: Column(children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 100,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _namecontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Valid Username";
                                } else {
                                  _namecontroller.text = value.toString();
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "Name",
                                labelStyle: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width-100,
                            child: InternationalPhoneNumberInput(onInputChanged: (PhoneNumber phoneNumber){
                              print(phoneNumber);
                            },
                            
                            validator: (value){
                              if(value!.isEmpty){
                                return "Please Enter Valid Mobile Phone";
                                
                              }
                              else
                              _phonenumber.text=value.toString();
                
                            },
                          
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 100,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Valid Email";
                                } else {
                                  _emailcontroller.text = value.toString();
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "Email Address",
                                labelStyle: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 100,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Valid Password";
                                } else {
                                  _passwordcontroller.text = value.toString();
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 100,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty || _passwordcontroller.text != value.toString()) {
                                  return "Passwords Doesn't Match";
                                } else {
                                  _retypedpassword.text = value.toString();
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "Re-Type Password",
                                labelStyle: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          CustomButton(
                            width: MediaQuery.of(context).size.width - 100,
                            height: 40,
                            color: Color.fromRGBO(48, 96, 96, 30),
                            text: "SIGN UP ",
                            onpress: () {
                              if (register_key.currentState!.validate()) {
                                controller.name =
                                    _namecontroller.text.toString();
                                controller.email =
                                    _emailcontroller.text.toString();
                                controller.password =
                                    _passwordcontroller.text.toString();
                                controller.phone=_phonenumber.text.toString();
                
                                controller.registerInDatabase();
                              }
                            },
                            borderradius: 12,
                            textstyle: TextStyle(color: Colors.white),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
