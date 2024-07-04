import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ochat/screens/Chat.dart';
import 'package:ochat/screens/Home.dart';

class User {
  final String email;
  final String uid;

  User({required this.email, required this.uid});
}

class UserSearchDelegate extends SearchDelegate<User> {
  @override
  String get searchFieldLabel => 'Rechercher un utilisateur';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildUserList(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildUserList(query);
  }

  Widget buildUserList(String query) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThan: query + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Chargement...');
        }
        final users = snapshot.data!.docs
            .map<User>((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return User(email: data['email'], uid: data['uid']);
            })
            .where((user) => user.uid != FirebaseAuth.instance.currentUser!.uid)
            .toList();

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(users[index].email),
              onTap: () {
                close(context, users[index]);
              },
            );
          },
        );
      },
    );
  }
}

// Dans votre AppBar
