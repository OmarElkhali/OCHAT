import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService extends ChangeNotifier{
  // instance of auth
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  // instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign in user
  Future<UserCredential>signInWithEmailAndPassword(String email,String password) async {
    try{
      // sign in 
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password,
        );
      //add a new documment for the user in users collection if it doesn't already exists
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email':email,
       },
       SetOptions(merge:true)
       );
      return userCredential;
    }
    //catch any errors
    on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }
  // sign user out
  Future<void>signOut()async{
    return await FirebaseAuth.instance.signOut();
  }
  // create a new user
  Future<UserCredential> signUpWithEmailandPasseword(String email, password) async{
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
        );
        //creating a documment for the user
       _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email':email,
       });
        return userCredential;
    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }


}