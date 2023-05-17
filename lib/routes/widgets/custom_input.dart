import 'package:flutter/material.dart';

class CustomImput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textEditingController;
  final TextInputType keyboardTipe;
  final bool isPassword;

  const CustomImput({ 
    Key? key,
    required this.icon,
    required this.placeholder,
    required this.textEditingController,
    this.keyboardTipe = TextInputType.text,
    this.isPassword = false 
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),           
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0, 5),
          blurRadius: 5,                  
        ),
      ]
      ),            
      child: TextField(
        obscureText: this.isPassword,
        controller: this.textEditingController,
        autocorrect: false,
        keyboardType: this.keyboardTipe,
        decoration: InputDecoration(

          prefixIcon: Icon(this.icon), 
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: this.placeholder,


        ),

      )
            
    );
  }
}