import 'package:ecommerce_app/Constants/MyColors.dart';
import 'package:ecommerce_app/Widgets/CustomeButton.dart';
import 'package:ecommerce_app/Widgets/TextFormField.dart';
import 'package:ecommerce_app/view_model/AuthModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterScreen extends GetWidget<AuthViewModel> {
  final register_key = GlobalKey<FormState>();
  var _namecontroller=TextEditingController();
  var _emailcontroller=TextEditingController();
  var _passwordcontroller=TextEditingController();
  var _retypedpassword=TextEditingController();


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
                    "CREATE NEW ACCOUNT,, ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500),
                  ),
              SizedBox(
                height: 50.0,
              ),
              Center(
                child: Form(
                  key: register_key,
                  child: Container(
                  
                    width: MediaQuery.of(context).size.width-20,
                    height: 550,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft:Radius.circular(30),
                          bottomRight: Radius.circular(30)
                           ),
                          
                    ),
                    child: Column(
                      children:[
                          Container(
                            width: MediaQuery.of(context).size.width-100,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller:_namecontroller ,
                              validator: (value){
                                if(value!.isEmpty){

                                  return "Please Enter Valid Username";
                                }
                                else
                                {
                                  _namecontroller.text=value.toString();
                                }

                              },
                    decoration: InputDecoration(
                     
                      
                      labelText: "Name"
                    ),
                  ),
                          ),
                     
                      SizedBox(
                    height: 40.0,
                  ),
                   Container(
                      width: MediaQuery.of(context).size.width-100,
                     child: TextFormField(
                      keyboardType:TextInputType.emailAddress,
                       validator: (value){
                                if(value!.isEmpty){

                                  return "Please Enter Valid Email";
                                }
                                else
                                {
                                  _emailcontroller.text=value.toString();
                                }

                              },
                       decoration: InputDecoration(
                         labelText: "Email Address",
                       ),
                       ),
                   ),
                          
                    SizedBox(
                    height: 40.0,
                  ),
                          
                           Container(
                             width: MediaQuery.of(context).size.width-100,
                             child: TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                         validator: (value){
                                if(value!.isEmpty){

                                  return "Please Enter Valid Password";
                                }
                                else
                                {
                                  _passwordcontroller.text=value.toString();
                                }

                              },
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
                        ),
                           ),

                            SizedBox(height: 30,),
                            Container(
                             width: MediaQuery.of(context).size.width-100,
                             child: TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                         validator: (value){
                                if(value!.isEmpty || _passwordcontroller.text!=value.toString()){

                                  return "Passwords Doesn't Match";
                                }
                                else
                                {
                                  _retypedpassword.text=value.toString();
                                }

                              },
                          decoration: InputDecoration(
                            labelText: "Re-Type Password",
                          ),
                        ),
                           ),
                          
                            SizedBox(height: 40,),
                  CustomButton(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 40,
                    color: Color.fromRGBO(48, 96, 96, 30),
                    text: "SIGN UP ",
                    onpress: () {
                      if(register_key.currentState!.validate()){

                          controller.name=_namecontroller.text.toString();
                          controller.email=_emailcontroller.text.toString();
                          controller.password=_passwordcontroller.text.toString();


                          controller.registerInDatabase();

                        
                        
                      }
                    },
                    borderradius: 12,
                    textstyle: TextStyle( color: Colors.white),
                  ),
                      ] 
                    ),
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
