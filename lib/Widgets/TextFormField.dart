import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labeltext;
  final bool obscuretext;
  final String? Function(String?)? validate;

  CustomTextFormField({
    required this.labeltext,
    required this.obscuretext,
    required this.validate,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        validator: validate,
        obscureText: obscuretext,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: TextStyle(color: Colors.white),
          
          border: OutlineInputBorder(
            
            borderSide: BorderSide( color: Colors.white),
          ),
        ),
      ),
    );
  }
}
