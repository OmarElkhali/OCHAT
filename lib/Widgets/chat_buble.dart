import 'package:flutter/material.dart';
class ChatBubble extends StatefulWidget {
  final String message;
  final bool isCurrentUser;
   final Color bubbleColor;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    required this.bubbleColor,
  }) : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {

    // final alignment = widget.isCurrentUser ? Alignment.topRight : Alignment.centerLeft;


    return Container(
      // alignment: alignment,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.bubbleColor,
      ),
      child: Text(
        widget.message,
        style: const TextStyle(fontSize: 14, color: Colors.white), // Couleur du texte
      ),
    );
  }
}
