import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ochat/screens/Chat.dart';
import 'package:ochat/screens/group.dart';

import '../services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class User {
  final String email;
  final String uid;

  User({required this.email, required this.uid});
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
//instance of auth
final FirebaseAuth _auth = FirebaseAuth.instance;

  //signOut user
void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 211, 56, 0),
        title:
        Image.asset('images/OChat.png', height: 100),
      actions: [
        // sign out button
        IconButton(onPressed: signOut, icon: const Icon(Icons.logout),)
      ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 211, 56, 0),
        unselectedItemColor: Colors.amber[400],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "chats",
            ),

           BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "groups",
            ),

           BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "profile",
           ),
         ],
        onTap: (int index) {
          if (index == 1) {
            // L'élément "Groups" a été cliqué
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => group(
                  receiverUserEmail: 'Passer votre email ici', // Remplacez par l'email requis
                  receiverUserID: 'Passer votre userID ici', // Remplacez par l'userID requis
                ),
              ),
            );
          }
        }
       ),
        body: buildUserList(),
     );
  }

      //buildList of users
   Widget buildUserList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Erreur');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text('Chargement...');
      }
      return ListView(
        children: snapshot.data!.docs
            .map<Widget>((doc) => buildUserListItem(doc))
            .toList(),
      );
    },
  );
}

Widget buildUserListItem(DocumentSnapshot document) {
  final data = document.data() as Map<String, dynamic>;
  final user = User(email: data['email'], uid: data['uid']);

  // Excluez l'utilisateur actuel de la liste
  if (user.uid != FirebaseAuth.instance.currentUser!.uid) {
return ListTile(
  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  title: Padding(
    padding: const EdgeInsets.only(right: 20.0), // Ajoutez le padding ici
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 211, 56, 0),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.account_circle, // Icône de profil
                    size: 24.0,
                    color: Color.fromARGB(255, 211, 56, 0), // Couleur de l'icône
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.all(20.0),
                  child: Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.yellow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              receiverUserEmail: user.email,
              receiverUserID: user.uid,
            ),
          ),
        );
      },
    );
  } else {
    return Container();
  }
}
}