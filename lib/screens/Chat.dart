import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ochat/Widgets/chat_buble.dart';
import 'package:ochat/services/ChatService.dart';

class Chat extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;

  Chat({
    Key? key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  final Chatservice _chatservice = Chatservice();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

     // Ajout d'un ScrollController
  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatservice.sendMessage(widget.receiverUserID, _messageController.text);
      _messageController.clear();

    // Faites défiler vers le bas lorsque vous envoyez un message
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }


  // Ajout d'une fonction pour déterminer si l'utilisateur actuel est l'expéditeur
  bool isCurrentUser(String? senderId) {
    return senderId == _firebaseAuth.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 211, 56, 0),
        title: Text(widget.receiverUserEmail),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _buildMessageList(),
          ),
          // User input
          _buildMessageInput(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatservice.getMessages(
        widget.receiverUserID,
        _firebaseAuth.currentUser?.uid ?? "",
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
           controller: _scrollController,
          children: snapshot.data?.docs.map((document) {
            return _buildMessageItem(document);           
          }).toList() ?? [],
        );
      },
    );
  }

  // Build message item
Widget _buildMessageItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  final String messageId = document.id; // ID du message

  // Determine alignment based on sender
  var alignment = isCurrentUser(data['senderId']) ? Alignment.centerRight : Alignment.centerLeft;

  return Dismissible(
    key: Key(messageId), // Utilisez l'ID du message comme clé
    background: Container(
      color: Colors.red, // Couleur d'arrière-plan pour la suppression
      child: Icon(
        Icons.delete,
        color: Colors.white,
        size: 30,
      ),
    ),
    direction: DismissDirection.endToStart, // Swipe de droite à gauche pour supprimer
    confirmDismiss: (direction) async {
      if (direction == DismissDirection.endToStart) {
        // Affichez une boîte de dialogue de confirmation pour supprimer le message
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Supprimer le message ?'),
              content: Text('Êtes-vous sûr de vouloir supprimer ce message ?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Annuler la suppression
                  },
                  child: Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Confirmer la suppression
                  },
                  child: Text('Supprimer'),
                ),
              ],
            );
          },
        );
      }
      return false;
    },

    child: Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: isCurrentUser(data['senderId'])
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              data['senderEmail'] ?? "",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            ChatBubble(
              message: data['message'] ?? "",
              isCurrentUser: isCurrentUser(data['senderId']),
              bubbleColor: isCurrentUser(data['senderId'])
                  ? Color.fromARGB(255, 211, 56, 0)
                  : Colors.grey,
            )
          ],
        ),
      ),
    ),
  );
}


  // Build message input
 Widget _buildMessageInput() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Row(
      children: [
        // Text field
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 211, 56, 0),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10.0),
              ),
              style: TextStyle(
                color: Colors.white, // Couleur du texte saisi
              ),
              obscureText: false,
            ),
          ),
        ),
        // Send button
        IconButton(
          onPressed: sendMessage,
          icon: Icon(
            Icons.arrow_upward,
            size: 40,
            color: Color.fromARGB(255, 211, 56, 0),
          ),
        ),
      ],
    ),
  );
}

}


























// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// final _firestore = FirebaseFirestore.instance;
// late User SignInUser;

// class Chat extends StatefulWidget {
//   final String receiverUserEmail;
//   final String receiverUserID;
//   const Chat({super.key, 
//   required this.receiverUserEmail,
//   required this.receiverUserID,
//   });
//   @override
//   State<Chat> createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   final TextEditingController _messageController = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//   String? msgText;

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//   }
//   void getCurrentUser() {
//     try {
//     final user=_auth.currentUser;
//       if (user != null) {
//         SignInUser = user;
//         print(SignInUser);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 0, 0, 0),
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 211, 56, 0),
//         title: Text(widget.receiverUserEmail),
//       ),
//       body: SafeArea(
//         child: Column(         
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             msgStreamBuilder(),
//             Container(),
//             Container(
//               decoration: BoxDecoration(
//                 border: Border(
//                   top: BorderSide(
//                     color: Color.fromARGB(255, 211, 56, 0),
//                     width: 4,
//                   ),
//                 ),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: TextField(
//                          onChanged: (value) {
//                          msgText = value;
//                        },
//                       style: TextStyle(
//                       color: const Color.fromARGB(255, 254, 254, 253), // Définir la couleur du texte
//                       ),
//                         controller: _messageController,
//                         decoration: InputDecoration(
//                           hintText: 'Type a message',
//                           hintStyle: TextStyle(
//                             color: Colors.white, // Changer la couleur du texte de saisie
//                           ),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       _firestore.collection('MSGS').add({
//                         'text': msgText,
//                         'sender': SignInUser.email,
//                         'time': FieldValue.serverTimestamp(),
//                       });
//                       String message = _messageController.text;
//                       _messageController.clear();
//                     },
//                     icon: Icon(
//                       Icons.send,
//                       color: Color.fromARGB(255, 211, 56, 0),
//                       size: 24.0,
//                     ),
//                   ),
//                 ]
//               ),
//             )
//           ]
//         )
//       )
//       );
//               // ],
//              // ),
//             // ),
//            // ],
//           // ),
//          // ),
//         // );
//   }
// }

// class msgStreamBuilder extends StatelessWidget {
//   const msgStreamBuilder({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection('MSGS').orderBy('time').snapshots(),
//       builder: (context, snapshot) {
//         List<msgLine> msgWidgets = [];
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(
//               backgroundColor: Color.fromARGB(255, 211, 56, 0),
//             ),
//           );
//         }
//         final msgs = snapshot.data!.docs.reversed;
//         for (var msg in msgs) {
//           final msgText = msg.get('text');
//           final msgSender = msg.get('sender');
//           final currentUser = SignInUser.email;
//           final msgWidget = msgLine(
//             sender: msgSender,
//             text: msgText,
//             how: currentUser == msgSender,
//             onLongPress: () {
//               if (currentUser == msgSender) {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       backgroundColor: Color.fromARGB(255, 211, 56, 0),
//                       title: Text('Delete Message'),
//                       content: Text('Are you sure you want to delete this message?'),
//                       actions: [
//                         TextButton(
//                           child: Text('Cancel'),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                         TextButton(
//                           child: Text('Delete'),
//                           onPressed: () {
//                             // Supprimer le message ici
//                             _firestore.collection('MSGS').doc(msg.id).delete();
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               }
//             },
//           );

//           msgWidgets.add(msgWidget);
//         }
//         return Expanded(
//           child: ListView(
//             reverse: true,
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//             children: msgWidgets,
//           ),
//         );
//       },
//     );
//   }
// }

// class msgLine extends StatelessWidget {
//   const msgLine({required this.text, required this.sender, required this.how, this.onLongPress, Key? key});
//   final String sender;
//   final String text;
//   final bool how;
//   final VoidCallback? onLongPress;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onLongPress: onLongPress,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: how ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Text(
//               '$sender',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color.fromARGB(255, 255, 255, 255),
//               ),
//             ),
//             Material(
//               elevation: 20,
//               borderRadius: how ? BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ) : BorderRadius.only(
//                 topRight: Radius.circular(30),
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//               color: how ? Color.fromARGB(255, 211, 56, 0) : Colors.amber[400],
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                 child: Text(
//                   '$text',
//                   style: TextStyle(fontSize: 17),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//      );
//   }
// }
