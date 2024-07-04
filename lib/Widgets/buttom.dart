import 'package:flutter/material.dart';
class SCButtom extends StatelessWidget {

  SCButtom(
  {
  required this.color,
  required this.title,
  required this.onPressed
  }
  );
  final Color color;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
      elevation: 8,
      color: color,
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
      onPressed: onPressed,
      minWidth: 200,
      height: 42,
      child: Text(
          title,
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      ),
    );
  }
}