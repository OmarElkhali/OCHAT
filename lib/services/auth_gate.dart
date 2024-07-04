import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ochat/screens/Home.dart';
import 'package:ochat/screens/welcome.dart';

class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is loggin in 
          if (snapshot.hasData){
            return const Home();
          }
          // user not loggin
          else{
            return const welcomS();
          }
        
      },)
    );
  }
}