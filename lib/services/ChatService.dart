import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ochat/model/message.dart';



class Chatservice extends ChangeNotifier{
//get instance of auth and firestore
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Send msg

Future<void> sendMessage (String receiverID, String message) async {
//get current user info 
final String currentUserId = _firebaseAuth.currentUser!.uid;
final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
final Timestamp timestamp = Timestamp.now();

Future<void> deleteMessage(String messageId, String userId, String otherUserId) async {
  // Construisez l'ID de la salle de discussion à partir des ID des utilisateurs
  List<String> ids = [userId, otherUserId];
  ids.sort();
  String chatRoomId = ids.join("_");

  // Supprimez le message spécifié de la base de données
  await _firestore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .doc(messageId) // Utilisez l'ID du message pour le supprimer
      .delete();
}

// create a new message
Message newMessage = Message(
  senderId: currentUserId,
   senderEmail: currentUserEmail, 
   receiverID: receiverID, 
   timestamp: timestamp, 
   message: message,
   );

// construct chat room id from current user id and receiver id 
List<String> ids = [currentUserId,receiverID];
ids.sort();//sort the ids 
String chatroomId = ids.join(
  "_"
);// combine the ids into a single string to use as a chatroomId


// add new message to database
await _firestore
          .collection('chat_rooms')
          .doc(chatroomId)
          .collection('messages')
          .add(newMessage.toMap());
}

//get messages
Stream<QuerySnapshot> getMessages(String userId , String otherUserId){
  //construct chat room id from user ids
  List<String> ids = [userId, otherUserId];
  ids.sort();
  String chatRoomId = ids.join("_");
  return _firestore
  .collection('chat_rooms')
  .doc(chatRoomId)
  .collection('messages')
  .orderBy('timestamp',descending: false)
  .snapshots();
}

}
