import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onpress;
  final double borderradius;
  final TextStyle textstyle;
  final double width;
  final double height;
  final Color color;

  CustomButton({
    required this.text,
    required this.onpress,
    required this.borderradius,
    required this.textstyle,
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onpress,
        child: Text(text, style: textstyle),
        style: TextButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderradius),
            
          ),
          side: BorderSide(color: Colors.white24),
          primary: Colors.white,
          textStyle: TextStyle(fontSize: 16.0),
          
        ),
      ),
    );
  }
}
