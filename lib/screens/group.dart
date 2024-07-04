
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User SignInUser;

class group extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const group({super.key, 
  required this.receiverUserEmail,
  required this.receiverUserID,
  });
  @override
  State<group> createState() => _groupState();
}

class _groupState extends State<group> {
  final TextEditingController _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? msgText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() {
    try {
    final user=_auth.currentUser;
      if (user != null) {
        SignInUser = user;
        print(SignInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 211, 56, 0),
        title: Text("group contient tous les utilisateur"),
      ),
      body: SafeArea(
        child: Column(         
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            msgStreamBuilder(),
            Container(),
            
            Container(
            decoration: BoxDecoration(
              
              border: Border.all(
                color: Color.fromARGB(255, 211, 56, 0),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      
                      child: TextField(
                        onChanged: (value) {
                        msgText = value;
                      },
                      style: TextStyle(
                      color: const Color.fromARGB(255, 254, 254, 253), // Définir la couleur du texte
                      ),
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          hintStyle: TextStyle(
                            color: Colors.white, // Changer la couleur du texte de saisie
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _firestore.collection('MSGS').add({
                        'text': msgText,
                        'sender': SignInUser.email,
                        'time': FieldValue.serverTimestamp(),
                      });
                      String message = _messageController.text;
                      _messageController.clear();
                    },
                    icon: Icon(
                      Icons.arrow_upward,
                      color: Color.fromARGB(255, 211, 56, 0),
                      size: 40,
                    ),
                  ),
                ]
              ),
            ),
          ]
        )
      )
      );
              // ],
             // ),
            // ),
           // ],
          // ),
         // ),
        // );
  }
}

class msgStreamBuilder extends StatelessWidget {
  const msgStreamBuilder({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('MSGS').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<msgLine> msgWidgets = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 211, 56, 0),
            ),
          );
        }
        final msgs = snapshot.data!.docs.reversed;
        for (var msg in msgs) {
          final msgText = msg.get('text');
          final msgSender = msg.get('sender');
          final currentUser = SignInUser.email;
          final msgWidget = msgLine(
            sender: msgSender,
            text: msgText,
            how: currentUser == msgSender,
            onLongPress: () {
              if (currentUser == msgSender) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color.fromARGB(255, 211, 56, 0),
                      title: Text('Delete Message'),
                      content: Text('Are you sure you want to delete this message?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            // Supprimer le message ici
                            _firestore.collection('MSGS').doc(msg.id).delete();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          );

          msgWidgets.add(msgWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: msgWidgets,
          ),
        );
      },
    );
  }
}

class msgLine extends StatelessWidget {
  const msgLine({required this.text, required this.sender, required this.how, this.onLongPress, Key? key});
  final String sender;
  final String text;
  final bool how;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: how ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              '$sender',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Material(
              elevation: 20,
              borderRadius: how ? BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ) : BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: how ? Color.fromARGB(255, 211, 56, 0) : Colors.amber[400],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '$text',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
